using './main.bicep'

// Global parameters
// param location = resourceGroup().location // This is the default in main.bicep
param location = readEnvironmentVariable('AZURE_LOCATION', 'EastUS2') // Specifies the Azure region for deployment. Overrides default in main.bicep.

// Virtual Machine parameters
param vmAdminUsername = readEnvironmentVariable('VM_ADMIN_USERNAME', 'demoadmin') // Username for the Virtual Machine.
param vmAdminPassword = readEnvironmentVariable('VM_ADMIN_PASSWORD', 'P@ssw0rd12345!!') // Password for the Virtual Machine. Ensure this meets complexity requirements.
                                                                              // It's recommended to set this via a secure environment variable.

// PostgreSQL parameters
param postgresAdminLogin = readEnvironmentVariable('POSTGRES_ADMIN_LOGIN', 'pgdemoadmin') // Admin username for the PostgreSQL server.
param postgresAdminPassword = readEnvironmentVariable('POSTGRES_ADMIN_PASSWORD', 'P@ssw0rdPg12345!!') // Admin password for the PostgreSQL server. Ensure this meets complexity requirements.
                                                                                         // It's recommended to set this via a secure environment variable.

// Note: The 'uniqueSuffix' parameter from main.bicep has a dynamic default (uniqueString(resourceGroup().id)).
// It is intentionally omitted here to allow the dynamic default to be used.
// If you need to provide a specific static suffix for all resources, you can uncomment and set it below:
// param uniqueSuffix = 'yourstaticsuffix'
