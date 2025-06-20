# All Persona Prompts

## Persona 1: Pre-Sales Solution Architect (Alex Chen)

### Pre-Sales Scenario – Prompt 1

```text
Suggest an architecture pattern and Azure services for an online hotel booking system with a web front-end, and a backend relational database. It should use PaaS services, be secure, and scalable for Contoso Hotels to handle high traffic during peak booking seasons.
```

### Pre-Sales Scenario – Prompt 2

```text
How does this solution follow Microsoft’s best practices, and what are the benefits for Contoso Hotels?
```

### Pre-Sales Scenario – Prompt 3

```text
What are the benefits of using Azure App Service for our web application as opposed to VMs?
```

### Pre-Sales Scenario – Prompt 4

```text
Contoso Hotels have asked for an SLO of 99.99% from the reliable web application pattern - how can I achieve this?
```

### Pre-Sales Scenario – Prompt 5

```text
Create a comprehensive cost comparison between running our hotel booking system on Azure versus on-premises infrastructure. Include 3-year TCO analysis and highlight cost optimization opportunities.
```

### Pre-Sales Scenario – Prompt 6

```text
What are the security benefits and compliance features Azure provides for a hotel booking system that handles PCI DSS requirements and guest personal data? Generate a security checklist.
```

### Pre-Sales Scenario – Prompt 7

```text
Demonstrate how Azure's AI and machine learning services could enhance Contoso Hotels' booking system with personalized recommendations and dynamic pricing. What services would you recommend?
```

### Pre-Sales Scenario – Prompt 8

```text
Design a disaster recovery strategy for Contoso Hotels that guarantees business continuity. What's our RTO and RPO with Azure's DR capabilities?
```

### Pre-Sales Scenario – Prompt 9

```text
Show me how Azure's global infrastructure can help Contoso Hotels expand internationally. Which regions should we deploy to for optimal performance and compliance?
```

### Pre-Sales Scenario – Prompt 10

```text
Generate a step-by-step migration roadmap from Contoso Hotels' current legacy system to Azure. Include timeline, risk mitigation, and business impact assessment.
```

### Pre-Sales Scenario – Prompt 11

```text
How can Azure's sustainability features help Contoso Hotels achieve their carbon-neutral goals? Provide environmental impact metrics and green computing recommendations.
```

### Pre-Sales Scenario – Prompt 12

```text
Create a real-time dashboard concept showing how Azure Monitor and Application Insights would give Contoso Hotels visibility into their booking system performance and customer experience.
```

### Pre-Sales Scenario – Prompt 13

```text
What would be the business value and ROI of implementing Azure's serverless technologies (Functions, Logic Apps) for Contoso Hotels' event-driven booking workflows?
```

### Pre-Sales Scenario – Prompt 14

```text
Design an omnichannel customer experience architecture using Azure services that integrates Contoso Hotels' website, mobile app, chatbots, and customer service systems.
```

### Pre-Sales Scenario – Prompt 15

```text
How can Azure's IoT capabilities transform Contoso Hotels' operations with smart room automation, predictive maintenance, and guest experience enhancement?
```

## Persona 2: Cloud Architect (Brenda Rodriguez)

### Architecture & Design Scenario – Prompt 1

```text
We need high availability and disaster recovery for the Contoso Hotels database. What is the best way to architect Azure SQL Database for failover, and what features should we use?
```

### Architecture & Design Scenario – Prompt 2

```text
Should I deploy an Azure Firewall or is the Application Gateway sufficient for securing the web application?
```

### Architecture & Design Scenario – Prompt 3

```text
Our architecture uses an App Service, a VM, Azure SQL Database, and an App Gateway. Do you see any security or compliance gaps in this design? What should we add or change to follow best practices?
```

### Architecture & Design Scenario – Prompt 4

```text
What is the most cost-efficient way to run the web application: using Azure App Service or containerizing it on an AKS cluster?
```

### Architecture & Design Scenario – Prompt 5

```text
Design a zero-trust network architecture for Contoso Hotels. How should I implement microsegmentation, identity verification, and least-privilege access across our Azure infrastructure?
```

### Architecture & Design Scenario – Prompt 6

```text
Our Contoso Hotels system needs to handle 100,000 concurrent users during flash sales. Evaluate our current architecture and recommend specific scaling strategies and Azure services.
```

### Architecture & Design Scenario – Prompt 7

```text
Analyze the trade-offs between using Azure SQL Database versus Azure Database for PostgreSQL for our hotel booking system. Consider performance, features, and cost implications.
```

### Architecture & Design Scenario – Prompt 8

```text
Design a multi-region active-active architecture for Contoso Hotels that ensures data consistency while minimizing latency for global customers. How do we handle conflict resolution?
```

### Architecture & Design Scenario – Prompt 9

```text
What's the optimal network topology for our hotel infrastructure? Should we use hub-and-spoke, mesh, or virtual WAN architecture? Include connectivity to on-premises data centers.
```

### Architecture & Design Scenario – Prompt 10

```text
Evaluate Azure's PaaS versus IaaS options for our hotel booking workload. Create a decision matrix considering scalability, management overhead, security, and total cost of ownership.
```

### Architecture & Design Scenario – Prompt 11

```text
Design a comprehensive backup and disaster recovery strategy that meets a 15-minute RPO and 1-hour RTO. What Azure services should we use and how do we test failover scenarios?
```

### Architecture & Design Scenario – Prompt 12

```text
How should we architect our data pipeline to process real-time booking events, guest preferences, and business analytics? Recommend Azure services for streaming, storage, and analytics.
```

