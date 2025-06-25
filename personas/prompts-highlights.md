# Copilot in Azure Demo - Highlight Prompts

## Selected high-impact prompts demonstrating key Azure Copilot capabilities across different personas

## Persona 1: Pre-Sales Solution Architect (Alex Chen)

### Pre-Sales Scenario – Prompt 1

```text
Suggest an architecture pattern and Azure services for an online hotel booking system with a web front-end, and a backend relational database. It should use PaaS services, be secure, and scalable for Contoso Hotels to handle high traffic during peak booking seasons.
```

### Pre-Sales Scenario – Prompt 2

```text
How does this solution follow Microsoft's best practices, and what are the benefits for Contoso Hotels?
```

### Pre-Sales Scenario – Prompt 3

```text
What are the security benefits and compliance features Azure provides for a hotel booking system that handles PCI DSS requirements and guest personal data?
```

### Pre-Sales Scenario – Prompt 4

```text
What are the benefits of using Azure App Service for our web application as opposed to VMs?
```

### Pre-Sales Scenario – Prompt 5

```text
Contoso Hotels have asked for an SLO of 99.99% from the reliable web application pattern - how can I achieve this?
```

## Persona 2: Cloud Architect (Brenda Rodriguez)

### Architecture & Design Scenario – Prompt 1

```text
Our architecture uses an App Service, a VM, Azure SQL Database, and an App Gateway. Do you see any security or compliance gaps in this design? What should we add or change to follow best practices?
```

### Architecture & Design Scenario – Prompt 2

> [!NOTE]
> This prompt should start a question process.

```text
Should I deploy an Azure Firewall or is the Application Gateway sufficient for securing the web application?
```

### Architecture & Design Scenario – Prompt 3

```text
How would implementing Azure ExpressRoute benefit Contoso Hotels' architecture for high availability and performance? What are the design considerations for connecting our on-premises data centers to Azure?
```

## Persona 3: DevOps Engineer (Carlos Moreno)

### Engineering/DevOps Scenario – Prompt 1

```text
Generate a Bicep template to set up the Contoso Hotels environment: a Resource Group, an App Service (Linux) for the web app, an Azure SQL Database server, a virtual network with two subnets (one for the App Gateway, one for the DB/VM), and an Application Gateway in the front.
```

### Engineering/DevOps Scenario – Prompt 2

```text
Publishing the web app to the Azure Web App, I get an error: 'Publish using zip deploy option is not supported for MSBuild package type'. What could be the cause and how do I fix it?
```

### Engineering/DevOps Scenario – Prompt 3

```text
Generate an Azure CLI script to create a virtual network with three subnets: one for App Gateway (10.0.1.0/24), one for App Services (10.0.2.0/24), and one for database (10.0.3.0/24) using the address space 10.0.0.0/16.
```

### Engineering/DevOps Scenario – Prompt 4

> [!NOTE]
> This prompt should start a question process.

```text
Help me create a cost-efficient Linux VM for our backend processing server. I need it to be resilient but also budget-friendly for Contoso Hotels.
```

## Persona 4: IT Operations Lead / SRE (Diana Lee)

These prompts require that the Contoso Hotels environment is already set up in Azure with the necessary resources and configurations. It also requires an Azure offer type that allows for [cost management data access](https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/understand-cost-mgt-data#supported-microsoft-azure-offers).

### Ops/SRE Scenario – Prompt 1

```text
Summarize our costs for the last 6 months and identify the top 3 services driving our expenses. What recommendations do you have to reduce costs?
```

### Ops/SRE Scenario – Prompt 2

```text
Visualize our entire network topology across all subscriptions. I need to understand the connectivity between our App Gateway, App Services, and database infrastructure.
```

### Ops/SRE Scenario – Prompt 3

```text
Find all VMs that are currently running in our environment and stop any non-production VMs to save costs during off-peak hours.
```

### Ops/SRE Scenario – Prompt 4

```text
Is my Storage Account secure? Check for any security vulnerabilities or compliance issues, and provide recommendations to improve our security posture.
```

### Ops/SRE Scenario – Prompt 5

```text
My web app can't connect to the database due to network security group rules. Can you help me troubleshoot the connectivity issue and create the necessary security rules?
```

### Ops/SRE Scenario – Prompt 6

```text
Enable auto-healing on the Contoso web app and set up a rule to recycle the app if CPU usage stays high for 5 minutes.
```

### Ops/SRE Scenario – Prompt 7

```text
Restart all App Services in the Australia East region that are showing performance issues. Confirm the list before executing.
```

### Ops/SRE Scenario – Prompt 8

```text
Enable backup on all VMs in our production resource group that don't currently have backup configured.
```

---

### Other Language

```text
Résumez nos coûts des six derniers mois et identifiez les trois services principaux responsables de nos dépenses. Quelles recommandations proposez-vous pour réduire les coûts?
```

## Key Capabilities Demonstrated

These prompts showcase the following documented Azure Copilot capabilities:

- **Architecture Guidance**: Service recommendations and best practices
- **Cost Management**: Analysis, forecasting, and optimization recommendations
- **Code Generation**: Bicep templates, Azure CLI scripts, and PowerShell
- **Troubleshooting**: Problem diagnosis and resolution guidance
- **Security Assessment**: Compliance analysis and security recommendations
- **Resource Management**: VM creation, network configuration, and resource queries
- **Network Visualization**: Topology mapping and connectivity analysis
- **Command Execution**: Resource management and operational tasks
