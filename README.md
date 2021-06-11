![PicPay](https://user-images.githubusercontent.com/1765696/26998603-711fcf30-4d5c-11e7-9281-0d9eb20337ad.png)

# Desafio de Observabilidade

Primeiramente, obrigado pelo seu interesse em trabalhar na melhor plataforma de pagamentos do mundo! Abaixo você encontrará todas as informações necessárias para iniciar o seu teste.

## Avisos antes de começar

* Crie um repositório na sua conta do **GitHub** sem citar nada relacionado ao PicPay;
* Faça seus commits no seu repositório;
* Solicite ao **Recruter** que está acompanhando o seu processo o username do Github do avaliador, assim você poderá dar permissão de leitura no código; 
* Fique à vontade para perguntar qualquer dúvida aos recrutadores.
* Fique tranquilo, respire, assim como você, também já passamos por essa etapa. Boa sorte! :)

## Descrição

O desafio é criar uma **API REST** que será responsável por realizar as seguintes funcionalidades:

- **Gestão de alertas**;
- **Gestão de incidentes**; e
- **Exposição de métricas e saúde da aplicação**.

As funcionalidades estão explicadas em detalhes nos tópicos a seguir.

### Gestão de Alertas

Sua aplicação deverá possuir alguns endpoints capazes de:

- **Criar um Alerta**
- **Consultar uma lista de Alertas**
- **Habilitar ou Desabilitar um Alerta já criado**

_Como **opcional** você também pode ter a funcionalidade de:_

- _Consultar um alerta específico (opcional)_;
- _Remover um alerta cadastrado (opcional)_.

Os alertas devem ser cadastrado em uma tabela do banco de dados **MySQL** e devem possuir a seguinte estrutura:

|   Campo   |   Tipo   | Descrição |
|-----------|----------|-----------|
| alert_id  | integer  | Campo que indica o id do alerta.|
| app_name  | string   | Campo que indica o nome de uma aplicação a qual o alerta está relacionado|
| title     | string   | Campo que apresenta um título para o alerta |
| description | string | Campo que apresenta uma descrição do alerta (o que ele significa) |
| enabled | boolean | Campo que indica se o alerta encontra-se habilitado ou não |
| metric | string | Campo que indica o nome da métrica a ser monitorada |
| condition | char(2) | Campo que indica a condição de um alerta. (ex. Maior que >, Menor que <, igual á =, Maior Igual a >=, Menor Igual a <=) |
| threshold | integer | campo que indica o valor da métrica que acionará o alerta |

**Observações Importantes**
- _Todos os campos da tabela de alerta são obrigatórios_;
- _Você pode ter **N** alertas para o mesmo **app_name**_;
- _O campo **alert_id** é unico e não pode ser repetido_;
- _O arquivo com os exemplos de alertas a serem cadastrados na API encontra-se neste repositório e possui o nome de `alerts-list.csv`_;
- _Deve-se subir a estrutura utilizando **docker**. Utilizar como exemplo o arquivo **docker-compose.yml** deste repositório_;
- _Ao executar o comando `docker-compose up` o sistema deve-se configurar sozinho e rodar um container específico para cadastrar apenas uma vez os alertas_;
- _A **API** deve gerar os logs no formato **json_inline** (onde cada linha representa um objeto JSON) e deverá ser gerado uma mensagem de log todas as vezes que os endpoints de gestão de alertas forem chamados_.


### Gestão de Incidentes

Sua aplicação deverá:

- **Possuir um endpoint para receber informações de métricas**

_O endpoint deve aceitar somente payload em json e deve receber os seguintes campos_:

|   Campo   |   Tipo   | Descrição |
|-----------|----------|-----------|
| metricName | string  | Nome da métrica sendo informada|
| appName | string  | Campo que indica o nome de uma aplicação a qual o alerta está relacionado|
| value | integer | Campo que indica o valor da métrica sendo reportada|

Exemplo de paylod recebido:
```json
{"metricName":"throughput","appName":"ms-system-02","value":1651}
```

- **Validar as Informações recebidas com os alertas configurados**

_Aproveitando do endpoint definido na seção acima, a API deve ser capaz de comparar a metrica recebida, o appName recebido e o valor recebido pelo endpoint acima com os alertas ja configurados na API, respeitando a condição estipulada._

Exemplo, se você tiver um alerta onde:
```sh
metric    = throughput
app_name  = ms-system-02
condition = '>='
threshold = 1000 
```
e você receber no endpoint de métricas recebidas o seguinte valor:
```json
{"metricName":"throughput","appName":"ms-system-02","value":1651}
```