### Architecture & Design Scenario – Prompt 13

```text
Design a secure API architecture for Contoso Hotels that supports mobile apps, third-party integrations, and internal systems. Include authentication, rate limiting, and monitoring strategies.
```

### Architecture & Design Scenario – Prompt 14

```text
Evaluate whether our hotel management system should use serverless computing (Functions, Logic Apps) or container-based architecture (AKS, Container Apps). What are the architectural implications?
```

### Architecture & Design Scenario – Prompt 15

```text
Design a comprehensive monitoring and observability strategy for our multi-tier application. How do we implement distributed tracing, metrics collection, and intelligent alerting across Azure services?
```

### Architecture & Design Scenario – Prompt 16

```text
How should we implement data governance and compliance controls for guest data across our Azure environment? Design an architecture that supports GDPR, PCI DSS, and SOC 2 requirements.
```

### Architecture & Design Scenario – Prompt 17

```text
Analyze the security posture of our current Azure architecture. Identify potential attack vectors and recommend defensive strategies using Azure security services and best practices.
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
Help me write a GitHub Actions workflow (YAML) to build and deploy the Contoso Hotels web app to Azure.
```

### Engineering/DevOps Scenario – Prompt 4

```text
The application is up. Can you suggest some Azure monitoring or logging setup I should do to ensure we catch errors and performance issues?
```

### Engineering/DevOps Scenario – Prompt 5

```text
Help me create a cost-efficient Linux VM for our backend processing server. I need it to be resilient but also budget-friendly for Contoso Hotels.
```

### Engineering/DevOps Scenario – Prompt 6

```text
Generate an Azure CLI script to create a virtual network with three subnets: one for App Gateway (10.0.1.0/24), one for App Services (10.0.2.0/24), and one for database (10.0.3.0/24) using the address space 10.0.0.0/16.
```

### Engineering/DevOps Scenario – Prompt 7

```text
My VM deployment failed with an allocation error. Can you help troubleshoot what went wrong and suggest how to fix it?
```

### Engineering/DevOps Scenario – Prompt 8

```text
I need to copy our production VM to a disaster recovery region (East US 2). What's the best way to replicate the VM configuration while ensuring all dependencies are properly handled?
```

### Engineering/DevOps Scenario – Prompt 9

```text
Create an Azure CLI script to set up auto-scaling for our App Service and configure backup policies for our Azure SQL Database, including cross-region backup.
```

### Engineering/DevOps Scenario – Prompt 10

```text
Help me choose the right VM size for a compute-intensive background job processor that will handle hotel booking analytics. It needs to process large datasets efficiently.
```

### Engineering/DevOps Scenario – Prompt 11

```text
My web app can't connect to the database due to network security group rules. Can you help me troubleshoot the connectivity issue and create the necessary security rules?
```

### Engineering/DevOps Scenario – Prompt 12

```text
Generate a PowerShell script to automate the deployment of our entire Contoso Hotels infrastructure, including error handling and rollback capabilities.
```

## Persona 4: IT Operations Lead / SRE (Diana Lee)

### Ops/SRE Scenario – Prompt 1

```text
It’s 9am, did any critical alerts trigger overnight on the Contoso Hotels system? Summarize any incidents.
```

### Ops/SRE Scenario – Prompt 2

```text
Run a root cause analysis for the high CPU alert on the backend VM around 2:45 AM.
```

### Ops/SRE Scenario – Prompt 3

```text
What actions can we take to prevent or mitigate this kind of high CPU event on the VM in the future?
```

### Ops/SRE Scenario – Prompt 4

```text
Enable auto-healing on the Contoso web app and set up a rule to recycle the app if CPU usage stays high for 5 minutes.
```

### (Optional) Ops/SRE Scenario – Prompt 5

```text
Are there any security or compliance issues in our Azure environment right now?
```

### Ops/SRE Scenario – Prompt 6

```text
Summarize our Contoso Hotels costs for the last 6 months and identify the top 3 services driving our expenses. What recommendations do you have to reduce costs?
```

### Ops/SRE Scenario – Prompt 7

```text
Can you forecast our expected Azure costs for the next 3 months based on current usage patterns? Include any potential cost impact from the upcoming holiday booking season.
```

### Ops/SRE Scenario – Prompt 8

```text
Visualize our entire network topology across all subscriptions. I need to understand the connectivity between our App Gateway, App Services, and database infrastructure.
```

### Ops/SRE Scenario – Prompt 9

```text
Show me the network topology for our virtual network hosting the Contoso Hotels application. Include insights on traffic patterns and connectivity health.
```

### Ops/SRE Scenario – Prompt 10

```text
Find all VMs that are currently running in our environment and stop any non-production VMs to save costs during off-peak hours.
```

### Ops/SRE Scenario – Prompt 11

```text
Compare how our costs changed from last month to this month, broken down by service. What caused the biggest cost increases?
```

### Ops/SRE Scenario – Prompt 12

```text
Restart all App Services in the West US region that are showing performance issues. Confirm the list before executing.
```

### Ops/SRE Scenario – Prompt 13

```text
What was our virtual machine spending last month compared to our database costs? Show me a breakdown by region and resource group.
```

### Ops/SRE Scenario – Prompt 14

```text
Enable backup on all VMs in our production resource group that don't currently have backup configured.
```

### Ops/SRE Scenario – Prompt 15

```text
Analyze our network connectivity between the App Gateway and backend services. Are there any bottlenecks or security gaps I should be aware of?
```
