targetScope = 'resourceGroup' // Assuming deployment at resource group level as per original

// PARAMETERS
@sys.description('Azure region for all resources.')
@metadata({
  azd: {
    type: 'location'
  }
})
param location string = resourceGroup().location

@sys.description('A unique string appended to resource names to ensure uniqueness.')
param uniqueSuffix string = uniqueString(resourceGroup().id)

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
var abbrs = {
  operationalInsightsWorkspaces: 'log'
  insightsComponents: 'appi'
  webServerfarms: 'asp'
  webSites: 'app'
  dbforpostgresqlFlexibleServers: 'psql'
  networkVirtualNetworks: 'vnet'
  networkApplicationGateways: 'agw'
  computeVirtualMachines: 'vm'
  networkPublicIPAddresses: 'pip'
  networkNetworkInterfaces: 'nic'
}

var logAnalyticsWorkspaceName = '${abbrs.operationalInsightsWorkspaces}-contosologs-${uniqueSuffix}'
var appInsightsName = '${abbrs.insightsComponents}-contoso-web-${uniqueSuffix}'
var appServicePlanName = '${abbrs.webServerfarms}-contoso-${uniqueSuffix}'
var webAppName = '${abbrs.webSites}-contoso-web-${uniqueSuffix}' // Must be globally unique
var postgreSqlServerName = '${abbrs.dbforpostgresqlFlexibleServers}-contoso-db-${uniqueSuffix}' // Must be globally unique, 3-63 chars, lowercase, no hyphens at start/end
var virtualNetworkName = '${abbrs.networkVirtualNetworks}-contoso-hotels-${uniqueSuffix}'
var appGwSubnetName = 'snet-appgw'
var backendSubnetName = 'snet-backend'
var vmName = '${abbrs.computeVirtualMachines}-contoso-backend' // VM name is unique within RG
var appGatewayName = '${abbrs.networkApplicationGateways}-contoso-${uniqueSuffix}'
var publicIpAppGwName = '${abbrs.networkPublicIPAddresses}-appgw-${uniqueSuffix}'
var publicIpVmName = '${abbrs.networkPublicIPAddresses}-vm-${vmName}' // Name for PIP created by VM AVM
var nicVmName = '${abbrs.networkNetworkInterfaces}-${vmName}' // Name for NIC created by VM AVM

var appServicePlanSkuName = 'P1v2'
// var appServicePlanSkuTier = 'PremiumV2' // Removed as it's not used directly with AVM or native App Service Plan if SKU name implies tier
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
  'azd-env-name': 'contoso-hotels-demo' // Example environment tag
  projectName: 'ContosoHotelsDemo' // Corrected tag name
}

// RESOURCES

// 1. Log Analytics Workspace (AVM)
module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.1' = {
  name: 'logAnalyticsWorkspaceDeployment'
  params: {
    name: logAnalyticsWorkspaceName
    location: location
    tags: tags
    // AVM module parameters for operational-insights/workspace:0.11.1
    // skuName is a top-level parameter, not nested under sku
    skuName: 'PerGB2018'
    // retentionInDays is a top-level parameter
    dataRetention: 30 // Corrected parameter name for retention
  }
}

// 2. Application Insights (AVM)
module applicationInsights 'br/public:avm/res/insights/component:0.6.0' = {
  name: 'applicationInsightsDeployment'
  params: {
    name: appInsightsName
    location: location
    tags: tags
    kind: 'web'
    applicationType: 'web'
    workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    // IngestionMode: 'LogAnalytics' // This is often default or handled by workspaceResourceId link
  }
}

// 3. App Service Plan (Linux) (AVM)
module appServicePlan 'br/public:avm/res/web/serverfarm:0.4.0' = {
  name: 'appServicePlanDeployment'
  params: {
    name: appServicePlanName
    location: location
    tags: tags
    // AVM module parameters for web/serverfarm:0.4.0
    // sku is an object with name, tier, family, capacity
    skuName: appServicePlanSkuName // Corrected: skuName is a direct parameter
    // skuTier: appServicePlanSkuTier // tier is part of sku object for some modules, but direct for this one
    // skuFamily: 'Pv2' // family is part of sku object
    // skuCapacity: 1 // capacity is part of sku object
    kind: 'linux'
    reserved: true // Required for Linux plans
  }
}

