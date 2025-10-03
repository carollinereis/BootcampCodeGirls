import json
import boto3
import os
import decimal
from decimal import Decimal
import urllib.parse

class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, decimal.Decimal):
            return str(o) 
        return super(DecimalEncoder, self).default(o)

localstack_hostname = os.environ.get('LOCALSTACK_HOSTNAME', 'localhost')
endpoint_url = f'http://{localstack_hostname}:4566'

dynamodb = boto3.resource('dynamodb', endpoint_url=endpoint_url, region_name="us-east-1")
s3_client = boto3.client('s3', endpoint_url=endpoint_url, region_name="us-east-1")
table = dynamodb.Table('NotasFiscais')

def lambda_handler(event, context):
    print("Evento recebido:", json.dumps(event))

    if 'httpMethod' in event:
        # Lógica da API Gateway (GET e POST) - continua a mesma
        http_method = event['httpMethod']
        if http_method == 'GET':
            try:
                response = table.scan()
                items = response.get('Items', [])
                return {"statusCode": 200, "headers": {"Content-Type": "application/json"}, "body": json.dumps(items, cls=DecimalEncoder)}
            except Exception as e:
                return {"statusCode": 500, "body": json.dumps({"error": "Erro ao acessar o banco de dados."})}
        elif http_method == 'POST':
            body = event.get('body')
            if not body:
                return {"statusCode": 400, "body": json.dumps({"error": "Corpo da requisição ausente."})}
            try:
                data = json.loads(body, parse_float=Decimal)
                table.put_item(Item=data)
                return {"statusCode": 201, "headers": {"Content-Type": "application/json"}, "body": json.dumps({"message": "Nota gravada com sucesso!", "nota": data}, cls=DecimalEncoder)}
            except Exception as e:
                return {"statusCode": 400, "body": json.dumps({"error": "Corpo da requisição inválido."})}
    
    elif 'Records' in event:
        print("Evento do S3 recebido.")
        try:
            bucket_name = event['Records'][0]['s3']['bucket']['name']
            file_key = event['Records'][0]['s3']['object']['key']
            decoded_key = urllib.parse.unquote_plus(file_key)
            print(f"Lendo arquivo '{decoded_key}' do bucket '{bucket_name}'")
            
            response = s3_client.get_object(Bucket=bucket_name, Key=decoded_key)
            content = response['Body'].read().decode('utf-8')
            
            # MUDANÇA FINAL: Carrega a lista e itera sobre ela
            lista_de_notas = json.loads(content, parse_float=Decimal)
            for nota in lista_de_notas:
                print(f"Salvando item do S3: {nota.get('id')}")
                table.put_item(Item=nota)
            
            print("Todos os dados do S3 foram salvos no DynamoDB com sucesso.")
            return {"status": "success"}
        except Exception as e:
            print(f"Erro ao processar arquivo do S3: {e}")
            return {"status": "error", "message": str(e)}

    return {"statusCode": 400, "body": json.dumps({"message": "Requisição não suportada ou evento desconhecido."})}