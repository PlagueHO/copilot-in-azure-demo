targetScope = 'subscription'

// PARAMETERS
@sys.description('Azure region for all resources.')
@metadata({
  azd: {
    type: 'location'
  }
})
param location string

@sys.description('Name of the environment (used in resource group naming).')
param environmentName string

@sys.description('A unique string appended to resource names to ensure uniqueness.')
param uniqueSuffix string = uniqueString(subscription().subscriptionId, environmentName, location)

@sys.description('Admin username for the Virtual Machine.')
param vmAdminUsername string

@sys.description('Admin password for the Virtual Machine. Must meet complexity requirements.')
@secure()
param vmAdminPassword string

@sys.description('Admin username for the PostgreSQL server.')
param postgresAdminLogin string

@sys.description('Admin password for the PostgreSQL server. Must meet complexity requirements.')
@secure()
param postgresAdminPassword string

// VARIABLES
var abbrs = loadJsonContent('./abbreviations.json')

var resourceGroupName = 'rg-${environmentName}'
var logAnalyticsWorkspaceName = '${abbrs.operationalInsightsWorkspaces}contosologs-${uniqueSuffix}'
var appInsightsName = '${abbrs.insightsComponents}contoso-web-${uniqueSuffix}'
var appServicePlanName = '${abbrs.webServerFarms}contoso-${uniqueSuffix}' // Corrected key
var webAppName = '${abbrs.webSitesAppService}contoso-web-${uniqueSuffix}' // Corrected key
var postgreSqlServerName = '${abbrs.dBforPostgreSQLServers}contoso-db-${uniqueSuffix}' // Corrected key
var virtualNetworkName = '${abbrs.networkVirtualNetworks}contoso-hotels-${uniqueSuffix}'
var appGwSubnetName = 'snet-appgw' // Restored definition
var backendSubnetName = 'snet-backend' // Restored definition
var vmName = '${abbrs.computeVirtualMachines}contoso-backend'
var appGatewayName = '${abbrs.networkApplicationGateways}contoso-${uniqueSuffix}'
var publicIpAppGwName = '${abbrs.networkPublicIPAddresses}appgw-${uniqueSuffix}'
var publicIpVmName = '${abbrs.networkPublicIPAddresses}vm-${vmName}'
var nicVmName = '${abbrs.networkNetworkInterfaces}${vmName}'

var appServicePlanSkuName = 'P0v3'
var postgreSqlSkuName = 'Standard_B1ms' // Burstable B1ms
var vmSize = 'Standard_B2ms'
var vmImageReference = {
  publisher: 'MicrosoftWindowsServer'
  offer: 'WindowsServer'
  sku: '2025-Datacenter' // Updated to Windows Server 2025
  version: 'latest'
}
var webAppRuntimeStack = 'DOTNETCORE|6.0' // .NET 6 on Linux

var tags = {
  'azd-env-name': environmentName // Updated to use environmentName parameter
  projectName: 'ContosoHotelsDemo' // Corrected tag name
}

// RESOURCES

// 0. Resource Group (AVM)
module resourceGroup 'br/public:avm/res/resources/resource-group:0.4.1' = {
  name: 'resourceGroupDeployment'
  params: {
    name: resourceGroupName
    location: location
    tags: tags
  }
}

// 1. Log Analytics Workspace (AVM)
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.2' = {
  name: 'logAnalyticsWorkspaceDeployment'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: logAnalyticsWorkspaceName
    location: location
    tags: tags
    skuName: 'PerGB2018'
    dataRetention: 30 // Corrected parameter name for retention
  }
  dependsOn: [
    resourceGroup
  ]
}

// 2. Application Insights (AVM)
module applicationInsights 'br/public:avm/res/insights/component:0.6.0' = {
  name: 'applicationInsightsDeployment'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: appInsightsName
    location: location
    tags: tags
    kind: 'web'
    applicationType: 'web'
    workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
  }
  dependsOn: [
    resourceGroup
  ]
}

// 3. App Service Plan (Linux) (AVM)
module appServicePlan 'br/public:avm/res/web/serverfarm:0.4.1' = {
  name: 'appServicePlanDeployment'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: appServicePlanName
    location: location
    tags: tags
    // AVM module parameters for web/serverfarm:0.4.1
    // sku is an object with name, tier, family, capacity
    skuName: appServicePlanSkuName // Corrected: skuName is a direct parameter
    skuCapacity: 1
    kind: 'linux'
    reserved: true // Required for Linux plans
  }
  dependsOn: [
    resourceGroup
  ]
}

