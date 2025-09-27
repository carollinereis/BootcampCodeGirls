## Implantação de Site Estático com AWS S3 e CloudFormation

Este repositório contém os recursos necessários para implantar um site estático na AWS, utilizando o Amazon S3 para hospedagem e o AWS CloudFormation para automação da infraestrutura.

---

### Objetivo 

Este laboratório tem como objetivo implementar uma infraestrutura automatizada com AWS CloudFormation. Nele, demonstro como utilizar o CloudFormation para implantar um site estático de forma rápida e replicável, usando o Amazon S3 como serviço de hospedagem.

### Arquitetura e Recursos Criados

O template do CloudFormation (`template-site-s3.yaml`) irá criar os seguintes recursos na conta AWS:

1.  **`AWS::S3::Bucket`**: Um bucket no Amazon S3 que servirá como repositório para os arquivos do site (HTML, CSS, etc.). Ele será configurado especificamente para a funcionalidade de hospedagem de site estático.

2.  **`AWS::S3::BucketPolicy`**: Uma política de segurança associada ao bucket que concede permissão de leitura pública (`s3:GetObject`). Isso é o que permite que visitantes acessem o conteúdo do site através da internet.

3.  **`Outputs`**: Uma seção no template que, após a criação bem-sucedida dos recursos, exibirá informações importantes, como a URL final do site.

### Pré-requisitos

* Uma conta ativa na AWS.
* Credenciais de um usuário IAM com permissões para criar e gerenciar recursos do CloudFormation e do S3.

### Instruções

#### Passo 1: Arquivos do Projeto

Certifique-se de que os dois arquivos a seguir estão na mesma pasta em seu computador.

**1. Template de Infraestrutura (`template-site-s3.yaml`)**
Este arquivo YAML define os recursos da AWS que serão criados.

**2. Página Web (`index.html`)**
Este é o arquivo principal do site que será exibido aos usuários.

#### Passo 2: Criação da Pilha no CloudFormation

Nesta etapa, usaremos o template para criar os recursos. No CloudFormation, um conjunto de recursos gerenciados em conjunto é chamado de **Pilha (Stack)**.

1.  Acesse o **Console da AWS** e navegue até o serviço **CloudFormation**.
2.  Clique em **"Criar pilha"** e selecione **"Escolher um modelo existente"**.
3.  Na seção "Especificar modelo", escolha **"Fazer upload de um arquivo de modelo"**, clique em **"Escolher arquivo"** e selecione o `template-site-s3.yaml`.
4.  Insira um **Nome da pilha** (ex: `projeto-site-estatico`).
5.  Na seção **Parâmetros**, preencha o campo `BucketName` com um nome globalmente único para seu bucket S3 (ex: `meu-projeto`).
6.  Prossiga pelas telas seguintes, mantendo as opções padrão, até a página de revisão.
7.  Na última página, confirme as informações e clique em **"Criar pilha"**.
8.  Aguarde até que o status da pilha mude para **`CREATE_COMPLETE`**.

#### Passo 3: Upload do Conteúdo para o S3

1.  Navegue até o serviço **S3** no Console da AWS.
2.  Localize e acesse o bucket que foi criado pela sua pilha.
3.  Clique em **"Carregar"**, depois em **"Adicionar arquivos"**, e selecione o arquivo `index.html`.
4.  Conclua o upload.

#### Passo 4: Verificação do Resultado

1.  Retorne ao serviço **CloudFormation** e selecione a sua pilha.
2.  Acesse a aba **"Saídas"**.
3.  Clique no link fornecido no valor do campo `WebsiteURL` para acessar e verificar seu site online.

### ⚠️ Limpeza dos Recursos 

Para evitar cobranças futuras, é crucial remover todos os recursos criados após a conclusão do projeto.

1.  **Esvaziar o Bucket S3:** Acesse o bucket S3, selecione todos os arquivos (neste caso, `index.html`) e os exclua.
2.  **Excluir a Pilha do CloudFormation:** No painel do CloudFormation, selecione a pilha criada e clique em **"Excluir"**. Esta ação irá remover todos os recursos que foram provisionados pelo template.

### Aprendizados

Este projeto foi uma experiência de aprendizado onde, mais do que apenas seguir um tutorial, tive que resolver problemas e entender o porquê das coisas. Aqui estão os pontos que mais me marcaram:

**Infraestrutura como Código na prática:** Pude aprender na prática o conceito simples de um arquivo de texto se transformar em um site funcional na nuvem. Entendi como o IaC atua de forma rápida, segura e fácil de replicar, sem precisar clicar em dezenas de botões.

**Como um template do CloudFormation funciona:** Aprendi a lógica por trás de um template: usar Parameters para poder reutilizar o código (como fiz com o nome do bucket), Resources para definir o que de fato será criado e Outputs para receber informações úteis no final, como o link do site.

**A importância das permissões no S3:** O erro que encontrei no começo foi, na verdade, a melhor parte do aprendizado. Ele me forçou a pesquisar e entender por que as permissões públicas antigas (ACLs) não são mais a prática recomendada e como usar uma Bucket Policy para liberar o acesso ao site de forma correta e segura.

### Conclusão

Este laboratório "hands-on" me permitiu aprender, passo a passo, as funções e funcionalidades do CloudFormation e também como o bucket S3 é usado em conjunto com ele.