Sua **API** deverá criar um registro na **tabela de incidentes** que possuí a seguinte estrutura (caso não atenda a condição, deverá ignorar a criação do registro na tabela e informar nos logs):

|   Campo   |   Tipo   | Descrição |
|-----------|----------|-----------|
| timestamp | integer  | Campo que indica a data em que o incidente aconteceu |
| alert_id  | string   | Campo de ID que identifica o alerta cadastrado na tabela de alertas. |

**Observações Importantes**
- _Todos os campos da tabela de incidentes são obrigatórios_;
- _Você deverá utilizar o script `metric-generator.sh` para validar a sua implementação deste endpoint (**lembre-se** de alterar a variável **ENDPOINT** do script para o endereço correto da sua aplicação)_;
- _Você deverá pegar o script `metric-generator.sh` e convertê-lo em um container adicionando sua execução dentro do arquivo `docker-compose.yml`_;
- _A **API** deve gerar os logs no formato **json_inline** (onde cada linha representa um objeto JSON) e deverá ser gerado uma mensagem de log todas as vezes que este endpoint de recebimento de métricas for chamado_.

### Exposição de Métricas e Saúde da Aplicação

Sua aplicação deverá:

- **Possuir um endpoint chamado _/heath_**

_Este endpoint deve retornar a saúde da sua aplicação, deve indicar se todas as dependencias do seu sistema estão ok._

- **Possuir um endpoint chamado _/metrics_**

  - _Este endpoint será o responsável por extenalizar as métricas da sua propria aplicação. Ele deverá retornar algumas informações da sua propria aplicação e ser representado de acordo com o formato que apresentaremos a seguir._

    - _Gerar uma métrica que traga a quantidade de registros da tabela de incidentes, agregado pelo nome da propria métrica_ (exemplo do formato)

    ```sh
    # <metric_name>
    <metric>{alert_id=<value>} <count-da-quantidade-de-ocorrencias-na-tabela-incidentes>
    ```
    (exemplo de retorno se chamarmos o endpoint /metrics)

    ```sh
    # response_time
    response_time{alert_id=1} 10
    response_time{alert_id=2} 0
    response_time{alert_id=3} 3
    
    # throughput
    throughput{alert_id=11} 0
    throughput{alert_id=12} 5
    throughput{alert_id=13} 3
    ```

    - _Gerar uma métrica que traga a quantidade de alertas habilitados e desabilitados_ (exemplo do formato)

    ```sh
    # alerts-enabled
    alerts{enabled=<value>} <count-da-quantidade-de-alertas>
    ```

    (exemplo de retorno se chamarmos o endpoint /metrics)

    ```sh
    # alerts-enabled
    alerts{enabled=true} 10
    alerts{enabled=false} 0
    ```

    - _Gerar uma métrica que traga a quantidade de incidentes gerados agrupados por **APP_NAME**_ (exemplo do formato)

    ```sh
    # app-name-incidents
    app-name-incidents-qtd{app_name=<value>, enabled=<value>} <count-da-quantidade-de-incidentes-gerados>
    ```

    (exemplo de retorno se chamarmos o endpoint /metrics)

    ```sh
    # app-name-incidents-qtd
    app-name-incidents-qtd{app_name="ms-system-01", enabled=true} 10
    app-name-incidents-qtd{app_name="ms-system-02", enabled=false} 0
    app-name-incidents-qtd{app_name="ms-system-03", enabled=true} 50
    ```

## Premissas

### Execução

Sua aplicação deverá rodar utilizando docker. Utilize como referência o arquivo `docker-compose.yml` disponibilizado neste projeto.

### Facilidades de uso
    
Simplicidade na configuração e execução da sua aplicação, conforme exemplo:

```sh
git clone meu_repositorio.git
cd meu_repositorio
docker-compose up -d
```

Fique livre para sugerir outras abordagens :)

## O que será avaliado e valorizado

- Documentação (usar o próprio README.md do projeto);
- Código limpo e organizado;
- Aplicação funcionando e rodando;
  - A Aplicação precisa estar rodando em **docker**;
- Logs da aplicação configurados em JSON;
- Ter sido implementado as 3 principais funcionalidades descritas acima:
  - **Gestão de alertas**;
  - **Gestão de incidentes**; e
  - **Exposição de métricas e saúde da aplicação**.
- As linguagens e framework são livres, mas tenha em mente as premissas da solução.
- Respeitar as interfaces REST definidas;
- Testes unitários.

## Extras
- Proposta de melhoria de solução;
- Apresentar diagrama de arquitetura para rodar o projeto em cloud native.

