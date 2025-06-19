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

## Persona 2: Cloud Architect (Brenda Rodriguez)

### Architecture & Design Scenario – Prompt 1

```text
We need high availability and disaster recovery for the Contoso Hotels database. What is the best way to architect the Azure Database for PostgreSQL for failover, and what features should we use?
```

### Architecture & Design Scenario – Prompt 2

```text
Should I deploy an Azure Firewall or is the Application Gateway sufficient for securing the web application?
```

### Architecture & Design Scenario – Prompt 3

```text
Our architecture uses an App Service, a VM, PostgreSQL DB, and an App Gateway. Do you see any security or compliance gaps in this design? What should we add or change to follow best practices?
```

### Architecture & Design Scenario – Prompt 4

```text
What is the most cost-efficient way to run the web application: using Azure App Service or containerizing it on an AKS cluster?
```

## Persona 3: DevOps Engineer (Carlos Moreno)

### Engineering/DevOps Scenario – Prompt 1

```text
Generate a Bicep template to set up the Contoso Hotels environment: a Resource Group, an App Service (Linux) for the web app, a PostgreSQL Flexible Server, a virtual network with two subnets (one for the App Gateway, one for the DB/VM), and an Application Gateway in the front.
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
