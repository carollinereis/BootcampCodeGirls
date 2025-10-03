## Desafio: Implementando sua Primeira Stack com AWS CloudFormation 

### Laboratório - Bootcamp CodeGirls
---

#### Objetivo:

Este laboratório tem como objetivo explorar o sistema **CloudFormation** da AWS para compreender na prática como criar instâncias EC2 e outros recursos da nuvem de forma automatizada, utilizando templates YAML e o gerenciamento através de stacks.

---

#### Conteúdo dos Templates

-   **`01-simple-ec2.yaml`**: Template básico que cria uma única instância Amazon EC2.
-   **`02-ec2-apache.yaml`**: Adiciona um script `UserData` para instalar e iniciar um servidor web Apache na instância.
-   **`03-ec2-security-group.yaml`**: Introduz um recurso de `SecurityGroup` (firewall) para liberar o acesso HTTP à instância.

---

#### Pré-requisitos

1.  Uma conta na AWS.
2.  Templates
3.  [AWS CLI](https://aws.amazon.com/cli/) instalado e configurado com suas credenciais se for usar o terminal.

---

#### Como Executar as Stacks

Você pode criar as stacks via Console da AWS ou via AWS CLI. Eu criei via Console.

#### Via Console da AWS

1.  Faça login no [Console da AWS](https://aws.amazon.com/console/).
2.  Navegue até o serviço **CloudFormation**.
3.  Clique em **Criar stack** > **Escolher um modelo existente**.
4.  Selecione **Fazer upload de um arquivo de modelo** e escolha um dos arquivos `.yaml`.
5.  Clique em **Avançar**, dê um nome para a sua stack (ex: `MinhaStackApache`).
6.  Clique em **Avançar** nas próximas telas e, por fim, em **Criar stack**.

---

#### Como Verificar a Criação

Após o status da stack mudar para `CREATE_COMPLETE`:

-   Para as stacks com servidor web (`02` e `03`), vá até o serviço **EC2**.
-   Encontre a instância criada pela sua stack.
-   Conectar para iniciar a maquina.

###### Como Destruir as Stacks (Limpeza)

**Importante:** Para não gerar custos, sempre delete as stacks após o uso!

1.  Vá para o serviço **CloudFormation**.
2.  Selecione a stack que você criou.
3.  Clique em **Excluir**.

#### Aprendizados

- Aprendi a criar templates YAML para provisionar recursos AWS e gerenciar o ciclo de vida das stacks usando !Ref para vincular recursos.
- Configurei Security Groups como firewall, liberando SSH (porta 22) só para meu IP e HTTP (porta 80) para acesso público.
- Entendi diferenças entre regiões/zonas de disponibilidade, o papel das AMIs e como funcionam IPs públicos vs privados.
- Desenvolvi habilidade para ler logs de erro do CloudFormation e resolver problemas de conectividade e permissões no terminal.

#### Conclusão:

Consegui aprender sobre CloudFormation na prática, assim como utilizar templates no formato YAML e também como excluir as instâncias. Esse laboratório deixou ainda mais claro como EC2, CloudTrail e infraestrutura como código funcionam.

#### Diagrama da Arquitetura

O diagrama a seguir ilustra a arquitetura completa da solução implementada. Ele detalha não apenas a instância EC2, mas também a estrutura de rede (VPC, Sub-rede Pública), o firewall (Security Group) e o fluxo de tráfego do usuário final para acessar tanto o servidor web (HTTP) quanto a interface de gerenciamento (SSH).

#### Referências - Documentação

[AWS CloudFormation](https://docs.aws.amazon.com/pt_br/AWSCloudFormation/latest/UserGuide/gettingstarted.walkthrough.html)


