#!/bin/bash

# -----------------------------------------------------------------------------
# Script para criação da infraestrutura Serverless de Notas Fiscais no LocalStack
# -----------------------------------------------------------------------------
# Este script automatiza a criação de todos os recursos AWS necessários
# para a aplicação, incluindo S3, DynamoDB, Lambda e API Gateway.
#
# Pré-requisito: Ter o 'jq' instalado para processar saídas JSON.
# (Ex: brew install jq / sudo apt-get install jq)
# -----------------------------------------------------------------------------

set -eo pipefail # Faz o script parar imediatamente se algum comando falhar

# --- SEÇÃO 1: Variáveis de Configuração ---
# Centralize todos os nomes aqui para facilitar futuras modificações.
REGION="us-east-1"
ACCOUNT_ID="000000000000" # ID padrão do LocalStack

BUCKET_NAME="notas-fiscais-upload"
TABLE_NAME="NotasFiscais"
LAMBDA_FUNCTION_NAME="ProcessaNotaFiscal"
API_NAME="NotasFiscaisAPI"
LAMBDA_ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/qualquer-role-para-localstack"

# --- SEÇÃO 2: Criação dos Recursos ---

echo -e "\n[PASSO 1 de 7] Criando o bucket no S3..."
# O bucket S3 servirá como porta de entrada (trigger) para os novos arquivos.
awslocal s3api create-bucket \
    --bucket $BUCKET_NAME \
    --region $REGION

echo -e "\n[PASSO 2 de 7] Criando a tabela no DynamoDB..."
# O DynamoDB armazenará os dados das notas fiscais processadas pela Lambda.
awslocal dynamodb create-table \
    --table-name $TABLE_NAME \
    --attribute-definitions AttributeName=id,AttributeType=S \
    --key-schema AttributeName=id,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

echo -e "\n[PASSO 3 de 7] Empacotando o código da função Lambda..."
# O código Python precisa ser compactado em um arquivo .zip para o deploy.
# O --junk-paths remove a estrutura de diretórios de dentro do zip.
zip --junk-paths lambda_function.zip lambda_function/grava_db.py

echo -e "\n[PASSO 4 de 7] Criando a função Lambda..."
# Esta função contém a lógica de negócio principal.
awslocal lambda create-function \
    --function-name $LAMBDA_FUNCTION_NAME \
    --runtime python3.9 \
    --handler grava_db.handler \
    --memory-size 128 \
    --zip-file fileb://lambda_function.zip \
    --role $LAMBDA_ROLE_ARN

# Capturamos o ARN (Amazon Resource Name) da Lambda para usar depois.
LAMBDA_ARN=$(awslocal lambda get-function --function-name $LAMBDA_FUNCTION_NAME | jq -r '.Configuration.FunctionArn')

echo -e "\n[PASSO 5 de 7] Configurando o trigger do S3 para a Lambda..."
# Aqui, conectamos o S3 à Lambda. Qualquer arquivo criado no bucket
# irá invocar automaticamente nossa função.
awslocal s3api put-bucket-notification-configuration \
    --bucket $BUCKET_NAME \
    --notification-configuration '{
        "LambdaFunctionConfigurations": [{
            "LambdaFunctionArn": "'"$LAMBDA_ARN"'",
            "Events": ["s3:ObjectCreated:*"]
        }]
    }'

# --- SEÇÃO 3: Criação da API Gateway ---
echo -e "\n[PASSO 6 de 7] Criando e configurando a API Gateway..."

# A MÁGICA DA AUTOMAÇÃO:
# Não podemos usar IDs fixos. O script a seguir cria um recurso,
# extrai o ID da resposta JSON usando 'jq', e o armazena em uma
# variável para usar no próximo comando.

# 6.1. Cria a API e captura o ID
API_ID=$(awslocal apigateway create-rest-api --name "$API_NAME" | jq -r '.id')
echo "   - API Gateway criada com ID: $API_ID"

# 6.2. Obtém o ID do recurso raiz ("/")
ROOT_RESOURCE_ID=$(awslocal apigateway get-resources --rest-api-id $API_ID | jq -r '.items[] | select(.path == "/") | .id')

# 6.3. Cria o recurso "/notas" abaixo do recurso raiz
NOTAS_RESOURCE_ID=$(awslocal apigateway create-resource --rest-api-id $API_ID --parent-id $ROOT_RESOURCE_ID --path-part "notas" | jq -r '.id')
echo "   - Recurso /notas criado com ID: $NOTAS_RESOURCE_ID"

# 6.4. Cria o método GET para permitir consultas
awslocal apigateway put-method --rest-api-id $API_ID --resource-id $NOTAS_RESOURCE_ID --http-method GET --authorization-type "NONE"

# 6.5. Integra o método GET com a Lambda via AWS_PROXY
awslocal apigateway put-integration \
    --rest-api-id $API_ID \
    --resource-id $NOTAS_RESOURCE_ID \
    --http-method GET \
    --type AWS_PROXY \
    --integration-http-method POST \
    --uri "arn:aws:apigateway:${REGION}:lambda:path/2015-03-31/functions/${LAMBDA_ARN}/invocations"

# 6.6. Realiza o deploy da API para o estágio 'dev' para que ela possa ser acessada
awslocal apigateway create-deployment --rest-api-id $API_ID --stage-name dev

# --- SEÇÃO 4: Permissões Finais ---

echo -e "\n[PASSO 7 de 7] Concedendo permissão para a API Gateway invocar a Lambda..."
# A última peça: autorizamos explicitamente a API a executar a função Lambda.
awslocal lambda add-permission \
    --function-name $LAMBDA_FUNCTION_NAME \
    --statement-id apigateway-get-permission-final \
    --action "lambda:InvokeFunction" \
    --principal apigateway.amazonaws.com \
    --source-arn "arn:aws:execute-api:${REGION}:${ACCOUNT_ID}:${API_ID}/*/GET/notas"

# --- Conclusão ---
API_ENDPOINT="http://localhost:4566/restapis/${API_ID}/dev/_user_request_/notas"

echo -e "\n\n--------------------------------------------------------"
echo "✅  Infraestrutura criada com sucesso!"
echo "--------------------------------------------------------"
echo "\n➡️  Para testar o upload via S3, use o comando:"
echo "awslocal s3 cp sample_data/nota_fiscal_exemplo.json s3://${BUCKET_NAME}/"
echo "\n➡️  Para testar a consulta via API Gateway, use o endpoint GET:"
echo "${API_ENDPOINT}"
echo "--------------------------------------------------------"