# Adventure Works - Banco de Dados PostgreSQL

Este diretório contém a configuração Docker para execução local do banco de dados
PostgreSQL da Adventure Works, utilizado como fonte de dados do projeto.

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

Baixe os arquivos CSV do repositório oficial:
https://github.com/dpavancini/analytics-engineering/tree/main/AdventureWorks/data

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