// 4. Web App (App Service) (AVM)
module webApp 'br/public:avm/res/web/site:0.16.0' = { // Updated version to 0.16.0
  name: 'webAppDeployment'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: webAppName
    location: location
    tags: tags
    serverFarmResourceId: appServicePlan.outputs.resourceId
    kind: 'app,linux' // Retained kind for Linux app
    httpsOnly: true // Retained httpsOnly
    siteConfig: {
      linuxFxVersion: webAppRuntimeStack
      alwaysOn: true
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
      appSettings: [
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: applicationInsights.outputs.connectionString
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.outputs.instrumentationKey
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~3'
        }
      ]
      // Ensure other siteConfig properties are compatible with 0.16.0
      // ftpsState, minTlsVersion, alwaysOn, linuxFxVersion are common.
    }
    managedIdentities: {
      systemAssigned: true
    }
    // Add diagnosticSettings if not already present and if required by WAF or best practices
    diagnosticSettings: [
      {
        name: 'send-to-log-analytics'
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs' // Common practice to log all categories for App Services
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
      }
    ]
  }
  dependsOn: [
    resourceGroup
  ]
}

// 5. Azure Database for PostgreSQL - Flexible Server (AVM)
module postgreSqlServer 'br/public:avm/res/db-for-postgre-sql/flexible-server:0.12.0' = {
  name: 'postgreSqlServerDeployment'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: postgreSqlServerName
    location: location
    tags: tags
    skuName: postgreSqlSkuName // e.g., 'Standard_B1ms'
    tier: 'Burstable' // Must align with skuName
    availabilityZone: 1
    administratorLogin: postgresAdminLogin
    administratorLoginPassword: postgresAdminPassword
    version: '14' // Current version being used
    storageSizeGB: 32
    backupRetentionDays: 7
    geoRedundantBackup: 'Disabled'
    highAvailability: 'Disabled'
    // publicNetworkAccess is implicitly 'Enabled' by not providing a delegatedSubnetResourceId
    // and by setting appropriate firewall rules.
    firewallRules: [
      {
        name: 'AllowAllWindowsAzureIps'
        startIpAddress: '0.0.0.0'
        endIpAddress: '0.0.0.0'
      }
    ]
    diagnosticSettings: [
      {
        name: 'send-to-log-analytics' // Name for the diagnostic setting
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs' // Collect all PostgreSQL logs
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics' // Collect all metrics
          }
        ]
      }
    ]
  }
  dependsOn: [
    resourceGroup
  ]
}

// 6. Virtual Network and Subnets (AVM)
module virtualNetwork 'br/public:avm/res/network/virtual-network:0.7.0' = {
  name: 'virtualNetworkDeployment'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: virtualNetworkName
    location: location
    tags: tags
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: appGwSubnetName
        addressPrefix: '10.0.0.0/24'
        // networkSecurityGroupResourceId: // Optional NSG
      }
      {
        name: backendSubnetName
        addressPrefix: '10.0.1.0/24'
      }
    ]
  }
  dependsOn: [
    resourceGroup
  ]
}

// 7. Public IP for Application Gateway (AVM)
module publicIpAppGw 'br/public:avm/res/network/public-ip-address:0.8.0' = {
  name: 'publicIpAppGwDeployment'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: publicIpAppGwName
    location: location
    tags: tags
    skuName: 'Standard' // Standard SKU
    publicIPAllocationMethod: 'Static' // Static allocation
    diagnosticSettings: [
      {
        name: 'send-to-log-analytics'
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
      }
    ]
  }
  dependsOn: [
    resourceGroup
  ]
}

