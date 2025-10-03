## Projeto: API Serverless para Notas Fiscais com AWS e LocalStack

### Objetivo do Projeto

Este projeto teve como objetivo orquestrar um fluxo de dados serverless ponta a ponta, utilizando o LocalStack para simular o ambiente AWS e agilizar o desenvolvimento local. A arquitetura implementada integra quatro serviços essenciais da AWS:

1.  **Amazon S3:** Para o recebimento e armazenamento de arquivos de dados.
2.  **AWS Lambda:** Para executar a lógica de negócio e processar os dados recebidos.
3.  **Amazon DynamoDB:** Como banco de dados NoSQL para a persistência das informações.
4.  **Amazon API Gateway:** Para expor a funcionalidade através de uma API RESTful, permitindo a consulta dos dados.

-----

### Estrutura do Projeto

O repositório está organizado da seguinte forma para separar as responsabilidades e facilitar a manutenção:

```
.
├── README.md               # Este arquivo
├── .gitignore              # Arquivos e pastas a serem ignorados pelo Git
├── imagens/                # Contém o diagrama da arquitetura e imagens finais
│   └── arquitetura.png
├── lambda_function/        # Código-fonte da função Lambda
│   └── grava_db.py
├── scripts/                # Scripts de automação e auxiliares
│   ├── setup_infra.sh      # Script principal para criar a infraestrutura
│   └── gerar_dados.py      # Script para gerar dados de teste
└── sample_data/            # Arquivos com dados de exemplo
    └── notas_fiscais.json
```

-----

### Como Executar o Projeto Localmente

Siga os passos abaixo para construir a infraestrutura na sua máquina e testar a aplicação de ponta a ponta.

**1. Pré-requisitos:**

  * **Docker** e **Docker Compose**
  * **AWS CLI** e **awslocal** (`pip install awscli-local`)
  * **Git** para clonar o repositório
  * **jq** para processar saídas JSON no script (`brew install jq` ou `sudo apt-get install jq`)

**2. Clone o Repositório:**

```bash
git clone https://github.com/seu-usuario/seu-repositorio.git
cd seu-repositorio
```

**3. Inicie o LocalStack:**
Se você estiver usando Docker, pode iniciar com o `docker-compose.yml` (se houver um) ou com o comando da CLI do LocalStack:

```bash
localstack start -d
```

**4. Construa a Infraestrutura AWS:**
Este comando executa o script principal que cria todos os recursos necessários (S3, DynamoDB, Lambda, etc.).

```bash
# Dar permissão de execução (apenas na primeira vez)
chmod +x scripts/setup_infra.sh

# Executar o script
./scripts/setup_infra.sh
```

Ao final da execução, o script irá fornecer o endpoint da sua API Gateway. Guarde-o para o passo 7.

**5. Gere Dados de Teste:**
Execute o script Python para criar um arquivo `notas_fiscais_exemplo.json` com dados de exemplo.

```bash
python scripts/gerar_dados.py
```

**6. Teste o Fluxo de Upload (S3 → Lambda → DynamoDB):**
Faça o upload do arquivo gerado para o bucket S3. Isso irá disparar a função Lambda, que processará e gravará os dados no DynamoDB.

```bash
awslocal s3 cp notas_fiscais_exemplo.json s3://notas-fiscais-upload/
```

**7. Teste o Fluxo de Consulta (API Gateway → Lambda → DynamoDB):**
Use o endpoint fornecido ao final do passo 4 para consultar os dados via API.

```bash
# Substitua a URL pelo endpoint gerado no seu terminal
curl http://localhost:4566/restapis/SEU_API_ID/dev/_user_request_/notas
```

-----

### Principais Aprendizados

  * **Desenvolvimento Cloud Local:** Aprendi a usar o LocalStack para simular todo o ambiente da AWS na minha máquina. Isso me permitiu desenvolver e testar de forma ágil e sem custos, vendo o resultado dos meus comandos instantaneamente.
  * **Arquitetura Orientada a Eventos:** O ponto central do projeto foi entender como um evento, como o upload de um arquivo no S3, pode disparar automaticamente uma cadeia de ações. Configurei esse gatilho e vi o fluxo funcionando sem intervenção manual.
  * **Integração de Serviços Serverless:** Conectei, passo a passo, os quatro principais componentes da AWS (S3, Lambda, DynamoDB e API Gateway). Aprendi que os serviços não se comunicam sozinhos e que é necessário configurar permissões e integrações específicas.
  * **Debug em Ambiente Simulado:** Aprendi a diagnosticar problemas usando `awslocal logs tail` para ler os logs da função Lambda em tempo real, o que foi essencial para encontrar e corrigir erros de código, timeouts e problemas de conexão.

### Erros Comuns e Soluções

  * **Timeout na Lambda:**
      * **Causa:** Código tentando se conectar à AWS real, em vez do LocalStack.
      * **Solução:** Configurar o `endpoint_url` no cliente `boto3` para apontar para o serviço local.
  * **Erro de Conexão da Lambda (Rede Docker):**
      * **Causa:** De dentro do container, `localhost` não aponta para os outros serviços do LocalStack.
      * **Solução:** Usar a variável de ambiente `LOCALSTACK_HOSTNAME` para construir a URL de conexão dinâmica no código Python.

### Conclusão

Este projeto serviu como uma excelente introdução prática ao ecossistema serverless da AWS. Utilizando apenas o terminal e o LocalStack, foi possível construir, integrar, depurar e testar um fluxo de dados completo, solidificando conceitos cruciais de desenvolvimento para a nuvem de forma eficiente e sem custos.

### Produto Final

As imagens do produto final podem ser encontradas na pasta _img_ juntamente com o diagrama de arquitetura.