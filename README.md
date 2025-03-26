# Postgres with Liquibase using Docker

## Local setup with Postgres database
```bash
docker network create liquibase-network --driver bridge
docker run -d --name postgres --hostname postgres -e POSTGRES_USER=liquibase_test -e POSTGRES_PASSWORD=liquibase_test -e POSTGRES_DB=liquibase_test -p 5432:5432 --net=liquibase-network postgres:14
docker run -d -p 5050:80 --net=liquibase-network -e PGADMIN_DEFAULT_EMAIL=admin@admin.com -e PGADMIN_DEFAULT_PASSWORD=admin dpage/pgadmin4
```
```bash
#add manually database connection to pgadmin4 - http://localhost:5050
```

## Status
```bash
docker run --rm --net=liquibase-network -v ./changelog:/liquibase/changelog liquibase status --url=jdbc:postgresql://postgres:5432/liquibase_test?currentSchema=public --changelog-file=changelog/changelog.xml --username=liquibase_test --password=liquibase_test
```

## UpdateSQL - dryrun
```bash
docker run --rm --net=liquibase-network -v ./changelog:/liquibase/changelog liquibase updateSQL --url=jdbc:postgresql://postgres:5432/liquibase_test?currentSchema=public --changelog-file=changelog/changelog.xml --username=liquibase_test --password=liquibase_test
```

## Update one changeset
```bash
docker run --rm --net=liquibase-network -v ./changelog:/liquibase/changelog liquibase update-count --count=1 --url=jdbc:postgresql://postgres:5432/liquibase_test?currentSchema=public --changelog-file=changelog/changelog.xml --username=liquibase_test --password=liquibase_test
```

## Update full
```bash
docker run --rm --net=liquibase-network -v ./changelog:/liquibase/changelog liquibase update --url=jdbc:postgresql://postgres:5432/liquibase_test?currentSchema=public --changelog-file=changelog/changelog.xml --username=liquibase_test --password=liquibase_test
```

## Rollback one changeset - dryrun
```bash
docker run --rm --net=liquibase-network -v ./changelog:/liquibase/changelog liquibase rollback-count-sql --count=1 --url=jdbc:postgresql://postgres:5432/liquibase_test?currentSchema=public --changelog-file=changelog/changelog.xml --username=liquibase_test --password=liquibase_test
```

## Rollback one changeset
```bash
docker run --rm --net=liquibase-network -v ./changelog:/liquibase/changelog liquibase rollback-count --count=1 --url=jdbc:postgresql://postgres:5432/liquibase_test?currentSchema=public --changelog-file=changelog/changelog.xml --username=liquibase_test --password=liquibase_test
```

## Rollback two changesets
```bash
docker run --rm --net=liquibase-network -v ./changelog:/liquibase/changelog liquibase rollback-count --count=2 --url=jdbc:postgresql://postgres:5432/liquibase_test?currentSchema=public --changelog-file=changelog/changelog.xml --username=liquibase_test --password=liquibase_test
```

## Tag changeset
```bash
docker run --rm --net=liquibase-network -v ./changelog:/liquibase/changelog liquibase tag --tag=tag1 --url=jdbc:postgresql://postgres:5432/liquibase_test?currentSchema=public --username=liquibase_test --password=liquibase_test
```

## History with tags
```bash
docker run --rm --net=liquibase-network -v ./changelog:/liquibase/changelog liquibase history --url=jdbc:postgresql://postgres:5432/liquibase_test?currentSchema=public --username=liquibase_test --password=liquibase_test
```

## Rollback to tag
```bash
docker run --rm --net=liquibase-network -v ./changelog:/liquibase/changelog -v ./liquibase.properties:/liquibase/liquibase.properties liquibase rollback --url=jdbc:postgresql://postgres:5432/liquibase_test?currentSchema=public --changelog-file=changelog/changelog.xml --username=liquibase_test --password=liquibase_test --tag=tag1
```

## Clear checksums
checksums are recalculated on the next update
```bash
docker run --rm --net=liquibase-network -v ./changelog:/liquibase/changelog liquibase clear-checksums --url=jdbc:postgresql://postgres:5432/liquibase_test?currentSchema=public --username=liquibase_test --password=liquibase_test
```

## (TODO) Command utilizing liquibase.properties
```bash
docker run --rm --net=liquibase-network -v ./changelog:/liquibase/changelog -v ./liquibase.properties:/liquibase/liquibase.properties liquibase status
```

## Generate initial changelog based on existing database schema
```bash
docker run --rm --net=liquibase-network -v ./changelog:/liquibase/changelog liquibase generate-changelog
```

## Mark changesets as executed without executing queries on database
```bash
docker run --rm --net=liquibase-network -v ./changelog:/liquibase/changelog liquibase changelogSync --url=jdbc:postgresql://postgres:5432/liquibase_test?currentSchema=public --changelog-file=changelog/changelog.xml --username=liquibase_test --password=liquibase_test
```

## how to use multiple targets
```bash
docker run --rm --net=liquibase-network -v ./changelog:/liquibase/changelog -v ./liquibase_properties_files:/liquibase/liquibase_properties_files liquibase status --defaultsFile=liquibase_properties_files/TEST-liquibase.properties
```

```bash
docker run --rm --net=liquibase-network -v ./changelog:/liquibase/changelog -v ./liquibase_properties_files:/liquibase/liquibase_properties_files liquibase status --defaultsFile=liquibase_properties_files/PROD-liquibase.properties
```

## (TODO) execute selected changelog once again
## (TODO) revoke marking changesets as executed without executing queries


# (TODO) Azure Synapse SQL using Docker
```bash
az login --identity --username <client_id|object_id|resource_id>  # https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli-managed-identity
token=$(az account get-access-token --resource https://database.windows.net/ --query accessToken -o tsv)
username=$(az ad signed-in-user show --query userPrincipalName --output tsv)

jdbc=jdbc:postgresql://[server]:5432/[database]
docker run --rm -v ./changelog:/liquibase/changelog liquibase status --url=$jdbc --changelog-file=changelog/changelog.xml --username=$username --password=$token

```

# (TODO) AWS Redshift using Docker
```bash
endpoint=$(aws redshift describe-clusters --cluster-identifier my-cluster --query 'Clusters[0].Endpoint.Address' --output text)

# Get temporary credentials
credentials=$(aws redshift get-cluster-credentials --cluster-identifier my-cluster --db-user myuser --db-name dev --duration-seconds 120)
username=$(echo $credentials | jq -r '.DbUser')
password=$(echo $credentials | jq -r '.DbPassword')

docker run --rm --net=liquibase-network -v ./changelog:/liquibase/changelog liquibase status --url=jdbc:redshift://$endpoint:5439/dev --changelog-file=changelog/changelog.xml --username=$username --password=$password
```