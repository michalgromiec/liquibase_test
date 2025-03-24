# Postgres with Liquibase using Docker

## Status with docker
```bash
docker run --rm -v ./changelog:/liquibase/changelog liquibase status --url=jdbc:postgresql://192.168.1.245:5432/liquibase_test?currentSchema=public --changelog-file=changelog/changelog.xml --username=liquibase_test --password=***
```

## UpdateSQL with docker - dryrun
```bash
docker run --rm -v ./changelog:/liquibase/changelog liquibase updateSQL --url=jdbc:postgresql://192.168.1.245:5432/liquibase_test?currentSchema=public --changelog-file=changelog/changelog.xml --username=liquibase_test --password=***
```


## Update with docker
```bash
docker run --rm -v ./changelog:/liquibase/changelog liquibase update --url=jdbc:postgresql://192.168.1.245:5432/liquibase_test?currentSchema=public --changelog-file=changelog/changelog.xml --username=liquibase_test --password=***
```

## Update with docker
```bash
docker run --rm -v ./changelog:/liquibase/changelog liquibase update-count --count=1 --url=jdbc:postgresql://192.168.1.245:5432/liquibase_test?currentSchema=public --changelog-file=changelog/changelog.xml --username=liquibase_test --password=***
```

## Rollback with docker - dryrun
```bash
docker run --rm -v ./changelog:/liquibase/changelog liquibase rollback-count --count=1 --url=jdbc:postgresql://192.168.1.245:5432/liquibase_test?currentSchema=public --changelog-file=changelog/changelog.xml --username=liquibase_test --password=***
```


# Azure Synapse SQL using Docker
```bash
az login --identity --username <client_id|object_id|resource_id>  # https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli-managed-identity
token=$(az account get-access-token --resource https://database.windows.net/ --query accessToken -o tsv)
username=$(az ad signed-in-user show --query userPrincipalName --output tsv)

jdbc=jdbc:postgresql://[server]:5432/[database]
docker run --rm -v ./changelog:/liquibase/changelog liquibase status --url=$jdbc --changelog-file=changelog/changelog.xml --username=$username --password=$token

```