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
var appServicePlanName = '${abbrs.webServerFarms}contoso-${uniqueSuffix}'
var webAppName = '${abbrs.webSitesAppService}contoso-web-${uniqueSuffix}'
var postgreSqlServerName = '${abbrs.dBforPostgreSQLServers}contoso-db-${uniqueSuffix}'
var virtualNetworkName = '${abbrs.networkVirtualNetworks}contoso-hotels-${uniqueSuffix}'
var appGwSubnetName = 'snet-appgw'
var backendSubnetName = 'snet-backend'
var vmName = '${abbrs.computeVirtualMachines}contoso-backend'
var appGatewayName = '${abbrs.networkApplicationGateways}contoso-${uniqueSuffix}'
var publicIpAppGwName = '${abbrs.networkPublicIPAddresses}appgw-${uniqueSuffix}'
var publicIpVmName = '${abbrs.networkPublicIPAddresses}vm-${vmName}'
var nicVmName = '${abbrs.networkNetworkInterfaces}${vmName}'

var appServicePlanSkuName = 'P0v3'
var postgreSqlSkuName = 'Standard_B1ms'
var vmSize = 'Standard_B2ms'
var vmImageReference = {
  publisher: 'MicrosoftWindowsServer'
  offer: 'WindowsServer'
  sku: '2025-Datacenter'
  version: 'latest'
}
var webAppRuntimeStack = 'DOTNETCORE|6.0'

var tags = {
  'azd-env-name': environmentName
  projectName: 'ContosoHotelsDemo'
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
    dataRetention: 30
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
    skuName: appServicePlanSkuName
    skuCapacity: 1
    kind: 'linux'
    reserved: true
  }
  dependsOn: [
    resourceGroup
  ]
}

// 4. Web App (App Service) (AVM)
module webApp 'br/public:avm/res/web/site:0.16.0' = {
  name: 'webAppDeployment'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: webAppName
    location: location
    tags: tags
    serverFarmResourceId: appServicePlan.outputs.resourceId
    kind: 'app,linux'
    httpsOnly: true
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
    }
    managedIdentities: {
      systemAssigned: true
    }
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