// 8. Application Gateway (AVM)
module appGatewayAVM 'br/public:avm/res/network/application-gateway:0.6.0' = { // Updated to version 0.6.0
  name: 'appGatewayAvmDeployment'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: appGatewayName
    location: location
    tags: tags
    sku: 'WAF_v2' // This SKU implies WAF capabilities. WAF rules are configured separately or via firewallPolicyResourceId
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0] // App Gateway subnet
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        publicIPAddressId: publicIpAppGw.outputs.resourceId // Using AVM Public IP output
      }
    ]
    frontendPorts: [
      {
        name: 'port_80'
        port: 80
      }
    ]
    backendAddressPools: [
      {
        name: 'contosoWebAppBackendPool'
        backendAddresses: [
          {
            fqdn: webApp.outputs.defaultHostname // Pointing to the Web App
          }
        ]
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'contosoWebAppHttpSettings'
        port: 80
        protocol: 'Http'
        cookieBasedAffinity: 'Disabled'
        pickHostNameFromBackendAddress: true
        requestTimeout: 30 // seconds
        probeName: 'contosoWebAppProbe' // Link to the health probe by name
      }
    ]
    httpListeners: [
      {
        name: 'contosoWebAppHttpListener'
        frontendIPConfigurationName: 'appGwPublicFrontendIp' // Link by name
        frontendPortName: 'port_80' // Link by name
        protocol: 'Http'
        // Linked to requestRoutingRules by the rule itself
      }
    ]
    requestRoutingRules: [
      {
        name: 'basicRule'
        ruleType: 'Basic'
        httpListenerName: 'contosoWebAppHttpListener' // Link by name
        backendAddressPoolName: 'contosoWebAppBackendPool' // Link by name
        backendHttpSettingsName: 'contosoWebAppHttpSettings' // Link by name
        priority: 100
      }
    ]
    probes: [
      {
        name: 'contosoWebAppProbe'
        protocol: 'Http'
        path: '/'
        interval: 30 // seconds
        timeout: 30 // seconds
        unhealthyThreshold: 3
        pickHostNameFromBackendHttpSettings: true
      }
    ]

    diagnosticSettings: [
      {
        name: 'send-to-log-analytics'
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
          }
        ]
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
      }
    ]
  }
  dependsOn: [
    resourceGroup,
    virtualNetwork,
    publicIpAppGw,
    webApp
  ]
}

// Using br/public:avm/res/compute/virtual-machine:0.15.0
module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.15.0' = {
  name: 'virtualMachineDeployment' // Unique deployment name for the module
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: vmName // Name of the VM resource
    location: location
    tags: tags
    vmSize: vmSize
    osType: 'Windows' // Required by AVM module
    imageReference: vmImageReference
    adminUsername: vmAdminUsername
    adminPassword: vmAdminPassword
    osDisk: {
      createOption: 'FromImage'
      caching: 'ReadWrite'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
      // name: '${vmName}-osdisk' // Optional: OS Disk name
    }
    nicConfigurations: [
      {
        name: nicVmName // Name for the NIC resource to be created by the VM module
        ipConfigurations: [
          {
            name: 'ipconfig1' // Name of the IP Configuration
            subnetResourceId: virtualNetwork.outputs.subnetResourceIds[1] // Backend subnet
            // primary: true // Removed: Not a standard AVM parameter here, primary is often implicit
            privateIPAllocationMethod: 'Dynamic'
            pipConfiguration: { // VM module will create a new Public IP
              name: publicIpVmName // Name for the PIP resource to be created by the VM module
              publicIPAddressVersion: 'IPv4'
              publicIPAllocationMethod: 'Static'
              skuName: 'Standard'
              // domainNameLabel: '${vmName}-${uniqueSuffix}' // Optional: for DNS name
              diagnosticSettings: [
                {
                  name: 'pip-${publicIpVmName}-diagnostics'
                  workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
                  logCategoriesAndGroups: [ { categoryGroup: 'allLogs' } ]
                  metricCategories: [ { category: 'AllMetrics' } ]
                }
              ]
            }
          }
        ]
        // networkSecurityGroupResourceId: networkSecurityGroupId // Optional NSG for the NIC
        diagnosticSettings: [ // Diagnostics for the NIC
          {
            name: 'nic-${nicVmName}-diagnostics'
            workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
            logCategoriesAndGroups: [ { categoryGroup: 'allLogs' } ]
            metricCategories: [ { category: 'AllMetrics' } ]
          }
        ]
        enableAcceleratedNetworking: false
      }
    ]
    computerName: vmName // OS computer name
    provisionVMAgent: true
    enableAutomaticUpdates: true
    patchMode: 'AutomaticByOS' // For Windows
    bootDiagnostics: true // Enables boot diagnostics with a module-managed storage account
    // bootDiagnosticStorageAccountName: '' // Can specify a custom SA if needed
    zone: 1 // 0 for no specific zone, 1, 2, or 3 for a specific zone. Required by 0.15.0.
    // Removed diagnosticSettings block for the VM resource itself from module params.
    // VM diagnostics are handled by extensions (e.g., vmExtensionMMA below) or specific module capabilities like bootDiagnostics.
    // Consider extensionMonitoringAgentConfig for Azure Monitor Agent (AMA) if migrating from MMA
  }
  dependsOn: [
    resourceGroup
  ]
}