// 4. Web App (App Service) (AVM)
module webApp 'br/public:avm/res/web/site:0.5.0' = {
  name: 'webAppDeployment'
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
      // App settings are typically handled by appSettings property in this AVM module
      appSettings: {
        APPLICATIONINSIGHTS_CONNECTION_STRING: applicationInsights.outputs.connectionString
        APPINSIGHTS_INSTRUMENTATIONKEY: applicationInsights.outputs.instrumentationKey // Legacy, but good to have
        ApplicationInsightsAgent_EXTENSION_VERSION: '~3' // For Linux .NET
      }
    }
    managedIdentities: {
      systemAssigned: true
    }
  }
}

// 5. Azure Database for PostgreSQL - Flexible Server (AVM)
module postgreSqlServer 'br/public:avm/res/db-for-postgre-sql/flexible-server:0.3.1' = {
  name: 'postgreSqlServerDeployment'
  params: {
    name: postgreSqlServerName
    location: location
    tags: tags
    skuName: postgreSqlSkuName // e.g., 'Standard_B1ms'
    tier: 'Burstable' // Must align with skuName
    administratorLogin: postgresAdminLogin
    administratorLoginPassword: postgresAdminPassword
    version: '14' // Current version being used
    storageSizeGB: 32
    backupRetentionDays: 7
    geoRedundantBackup: 'Disabled'
    highAvailability: 'Disabled'
    // publicNetworkAccess is implicitly 'Enabled' by not providing a delegatedSubnetResourceId
    // and by setting appropriate firewall rules.
    availabilityZone: '' // No specific zone preference (empty string for AVM module)
    firewallRules: [
      {
        name: 'AllowAllWindowsAzureIps'
        startIpAddress: '0.0.0.0'
        endIpAddress: '0.0.0.0'
      }
    ]
    // diagnosticSettings can be configured here if needed, e.g., to send logs to Log Analytics
    // diagnosticSettings: [
    //   {
    //     name: 'send-to-log-analytics'
    //     workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
    //     logCategoriesAndGroups: [
    //       {
    //         categoryGroup: 'allLogs' // Or specify individual categories
    //       }
    //     ]
    //     metricCategories: [
    //       {
    //         category: 'AllMetrics'
    //       }
    //     ]
    //   }
    // ]
  }
}

// Firewall rule for PostgreSQL to allow Azure services (Now handled by the AVM module above)
// resource postgresFirewallRuleAllowAzure 'Microsoft.DBforPostgreSQL/flexibleServers/firewallRules@2023-03-01-preview' = {
//   parent: postgreSqlServerRes // This would need to change if postgreSqlServerRes is removed
//   name: 'AllowAllWindowsAzureIps'
//   properties: {
//     startIpAddress: '0.0.0.0'
//     endIpAddress: '0.0.0.0'
//   }
// }

// 6. Virtual Network and Subnets (AVM)
module virtualNetwork 'br/public:avm/res/network/virtual-network:0.6.1' = {
  name: 'virtualNetworkDeployment'
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
}