// 5. Azure Database for PostgreSQL - Flexible Server (AVM)
module postgreSqlServer 'br/public:avm/res/db-for-postgre-sql/flexible-server:0.12.0' = {
  name: 'postgreSqlServerDeployment'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: postgreSqlServerName
    location: location
    tags: tags
    skuName: postgreSqlSkuName
    tier: 'Burstable'
    availabilityZone: 1
    administratorLogin: postgresAdminLogin
    administratorLoginPassword: postgresAdminPassword
    version: '14'
    storageSizeGB: 32
    backupRetentionDays: 7
    geoRedundantBackup: 'Disabled'
    highAvailability: 'Disabled'
    firewallRules: [
      {
        name: 'AllowAllWindowsAzureIps'
        startIpAddress: '0.0.0.0'
        endIpAddress: '0.0.0.0'
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
    skuName: 'Standard'
    publicIPAllocationMethod: 'Static'
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
module appGatewayAVM 'br/public:avm/res/network/application-gateway:0.6.0' = {
  name: 'appGatewayAvmDeployment'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: appGatewayName
    location: location
    tags: tags
    sku: 'WAF_v2'
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        subnetResourceId: virtualNetwork.outputs.subnetResourceIds[0]
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        publicIPAddressId: publicIpAppGw.outputs.resourceId
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
            fqdn: webApp.outputs.defaultHostname
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
        requestTimeout: 30
        probeName: 'contosoWebAppProbe'
      }
    ]
    httpListeners: [
      {
        name: 'contosoWebAppHttpListener'
        frontendIPConfigurationName: 'appGwPublicFrontendIp'
        frontendPortName: 'port_80'
        protocol: 'Http'
      }
    ]
    requestRoutingRules: [
      {
        name: 'basicRule'
        ruleType: 'Basic'
        httpListenerName: 'contosoWebAppHttpListener'
        backendAddressPoolName: 'contosoWebAppBackendPool'
        backendHttpSettingsName: 'contosoWebAppHttpSettings'
        priority: 100
      }
    ]
    probes: [
      {
        name: 'contosoWebAppProbe'
        protocol: 'Http'
        path: '/'
        interval: 30
        timeout: 30
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
    resourceGroup
  ]
}

// 9. Virtual Machine (AVM)
module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.15.0' = {
  name: 'virtualMachineDeployment'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: vmName
    location: location
    tags: tags
    vmSize: vmSize
    osType: 'Windows'
    imageReference: vmImageReference
    adminUsername: vmAdminUsername
    adminPassword: vmAdminPassword
    osDisk: {
      createOption: 'FromImage'
      caching: 'ReadWrite'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
    }
    nicConfigurations: [
      {
        name: nicVmName
        ipConfigurations: [
          {
            name: 'ipconfig1'
            subnetResourceId: virtualNetwork.outputs.subnetResourceIds[1]
            privateIPAllocationMethod: 'Dynamic'
            pipConfiguration: {
              name: publicIpVmName
              publicIPAddressVersion: 'IPv4'
              publicIPAllocationMethod: 'Static'
              skuName: 'Standard'
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
        diagnosticSettings: [
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
    computerName: vmName
    provisionVMAgent: true
    enableAutomaticUpdates: true
    patchMode: 'AutomaticByOS'
    bootDiagnostics: true
    zone: 1
  }
  dependsOn: [
    resourceGroup
  ]
}

// 10. VM CPU Alert (AVM)
module vmCpuAlert 'br/public:avm/res/insights/metric-alert:0.4.0' = {
  name: 'vmCpuAlertDeployment'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: '${vmName}-HighCpuAlert'
    location: 'global'
    alertDescription: 'Alert when VM CPU usage is over 80% for 5 minutes.'
    severity: 2
    enabled: true
    scopes: [
      virtualMachine.outputs.resourceId
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allof: [
        {
          metricName: 'Percentage CPU'
          metricNamespace: 'Microsoft.Compute/virtualMachines'
          operator: 'GreaterThan'
          threshold: 80
          timeAggregation: 'Average'
        }
      ]
    }
    tags: tags
  }
  dependsOn: [
    resourceGroup
  ]
}

// 11. App Service HTTP 5xx Errors Alert (AVM)
module appService5xxAlert 'br/public:avm/res/insights/metric-alert:0.4.0' = {
  name: 'appService5xxAlertDeployment'
  scope: az.resourceGroup(resourceGroupName)
  params: {
    name: '${webAppName}-Http5xxAlert'
    location: 'global'
    alertDescription: 'Alert when App Service has more than 5 HTTP 5xx errors in 5 minutes.'
    severity: 1
    enabled: true
    scopes: [
      webApp.outputs.resourceId
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allof: [
        {
          metricName: 'Http5xx'
          metricNamespace: 'Microsoft.Web/sites'
          operator: 'GreaterThan'
          threshold: 5
          timeAggregation: 'Count'
        }
      ]
    }
    tags: tags
  }
  dependsOn: [
    resourceGroup
  ]
}

// OUTPUTS
@sys.description('Default hostname of the deployed Web App.')
output WEBAPP_DEFAULT_HOST_NAME string = webApp.outputs.defaultHostname

@sys.description('Public IP Address of the Application Gateway.')
output APPLICATION_GATEWAY_PUBLIC_IP_ADDRESS string = publicIpAppGw.outputs.ipAddress

@sys.description('Resource ID of the Log Analytics Workspace.')
output LOG_ANALYTICS_WORKSPACE_ID string = logAnalyticsWorkspace.outputs.resourceId

@sys.description('Connection string for Application Insights.')
output APPLICATION_INSIGHTS_CONNECTION_STRING string = applicationInsights.outputs.connectionString

@sys.description('Name of the deployed Virtual Machine.')
output VM_NAME_OUTPUT string = virtualMachine.outputs.name

@sys.description('Fully Qualified Domain Name (FQDN) of the PostgreSQL server.')
output POSTGRES_SERVER_FQDN string = postgreSqlServer.outputs.fqdn
