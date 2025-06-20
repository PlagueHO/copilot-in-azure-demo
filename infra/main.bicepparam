using './main.bicep'

// Global parameters
param location = readEnvironmentVariable('AZURE_LOCATION', 'EastUS2') // Specifies the Azure region for deployment. Overrides default in main.bicep.
param environmentName = readEnvironmentVariable('AZURE_ENV_NAME', 'contosohotels-demo') // Name of the environment for resource naming.

// User or service principal deploying the resources
param principalId = readEnvironmentVariable('AZURE_PRINCIPAL_ID', '')
param principalIdType = toLower(readEnvironmentVariable('AZURE_PRINCIPAL_ID_TYPE', 'user')) == 'serviceprincipal' ? 'ServicePrincipal' : 'User'

// Virtual Machine parameters
param vmAdminUsername = readEnvironmentVariable('VM_ADMIN_USERNAME', 'demoadmin') // Username for the Virtual Machine.
param vmAdminPassword = readEnvironmentVariable('VM_ADMIN_PASSWORD', 'P@ssw0rd12345!!') // Password for the Virtual Machine. Ensure this meets complexity requirements.

// SQL Database parameters
param sqlAdminLogin = readEnvironmentVariable('SQL_ADMIN_LOGIN', 'sqldemoadmin') // Admin username for the SQL Database server.
param sqlAdminPassword = readEnvironmentVariable('SQL_ADMIN_PASSWORD', 'P@ssw0rdSql12345!!') // Admin password for the SQL Database server. Ensure this meets complexity requirements.
param sqlServerSkuName = readEnvironmentVariable('SQL_SERVER_SKU_NAME', 'Basic') // SQL Database SKU name for development workloads.
param sqlServerSkuTier = readEnvironmentVariable('SQL_SERVER_SKU_TIER', 'Basic') // SQL Database tier for development workloads.
param sqlDatabaseMaxSizeGB = int(readEnvironmentVariable('SQL_DATABASE_MAX_SIZE_GB', '2')) // SQL Database max size in GB for development workloads.
