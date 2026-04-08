# Desafio Final — Certificação Analytics Engineer by Indicium

## Sobre o projeto

Projeto de Analytics Engineering desenvolvido como desafio final para obtenção da
Certificação em Engenharia de Analytics pela Indicium Academy.

A empresa fictícia **Adventure Works** é uma indústria de bicicletas com mais de
500 produtos, 20.000 clientes e 31.000 pedidos. O objetivo é construir uma
plataforma moderna de analytics para responder perguntas estratégicas de negócio.

## Stack utilizada

| Camada | Tecnologia |
|--------|-----------|
| Dados brutos | Databricks — catalog `fea_academy` (ambiente oficial Indicium) |
| Dimensão de datas | dbt Seed (gerada via procedure PostgreSQL) |
| Data Warehouse | Databricks (Unity Catalog) |
| Transformação | dbt Cloud |
| Dashboard | Looker Studio |
| Repositório | GitHub |
| Ambiente local | Docker + PostgreSQL 15 |

## Arquitetura do projeto

```bash

fea_academy/
└── adventure_works/         # 68 tabelas (ambiente oficial Indicium)
adventure_works/
└── raw_adventure_works/     # dim_datas (gerada via procedure PostgreSQL)
dev/
├── dbt_jeysel_staging/      # 16 views stg_adventure_works__*
├── dbt_jeysel_intermediate/ # 9 modelos int_* (joins e lógica de negócio)
└── dbt_jeysel_marts/        # 8 dimensões + 1 fato        

```
## Modelagem dimensional

### Dimensões
| Dimensão | Tabelas fonte |
|----------|--------------|
| dim_produto | production_product, production_productsubcategory, production_productcategory |
| dim_cliente | sales_customer, person_person |
| dim_data | dim_datas (seed gerado via procedure PostgreSQL — período 2005 a 2020) |
| dim_motivo_venda | sales_salesreason, sales_salesorderheadersalesreason |
| dim_vendedor | sales_salesperson, humanresources_employee, person_person |
| dim_localidade | person_address, person_stateprovince, person_countryregion |
| dim_cartao | sales_creditcard, sales_personcreditcard |
| dim_status | sales_salesorderheader.status |

### Fato
| Fato | Grão | Tabelas fonte |
|------|------|--------------|
| fato_vendas | 1 linha = 1 produto em 1 pedido | sales_salesorderheader, sales_salesorderdetail |

### Métricas
| Métrica | Cálculo |
|---------|---------|
| Número de pedidos | COUNT DISTINCT sales_order_id |
| Quantidade comprada | SUM order_qty |
| Valor total negociado | SUM (unit_price * order_qty) |
| Valor total negociado líquido | SUM (unit_price * order_qty * (1 - discount)) |

## Estrutura do repositório

```bash

desafio-indicium/
├── docker/                         # Ambiente local PostgreSQL (documentação)
│   ├── docker-compose.yml
│   ├── install.sql
│   └── README.md
├── models/
│   ├── staging/
│   │   └── adventure_works/        # 16 modelos stg_* + YMLs
│   ├── intermediate/               # 9 modelos int_* + YMLs
│   └── marts/                      # 9 modelos dim_* + fato + YMLs
├── seeds/
│   └── adventure_works/            # dim_datas.csv
├── tests/                          # Teste singular CEO
│   └── tst_vendas_brutas_2011.sql
├── macros/
│   └── generate_schema_name.sql
├── dbt_project.yml
└── packages.yml

```

## Testes implementados

- **Testes de sources:** unique e not_null nas PKs das 16 tabelas fonte do fea_academy + dim_datas
- **Testes de PKs:** unique e not_null nas surrogate keys de todas as dimensões e fato
- **Teste singular (CEO):** valida que vendas brutas 2011 = $12.646.112,16

```bash
dbt test --select source:*               # testa sources
dbt test --select marts                  # testa dimensões e fato
dbt test --select tst_vendas_brutas_2011 # teste do CEO
```

## Como executar

### Pré-requisitos
- Conta no Databricks com acesso ao catalog `fea_academy`
- Conta no dbt Cloud
- Docker instalado
- Repositório clonado

### 1. Configurar o ambiente fea_academy no Databricks

Siga as instruções do repositório oficial da Indicium:

```bash

https://bitbucket.org/indiciumtech/databricks-datasources

```

### 2. Gerar a dim_datas via Docker

```bash
cd docker
docker-compose up -d
docker exec -it adventure_works psql -U postgres -d Adventureworks -f /install.sql
docker exec -it adventure_works psql -U postgres -d Adventureworks -c "\COPY (SELECT * FROM public.dim_datas) TO '/data/dim_datas.csv' CSV HEADER"
```

Consulte `docker/README.md` para instruções detalhadas sobre como popular o banco
e gerar a dim_datas.

### 3. Carregar o seed dim_datas

```bash
dbt seed
```

### 4. Executar os modelos

```bash
dbt run
```

### 5. Executar os testes

```bash
dbt test
```

## Dashboard

Acesse o dashboard público no Looker Studio:
[Adventure Works — Analytics Dashboard]
https://lookerstudio.google.com/reporting/abfcaf02-8f64-4d78-a43a-53c7c18e834d

### Perguntas de negócio respondidas

| # | Pergunta | Página |
|---|----------|--------|
| a | Pedidos, quantidade e valor por produto, cartão, motivo, data, cliente, status, cidade, estado e país | Visão Geral |
| b | Produtos com maior ticket médio por mês, ano, cidade, estado e país | Produtos |
| c | Top 10 clientes por valor total negociado | Clientes e Localidade |
| d | Top 5 cidades por valor total negociado | Clientes e Localidade |
| e | Evolução de pedidos, quantidade e valor por mês e ano | Visão Geral |
| f | Produto com maior quantidade comprada no motivo "On Promotion" | Produtos |

## Sobre a dim_datas

A dimensão de datas foi gerada via procedure PostgreSQL local (Docker) cobrindo
o período de 2005 a 2020, com atributos ricos como nome do mês, trimestre,
flag de fim de semana, primeiro e último dia do mês. O arquivo `dim_datas.csv`
está disponível na pasta `seeds/adventure_works/`.

Para recriar o ambiente local e regenerar a dim_datas, consulte `docker/README.md`.

## Autor

**Jeysel Pacheco Bastos**

GitHub: [github.com/jeysel](https://github.com/jeysel)
