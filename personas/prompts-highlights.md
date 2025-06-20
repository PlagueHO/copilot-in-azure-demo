# Copilot in Azure Demo - Highlight Prompts

## Selected high-impact prompts demonstrating key Azure Copilot capabilities across different personas

## Persona 1: Pre-Sales Solution Architect (Alex Chen)

### Pre-Sales Scenario – Prompt 1

```text
Suggest an architecture pattern and Azure services for an online hotel booking system with a web front-end, and a backend relational database. It should use PaaS services, be secure, and scalable for Contoso Hotels to handle high traffic during peak booking seasons.
```

### Pre-Sales Scenario – Prompt 2

```text
Create a comprehensive cost comparison between running our hotel booking system on Azure versus on-premises infrastructure. Include 3-year TCO analysis and highlight cost optimization opportunities.
```

### Pre-Sales Scenario – Prompt 3

```text
What are the security benefits and compliance features Azure provides for a hotel booking system that handles PCI DSS requirements and guest personal data? Generate a security checklist.
```

### Pre-Sales Scenario – Prompt 4

```text
Generate a step-by-step migration roadmap from Contoso Hotels' current legacy system to Azure. Include timeline, risk mitigation, and business impact assessment.
```

## Persona 2: Cloud Architect (Brenda Rodriguez)

### Architecture & Design Scenario – Prompt 1

```text
Our architecture uses an App Service, a VM, Azure SQL Database, and an App Gateway. Do you see any security or compliance gaps in this design? What should we add or change to follow best practices?
```

### Architecture & Design Scenario – Prompt 2

```text
Design a zero-trust network architecture for Contoso Hotels. How should I implement microsegmentation, identity verification, and least-privilege access across our Azure infrastructure?
```

### Architecture & Design Scenario – Prompt 3

```text
Our Contoso Hotels system needs to handle 100,000 concurrent users during flash sales. Evaluate our current architecture and recommend specific scaling strategies and Azure services.
```

### Architecture & Design Scenario – Prompt 4

```text
Design a comprehensive backup and disaster recovery strategy that meets a 15-minute RPO and 1-hour RTO. What Azure services should we use and how do we test failover scenarios?
```

## Persona 3: DevOps Engineer (Carlos Moreno)

### Engineering/DevOps Scenario – Prompt 1

```text
Generate a Bicep template to set up the Contoso Hotels environment: a Resource Group, an App Service (Linux) for the web app, an Azure SQL Database server, a virtual network with two subnets (one for the App Gateway, one for the DB/VM), and an Application Gateway in the front.
```

### Engineering/DevOps Scenario – Prompt 2

```text
Deploying the web app, I get an error: 'Cannot connect to database: timeout expired'. What could be the cause and how do I fix it?
```

### Engineering/DevOps Scenario – Prompt 3

```text
Generate an Azure CLI script to create a virtual network with three subnets: one for App Gateway (10.0.1.0/24), one for App Services (10.0.2.0/24), and one for database (10.0.3.0/24) using the address space 10.0.0.0/16.
```

### Engineering/DevOps Scenario – Prompt 4

```text
Help me create a cost-efficient Linux VM for our backend processing server. I need it to be resilient but also budget-friendly for Contoso Hotels.
```

## Persona 4: IT Operations Lead / SRE (Diana Lee)

### Ops/SRE Scenario – Prompt 1

```text
Summarize our Contoso Hotels costs for the last 6 months and identify the top 3 services driving our expenses. What recommendations do you have to reduce costs?
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
My web app can't connect to the database due to network security group rules. Can you help me troubleshoot the connectivity issue and create the necessary security rules?
```

---

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
