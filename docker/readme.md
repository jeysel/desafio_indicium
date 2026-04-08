# Adventure Works - Banco de Dados PostgreSQL (Docker)

Este diretório contém a configuração Docker para execução local do banco de dados
PostgreSQL da Adventure Works, utilizado exclusivamente para geração da dimensão
de datas `dim_datas` do projeto.

> **Nota:** Os dados brutos do Adventure Works são fornecidos pelo ambiente oficial
> da Indicium Academy no catalog `fea_academy` do Databricks. Este container Docker
> é necessário apenas para geração da `dim_datas` via procedure PostgreSQL.

## Pré-requisitos

- [Docker](https://www.docker.com/get-started) instalado
- [Docker Compose](https://docs.docker.com/compose/install/) instalado

## Estrutura

```bash
docker/
├── docker-compose.yml    # Configuração do container PostgreSQL
├── install.sql           # Script de criação das tabelas e carga dos dados
├── README.md             # Este arquivo
└── data/                 # CSVs originais do AdventureWorks (não versionados)
```

## Como executar

### 1. Baixar os CSVs originais

Baixe os arquivos CSV do repositório oficial da Indicium:
https://bitbucket.org/indiciumtech/databricks-datasources

Coloque todos os arquivos na pasta `docker/data/`.

### 2. Subir o container

```bash
cd docker
docker-compose up -d
```

### 3. Popular o banco de dados

```bash
docker exec -it adventure_works psql -U postgres -d Adventureworks -f /install.sql
```

### 4. Verificar as tabelas

```bash
docker exec -it adventure_works psql -U postgres -d Adventureworks -c "\dt *.*"
```

Devem aparecer 68 tabelas distribuídas nos schemas:
- `person`
- `humanresources`
- `production`
- `purchasing`
- `sales`

### 5. Gerar a dim_datas

Execute os comandos abaixo para criar e popular a tabela `dim_datas`:

```bash
docker exec -it adventure_works psql -U postgres -d Adventureworks -c "
CREATE TABLE IF NOT EXISTS public.dim_datas (
    dt_data             DATE        PRIMARY KEY,
    ano                 INTEGER     NOT NULL,
    mes                 INTEGER     NOT NULL,
    dia                 INTEGER     NOT NULL,
    trimestre           INTEGER     NOT NULL,
    semana_ano          INTEGER     NOT NULL,
    dia_semana_num      INTEGER     NOT NULL,
    nm_mes              VARCHAR(20) NOT NULL,
    nm_mes_abrev        VARCHAR(5)  NOT NULL,
    nm_dia_semana       VARCHAR(20) NOT NULL,
    ano_mes             VARCHAR(7)  NOT NULL,
    nm_trimestre        VARCHAR(10) NOT NULL,
    sigla_trimestre     VARCHAR(2)  NOT NULL,
    fl_fim_de_semana    BOOLEAN     NOT NULL,
    primeiro_dia_mes    DATE        NOT NULL,
    ultimo_dia_mes      DATE        NOT NULL
);"
```

```bash
docker exec -it adventure_works psql -U postgres -d Adventureworks -c "
CREATE OR REPLACE PROCEDURE public.sp_popula_dim_datas(
    p_data_inicio DATE DEFAULT '2005-01-01',
    p_data_fim    DATE DEFAULT '2020-12-31'
)
LANGUAGE plpgsql
AS \$\$
DECLARE
    v_data DATE := p_data_inicio;
BEGIN
    WHILE v_data <= p_data_fim LOOP
        INSERT INTO public.dim_datas VALUES (
            v_data,
            EXTRACT(YEAR FROM v_data)::INTEGER,
            EXTRACT(MONTH FROM v_data)::INTEGER,
            EXTRACT(DAY FROM v_data)::INTEGER,
            EXTRACT(QUARTER FROM v_data)::INTEGER,
            EXTRACT(WEEK FROM v_data)::INTEGER,
            EXTRACT(DOW FROM v_data)::INTEGER,
            TO_CHAR(v_data, 'TMMonth'),
            TO_CHAR(v_data, 'TMMon'),
            TO_CHAR(v_data, 'TMDay'),
            TO_CHAR(v_data, 'YYYY-MM'),
            TO_CHAR(v_data, 'Q\"º Tri\"'),
            CASE EXTRACT(QUARTER FROM v_data)::INTEGER
                WHEN 1 THEN 'Q1' WHEN 2 THEN 'Q2'
                WHEN 3 THEN 'Q3' WHEN 4 THEN 'Q4'
            END,
            EXTRACT(DOW FROM v_data) IN (0, 6),
            DATE_TRUNC('month', v_data)::DATE,
            (DATE_TRUNC('month', v_data) + INTERVAL '1 month - 1 day')::DATE
        )
        ON CONFLICT (dt_data) DO NOTHING;
        v_data := v_data + INTERVAL '1 day';
    END LOOP;
END;
\$\$;"
```

```bash
docker exec -it adventure_works psql -U postgres -d Adventureworks -c "CALL public.sp_popula_dim_datas('2005-01-01', '2020-12-31');"
```

### 6. Exportar a dim_datas para CSV

```bash
docker exec -it adventure_works psql -U postgres -d Adventureworks -c "\COPY (SELECT * FROM public.dim_datas) TO '/data/dim_datas.csv' CSV HEADER"
```

O arquivo `dim_datas.csv` será gerado em `docker/data/` e deve ser copiado para
`seeds/adventure_works/` antes de rodar o `dbt seed`.

```bash
cp docker/data/dim_datas.csv seeds/adventure_works/dim_datas.csv
```

## Credenciais

| Parâmetro | Valor |
|-----------|-------|
| Host | localhost |
| Porta | 5432 |
| Banco | Adventureworks |
| Usuário | postgres |
| Senha | postgres |

## Observação

A pasta `data/` está no `.gitignore` e não é versionada no repositório.