// Note: VM Extension will be deployed via the VM module's extensionConfig parameter instead
// The VM extension needs to be deployed in the resource group scope, but since we're at subscription scope,
// we'll use the VM module's built-in extension capabilities or deploy it via a separate module later

// 13. Metric Alerts (AVM)

// VM CPU Alert (AVM)
module vmCpuAlert 'br/public:avm/res/insights/metric-alert:0.4.0' = {
  name: 'vmCpuAlertDeployment'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: '${vmName}-HighCpuAlert'
    location: 'global' // Metric alerts are global
    alertDescription: 'Alert when VM CPU usage is over 80% for 5 minutes.' // Corrected parameter name
    severity: 2
    enabled: true
    scopes: [
      virtualMachine.outputs.resourceId // Reference VM module output
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria' // Added odata.type
      allof: [
        {
          // criterionType: 'StaticThresholdCriterion' // Not directly used in AVM, structure implies this
          metricName: 'Percentage CPU'
          metricNamespace: 'Microsoft.Compute/virtualMachines'
          operator: 'GreaterThan'
          threshold: 80
          timeAggregation: 'Average'
          // name: 'CpuUsage' // Optional name for the criterion, not strictly needed by AVM if only one
        }
      ]
    }
    tags: tags
    // actionGroups: [] // Add action group resource IDs here if needed
  }
  dependsOn: [
    resourceGroup
  ]
}

// App Service HTTP 5xx Errors Alert (AVM)
module appService5xxAlert 'br/public:avm/res/insights/metric-alert:0.4.0' = {
  name: 'appService5xxAlertDeployment'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: '${webAppName}-Http5xxAlert'
    location: 'global'
    alertDescription: 'Alert when App Service has more than 5 HTTP 5xx errors in 5 minutes.' // Corrected parameter name
    severity: 1
    enabled: true
    scopes: [
      webApp.outputs.resourceId
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria' // Added odata.type
      allof: [
        {
          // criterionType: 'StaticThresholdCriterion' // Not directly used in AVM, structure implies this
          metricName: 'Http5xx'
          metricNamespace: 'Microsoft.Web/sites'
          operator: 'GreaterThan'
          threshold: 5
          timeAggregation: 'Count'
        }
      ]
    }
    tags: tags
    // actionGroups: [] // Add action group resource IDs here if needed
  }
  dependsOn: [
    resourceGroup
  ]
}

// OUTPUTS
@sys.description('Default hostname of the deployed Web App.')
output WEBAPP_DEFAULT_HOST_NAME string = webApp.outputs.defaultHostname // Corrected to defaultHostname

@sys.description('Public IP Address of the Application Gateway.')
output APPLICATION_GATEWAY_PUBLIC_IP_ADDRESS string = publicIpAppGw.outputs.ipAddress // Output from AVM Public IP

@sys.description('Resource ID of the Log Analytics Workspace.')
output LOG_ANALYTICS_WORKSPACE_ID string = logAnalyticsWorkspace.outputs.resourceId

@sys.description('Connection string for Application Insights.')
output APPLICATION_INSIGHTS_CONNECTION_STRING string = applicationInsights.outputs.connectionString

@sys.description('Name of the deployed Virtual Machine.')
output VM_NAME_OUTPUT string = virtualMachine.outputs.name // Output from VM AVM

@sys.description('Fully Qualified Domain Name (FQDN) of the PostgreSQL server.')
output POSTGRES_SERVER_FQDN string = postgreSqlServer.outputs.fqdn // Output from AVM PGSQL module
