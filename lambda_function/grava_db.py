# grava_db.py

import json
import boto3
import os
import decimal

# Classe auxiliar para converter o tipo Decimal do DynamoDB, que não é compatível com JSON
class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, decimal.Decimal):
            return float(o)
        return super(DecimalEncoder, self).default(o)

# Pega o hostname do LocalStack de uma variável de ambiente.
# Isso garante que o código funcione de dentro do container da Lambda.
localstack_hostname = os.environ.get('LOCALSTACK_HOSTNAME', 'localhost')
endpoint_url = f'http://{localstack_hostname}:4566'

# Cria o cliente do DynamoDB apontando para o endpoint correto do LocalStack
dynamodb = boto3.resource(
    'dynamodb',
    endpoint_url=endpoint_url,
    region_name="us-east-1"
)

# Referência da tabela do DynamoDB
table = dynamodb.Table('NotasFiscais')

def lambda_handler(event, context):
    """
    Handler da Lambda que lida com requisições GET (para listar) e POST (para criar).
    """
    print("Evento recebido:", event)
    
    # Verifica se a requisição é um GET (vem da API sem corpo) ou um POST (com corpo)
    if event.get('httpMethod') == 'GET':
        # Se for GET, escaneia a tabela e retorna todos os itens
        try:
            response = table.scan()
            items = response.get('Items', [])
            
            # Retorna os itens, usando o DecimalEncoder para formatar a resposta corretamente
            return {
                "statusCode": 200,
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps(items, cls=DecimalEncoder)
            }
        except Exception as e:
            print(e)
            return {"statusCode": 500, "body": json.dumps({"error": "Erro ao acessar o banco de dados."})}
    
    # Se não for GET, assume que é um evento com 'body' (de um POST da API ou outro serviço)
    body = event.get('body')
    if body:
        try:
            data = json.loads(body)
            # Grava o item no DynamoDB
            table.put_item(Item=data)
            return {
                "statusCode": 201, # 201 Created é o status correto para criação
                "headers": {"Content-Type": "application/json"},
                "body": json.dumps({"message": "Nota gravada com sucesso!", "nota": data})
            }
        except Exception as e:
            print(e)
            return {"statusCode": 400, "body": json.dumps({"error": "Corpo da requisição inválido."})}

    # Caso seja um evento que não se encaixa em nenhum dos casos (ex: teste manual sem httpMethod)
    return {
        "statusCode": 400,
        "body": json.dumps({"message": "Requisição não suportada."})
    }