// 7. Public IP for Application Gateway (AVM)
// Using a generally available AVM version. 0.10.0 was not found.
// Placeholder: Using native resource. Update if a stable AVM for Public IP is confirmed.
resource publicIpAppGwRes 'Microsoft.Network/publicIPAddresses@2023-05-01' = { // Native resource
  name: publicIpAppGwName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// 8. Application Gateway (AVM)
// Using a generally available AVM version. 0.8.1 was not found.
// Placeholder: Using native resource. Update if a stable AVM for App Gateway is confirmed.
resource appGatewayRes 'Microsoft.Network/applicationGateways@2023-05-01' = { // Native resource
  name: appGatewayName
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'WAF_v2'
      tier: 'WAF_v2'
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: virtualNetwork.outputs.subnetResourceIds[0] // Assuming first subnet from VNet module output
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        properties: {
          publicIPAddress: {
            id: publicIpAppGwRes.id // Referencing native Public IP
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port_80'
        properties: {
          port: 80
        }
      }
    ]
    // Removed requestRoutingRules from httpListeners, it's a top-level property linked by name/ID.
    // httpListeners will reference requestRoutingRules by their ID.
    httpListeners: [
      {
        name: 'contosoWebAppHttpListener'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', appGatewayName, 'appGwPublicFrontendIp')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', appGatewayName, 'port_80')
          }
          protocol: 'Http'
          // The httpListener is associated with a requestRoutingRule by the rule itself.
          // No direct 'requestRoutingRule' property on the listener.
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'basicRule'
        properties: {
          ruleType: 'Basic'
          httpListener: { // This links the listener to this rule
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', appGatewayName, 'contosoWebAppHttpListener')
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', appGatewayName, 'contosoWebAppBackendPool')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', appGatewayName, 'contosoWebAppHttpSettings')
          }
        }
      }
    ]
    webApplicationFirewallConfiguration: {
      enabled: true
      firewallMode: 'Prevention'
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.2'
    }
    autoscaleConfiguration: {
      minCapacity: 2
    }
  }
  dependsOn: [
    // virtualNetwork module implicitly handled by subnet ID reference
    // webApp module implicitly handled by FQDN reference
  ]
}

// 9. Public IP for VM (Handled by VM AVM module)
// resource publicIpVmRes 'Microsoft.Network/publicIPAddresses@2023-05-01' = { ... }

// 10. Network Interface (NIC) for VM (Handled by VM AVM module)
// resource nicVmRes 'Microsoft.Network/networkInterfaces@2023-05-01' = { ... }

// The commented out section for publicIpVmRes and nicVmRes needs to be a proper block comment
/*
resource publicIpVmRes 'Microsoft.Network/publicIPAddresses@2023-05-01' = { // Native resource
  name: publicIpVmName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource nicVmRes 'Microsoft.Network/networkInterfaces@2023-05-01' = { // Native resource
  name: nicVmName
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: virtualNetwork.outputs.subnetResourceIds[1] // Assuming second subnet is backendSubnet
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpVmRes.id // Referencing native Public IP
          }
        }
      }
    ]
  }
}
*/

// 11. Virtual Machine (AVM)
// Using br/public:avm/res/compute/virtual-machine:0.10.0
module virtualMachine 'br/public:avm/res/compute/virtual-machine:0.10.0' = {
  name: 'virtualMachineDeployment' // Unique deployment name for the module
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
    }
    // nicConfigurations is used to define NICs that the VM module will create.
    // To use an existing NIC, this module might not be the right fit, or it might expect a different parameter.
    // Based on the error "The specified \"object\" declaration is missing the following required properties: \"nicConfigurations\"",
    // this module *requires* nicConfigurations to be defined for it to create NICs.
    // It does not seem to support attaching an existing NIC via `nicResourceIds` as previously attempted.
    // Therefore, we will let the VM AVM module create the NIC and Public IP for the VM.
    // This means the separate `nicVmRes` and `publicIpVmRes` are not needed for the VM if this module handles them.
    // However, the original plan was to have a separate PIP and NIC, potentially as AVMs if available.
    // Since NIC AVM was not found, we used native. Let's assume the VM AVM will create its own NIC and PIP.
    nicConfigurations: [
      {
        name: nicVmName // Name for the NIC to be created by the VM module
        networkInterfaceConfigurationProperties: {
          ipConfigurations: [
            {
              name: 'ipconfig1' // Name of the IP Configuration
              subnetResourceId: virtualNetwork.outputs.subnetResourceIds[1] // Backend subnet
              publicIpAddressConfiguration: { // VM module will create a new Public IP
                name: publicIpVmName // Name for the PIP to be created by the VM module
                publicIpAddressVersion: 'IPv4'
                publicIpAllocationMethod: 'Static'
                skuName: 'Standard'
                // domainNameLabel: '${vmName}-${uniqueSuffix}' // Optional: for DNS name
              }
            }
          ]
          // enableAcceleratedNetworking: false // Optional
          // enableIPForwarding: false // Optional
          // networkSecurityGroupResourceId: // Optional NSG for the NIC
        }
        // primary: true // Optional, defaults to true for the first NIC
      }
    ]
    computerName: vmName
    provisionVMAgent: true
    enableAutomaticUpdates: true
    patchMode: 'AutomaticByOS'
    bootDiagnostics: true
    zone: 0 // 0 for no specific zone
  }
  dependsOn: [
    // Removed nicVmRes as VM module now creates its own NIC
  ]
}

