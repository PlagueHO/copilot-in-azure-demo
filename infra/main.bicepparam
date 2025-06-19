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

// PostgreSQL parameters
param postgresAdminLogin = readEnvironmentVariable('POSTGRES_ADMIN_LOGIN', 'pgdemoadmin') // Admin username for the PostgreSQL server.
param postgresAdminPassword = readEnvironmentVariable('POSTGRES_ADMIN_PASSWORD', 'P@ssw0rdPg12345!!') // Admin password for the PostgreSQL server. Ensure this meets complexity requirements.
