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
| Dados brutos | dbt Seeds (CSVs exportados do PostgreSQL) |
| Data Warehouse | Databricks (Unity Catalog) |
| Transformação | dbt Cloud |
| Dashboard | Looker Studio |
| Repositório | GitHub |
| Ambiente local | Docker + PostgreSQL 15 |

## Arquitetura do projeto

```bash

adventure_works/
└── raw_adventure_works/     

dev/
├── dbt_jeysel_staging/     
├── dbt_jeysel_intermediate/ 
└── dbt_jeysel_marts/        

```
## Modelagem dimensional

### Dimensões
| Dimensão | Tabelas fonte |
|----------|--------------|
| dim_produto | Product, ProductSubcategory, ProductCategory |
| dim_cliente | Customer, Person |
| dim_data | dim_datas (gerada via procedure PostgreSQL) |
| dim_motivo_venda | SalesReason, SalesOrderHeaderSalesReason |
| dim_vendedor | SalesPerson, Employee, Person |
| dim_localidade | Address, StateProvince, CountryRegion |
| dim_cartao | CreditCard, PersonCreditCard |
| dim_status | SalesOrderHeader.status |

### Fato
| Fato | Grão | Tabelas fonte |
|------|------|--------------|
| fato_vendas | 1 linha = 1 produto em 1 pedido | SalesOrderHeader, SalesOrderDetail |

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
├── docker/                         
│   ├── docker-compose.yml
│   ├── install.sql
│   └── README.md
├── models/
│   ├── staging/
│   │   └── adventure_works/        
│   ├── intermediate/               
│   └── marts/                      
├── seeds/
│   └── adventure_works/            
├── tests/                          
│   └── tst_vendas_brutas_2011.sql
├── macros/
│   └── generate_schema_name.sql
├── dbt_project.yml
└── packages.yml

```

## Testes implementados

- **Testes de sources:** unique e not_null nas PKs das 17 tabelas fonte
- **Testes de PKs:** unique e not_null nas surrogate keys de todas as dimensões e fato
- **Teste singular (CEO):** valida vendas brutas 2011 = $12.646.112,16
```bash
dbt test --select source:*        
dbt test --select marts           
dbt test --select tst_vendas_brutas_2011  
```

## Como executar

### Pré-requisitos
- Docker instalado
- Conta no Databricks
- Conta no dbt Cloud
- Repositório clonado

### 1. Subir o banco PostgreSQL local
```bash
cd docker
docker-compose up -d
docker exec -it adventure_works psql -U postgres -d Adventureworks -f /install.sql
```

Consulte `docker/README.md` para exportar os CSVs necessários.

### 2. Carregar os seeds no Databricks
```bash
dbt seed
```

### 3. Executar os modelos
```bash
dbt run
```

### 4. Executar os testes
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

## Sobre a solução para dados brutos

O enunciado do desafio menciona um schema `raw_adventure_works` disponível no 
ambiente do curso, porém esse ambiente não estava acessível. 

A solução desenvolvida foi:
1. Criar um container Docker com PostgreSQL 15
2. Popular o banco com o `install.sql` oficial do repositório da Indicium
3. Exportar as 16 tabelas necessárias como CSVs com cabeçalho
4. Carregar via dbt seeds no Databricks

Toda a configuração está documentada em `docker/README.md`.

## Autor

**Jeysel Pacheco Bastos**  

GitHub: [github.com/jeysel](https://github.com/jeysel)