/*
// 12. VM Extension for Azure Monitor Agent (MMA - Legacy)
// Remove the separate native NIC and PIP for the VM as the VM AVM module will create them.
// Commenting out publicIpVmRes and nicVmRes
// 9. Public IP for VM (Native)
resource publicIpVmRes 'Microsoft.Network/publicIPAddresses@2023-05-01' = { // Native resource
  name: publicIpVmName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// 10. Network Interface (NIC) for VM (Native)
resource nicVmRes 'Microsoft.Network/networkInterfaces@2023-05-01' = { // Native resource
  name: nicVmName
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: virtualNetwork.outputs.subnetResourceIds[1] // Assuming second subnet is backendSubnet
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpVmRes.id // Referencing native Public IP
          }
        }
      }
    ]
  }
}
*/

resource vmExtensionMMA 'Microsoft.Compute/virtualMachines/extensions@2023-07-01' = {
  name: '${vmName}/MicrosoftMonitoringAgent'
  location: location
  properties: {
    publisher: 'Microsoft.EnterpriseCloud.Monitoring'
    type: 'MicrosoftMonitoringAgent'
    typeHandlerVersion: '1.0' // Check for latest version
    autoUpgradeMinorVersion: true
    settings: {
      workspaceId: logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId
    }
    protectedSettings: {
      workspaceKey: listKeys(resourceId('Microsoft.OperationalInsights/workspaces', logAnalyticsWorkspaceName), '2022-10-01').primarySharedKey
    }
  }
  dependsOn: [
    virtualMachine // Depends on the VM AVM module
  ]
}

// 13. Metric Alerts (Native)

// VM CPU Alert
resource vmCpuAlertRes 'Microsoft.Insights/metricAlerts@2018-03-01' = { // Native resource
  name: '${vmName}-HighCpuAlert'
  location: 'global' // Metric alerts are global
  tags: tags
  properties: {
    description: 'Alert when VM CPU usage is over 80% for 5 minutes.'
    severity: 2
    enabled: true
    scopes: [
      virtualMachine.outputs.resourceId // Reference VM module output
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          name: 'CpuUsage'
          metricName: 'Percentage CPU'
          metricNamespace: 'Microsoft.Compute/virtualMachines'
          operator: 'GreaterThan'
          threshold: 80
          timeAggregation: 'Average'
        }
      ]
    }
  }
}

// App Service HTTP 5xx Errors Alert
resource appService5xxAlertRes 'Microsoft.Insights/metricAlerts@2018-03-01' = { // Native resource
  name: '${webAppName}-Http5xxAlert'
  location: 'global'
  tags: tags
  properties: {
    description: 'Alert when App Service has more than 5 HTTP 5xx errors in 5 minutes.'
    severity: 1
    enabled: true
    scopes: [
      webApp.outputs.resourceId
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          name: 'Http5xxErrors'
          metricName: 'Http5xx'
          metricNamespace: 'Microsoft.Web/sites'
          operator: 'GreaterThan'
          threshold: 5
          timeAggregation: 'Count'
        }
      ]
    }
  }
}

// OUTPUTS
@sys.description('Default hostname of the deployed Web App.')
output webAppDefaultHostName string = webApp.outputs.defaultHostname // Corrected to defaultHostname

@sys.description('Public IP Address of the Application Gateway.')
output applicationGatewayPublicIpAddress string = publicIpAppGwRes.properties.ipAddress // Output from native PIP

@sys.description('Resource ID of the Log Analytics Workspace.')
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.outputs.resourceId

@sys.description('Connection string for Application Insights.')
output applicationInsightsConnectionString string = applicationInsights.outputs.connectionString

@sys.description('Name of the deployed Virtual Machine.')
output vmNameOutput string = virtualMachine.outputs.name // Output from VM AVM

@sys.description('Fully Qualified Domain Name (FQDN) of the PostgreSQL server.')
output postgresServerFqdn string = postgreSqlServer.outputs.fqdn // Output from AVM PGSQL module
