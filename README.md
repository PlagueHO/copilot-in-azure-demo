# Microsoft Copilot in Azure – Contoso Hotels Migration Demo

## Introduction

### Overview

This document outlines a demonstration of Microsoft Copilot in Azure for the fictitious customer Contoso Hotels, prepared for a session with a services partner. The audience spans pre-sales architects, cloud architects, engineers, and SRE/Ops roles. We will show how Copilot in Azure serves as an AI assistant across the cloud adoption lifecycle – from solution design and cost estimation to deployment, optimization, and troubleshooting.

### Demo Goals

- Showcase a realistic cloud migration story (Contoso Hotels) and its business drivers.
- Illustrate how Copilot in Azure assists four personas – Pre-Sales Architect, Cloud Architect, DevOps Engineer, and SRE/Ops – in addressing their unique challenges.
- Provide example Copilot prompts for each persona that demonstrate powerful, non-trivial capabilities (beyond basic use) to stretch the limits of Copilot in Azure.
- Outline the Azure resources and setup for the demo environment, using mostly common PaaS services and a simple architecture that follows Microsoft best practices.
- Supply content for introduction slides (scenario, personas, outcomes) and additional tips to make the demo insightful and memorable.

---

## Contoso Hotels Migration Story Narrative  

**Company Background:** Contoso Hotels is a global hotel chain that operates properties across several countries. Its core IT system is a legacy on-premises **hotel management solution** (handling bookings, guest management, etc.) with a three-tier architecture supporting its website. As the business grew, Contoso Hotels faced **scalability issues and high maintenance costs** with this legacy system. For example, during peak holiday seasons the on-premises servers struggled to handle the surge in online bookings, and hardware upgrades were costly and slow. The company has decided to **migrate and modernize** this solution on Microsoft Azure to leverage cloud scalability, reduce operational overhead, and improve global accessibility.

**Modernization Goals:** Contoso’s plan is to rehost or refactor parts of the application using Azure’s Platform-as-a-Service (PaaS) offerings and modern cloud architecture:

- The **front-end web booking application** will be moved to an **Azure App Service** (Web App), providing a fully managed web hosting platform so developers can focus on features without managing servers. This will ensure easy scaling of the website and high availability (Azure App Service offers a 99.99% SLA for uptime).  
- The **back-end hotel management API and services** will run on Azure as well – some components might be containerized or kept on VMs if needed, but priority is given to PaaS. In our simplified scenario, one **Azure VM** will represent a back-end service or legacy component that has been lifted to Azure.  
- The **database** (which was a SQL Server instance on-prem) will migrate to **Azure SQL Database**, a fully managed database service. This gives Contoso automated backups, scaling, and patching, improving reliability without the need for DBA maintenance.  
- The solution will be deployed in a secure **virtual network** with an **Azure Application Gateway** acting as a web traffic load balancer and firewall (with the WAF feature) in front of the web application. This adds an extra layer of security and allows routing rules for HTTP(S) traffic.  
- **Monitoring and operations** will be handled with Azure’s built-in tools: logs and metrics from the App Service, VM, and database will feed into **Azure Monitor** (Log Analytics and Application Insights). This allows the ops team to detect issues and analyze performance in real time.

**Business Benefits:** By moving to Azure, Contoso Hotels expects to achieve better **scalability and reliability** (the cloud architecture can handle increasing loads and recover from failures) and reduce infrastructure management effort. Azure’s global presence also means the web app can be made accessible with low latency to international users as needed. Importantly, the modernization will address the legacy system’s pain points: *the new solution will scale on demand, be secured with Azure’s best practices, and optimize costs by using pay-as-you-go services*. As a fully managed PaaS solution for the web and data tiers, Azure offloads a lot of infrastructure work – Contoso’s developers “don’t have to worry about managing the underlying infrastructure” of web servers or databases, and can instead focus on delivering new features (like a better online booking experience).

**Story Arc:** In the demo narrative, we follow the Contoso Hotels project through four phases, each aligned with a persona:

1. In the **Pre-Sales** phase, a solution architect works with the customer (Contoso) to shape the Azure solution, answer their questions, and ensure the proposal meets business needs (including cost and value using Azure).
2. In the **Architecture & Design** phase, a cloud architect finalizes the technical design, making sure it adheres to the Azure Well-Architected Framework and chooses the right services and configurations for requirements.
3. During **Engineering & DevOps**, the team implements the solution – writing infrastructure as code, deploying resources, and developing application code – leveraging Copilot to speed up development and troubleshoot issues.
4. Finally, in **Operations (Ops & SRE)**, the system runs in production; the ops team uses Copilot to monitor the environment, quickly diagnose incidents, and continuously improve the system’s reliability and performance.

Throughout these phases, **Microsoft Copilot in Azure** serves as an intelligent assistant for the team. It integrates with the Azure environment and documentation to help design the solution, answer technical questions, generate code or scripts, assess cost implications, and analyze operational data using plain natural language queries. Copilot essentially helps the team **“simplify how you design, operate, optimize, and troubleshoot”** the Contoso Hotels application in Azure. This demonstration will highlight concrete examples of these capabilities per persona.

---

## Personas and Copilot-Assisted Scenarios  

To make the demo relatable, we introduce four personas involved in Contoso’s Azure project. Below we detail each persona’s background, their key challenges, and how Copilot in Azure addresses those needs. For each persona, we also outline a **demo script with example Copilot prompts** they might use, ensuring a 5-minute demonstration of Copilot’s impact on their tasks.

- [Persona 1: Pre-Sales Solution Architect (Sales/Technical Evangelist)](/personas/persona-1-pre-sales-solution-architect.md)
- [Persona 2: Cloud Architect (Architecture & Design)](/personas/persona-2-cloud-architect.md)
- [Persona 3: DevOps Engineer (Engineering & DevOps)](/personas/persona-3-devops-engineer.md)
- [Persona 4: SRE/Ops Engineer (Operations & Reliability)](/personas/persona-4-sre-ops-engineer.md)
---

## Azure Demo Environment Setup and Architecture  

To support the above scenarios, we need a **demo Azure environment** for Contoso Hotels that includes the key components of the solution. We will outline the required Azure resources and how to set them up, favoring simplicity and using mostly PaaS services as specified. Additionally, we’ll discuss the easiest way to deploy this environment (for the demonstrator to prepare ahead of time).

**Target Architecture Components:**  
The Contoso Hotels demo environment will consist of the following Azure resources (aligning with the story we told):

- **Resource Group:** A single Azure Resource Group (e.g., `RG-ContosoHotels-Demo`) in a chosen region (for example, East US or similar) to contain all resources for easy management.
- **App Service (Web App):** The front-end web application will be hosted on an **Azure App Service**. We will create an App Service Plan (Linux, say **P0v3** tier for demo) and a Web App for the Contoso front-end. This will run a .NET Core 6.0 web application with **Application Insights** enabled for monitoring. The App Service will be secured with a **private endpoint** in the frontend subnet. In our scenario, we might name it `contoso-web` for clarity.
- **Azure SQL Database:** The application database will be hosted on **Azure SQL Database** with a managed SQL Server instance. For demo, we'll use the Basic tier (Basic/2GB) which is sufficient for demonstration purposes. This can be named `contoso-db-server` with a database called `hotelsdb`. The SQL Database will be secured with a **private endpoint** in the backend subnet for secure connectivity.
- **Key Vault:** **Azure Key Vault** will securely store application secrets, connection strings, and certificates. It will be deployed with a **private endpoint** in the shared subnet to ensure secure access from within the virtual network.
- **Virtual Network and Subnets:** An **Azure Virtual Network** to host all components with proper network segmentation. The VNet (10.0.0.0/16) includes five subnets:
  - **Application Gateway subnet** (`snet-appgw`, 10.0.0.0/24) - Hosts the Application Gateway
  - **Frontend subnet** (`snet-frontend`, 10.0.1.0/24) - Contains the App Service private endpoint  
  - **Backend subnet** (`snet-backend`, 10.0.2.0/24) - Contains the Azure SQL Database private endpoint
  - **VM subnet** (`snet-vm`, 10.0.3.0/24) - Hosts the Windows Virtual Machine
  - **Shared subnet** (`snet-shared`, 10.0.4.0/24) - Contains the Key Vault private endpoint and shared services

  The VNet ensures secure communication between components and provides network isolation. All database and App Service traffic flows through private endpoints for enhanced security.
- **Azure VM:** One virtual machine to represent a legacy component or background service. We will create a small VM (e.g., a **B2ms** Windows VM) named `contoso-backend`. This VM can host a dummy service or simply be idle; its purpose in the demo is to have something to show VM-specific operations (like alerts, metrics). We will install maybe IIS or a simple app on it to generate some CPU or logs (for the SRE demo part). The VM will be in the VNet (in the VM subnet). We should also install the Azure Monitor **Log Analytics agent** or use the Azure Monitor Extension on this VM so that its metrics and logs feed into Azure Monitor (enabling us to query them via Copilot). The VM's monitoring data will make the Ops scenario richer (e.g., high CPU alert).
- **Application Gateway:** An **Azure Application Gateway** with **Web Application Firewall (WAF)** enabled, placed in the Application Gateway subnet. The App Gateway will be configured to route HTTPS traffic to the Web App through its private endpoint, providing secure load balancing and traffic management. The WAF provides protection against common web vulnerabilities and attacks. The App Gateway will generate telemetry and access logs that feed into Log Analytics for monitoring and analysis.
- **Azure Monitor Setup:**
  - **Log Analytics Workspace:** to collect logs and metrics from resources. We will link the App Service, VM, and SQL Database to this workspace (via App Insights and VM extension respectively). This allows unified querying of logs (Copilot can utilize Azure Monitor queries across these).
  - **Application Insights:** for the Web App (as noted). In Azure, if we create an App Service and enable "Application Insights", it will either create a new AI resource or use Workspace-based mode in the Log Analytics. Either way, ensure telemetry from the web app is being collected (requests, exceptions, performance counters).
  - **Alerts:** define sample alert rules including VM CPU > 80% for 5 minutes and App Service HTTP 5xx errors > 5 in 5 minutes. These alerts should be configured to demonstrate Azure Monitor capabilities. We can trigger them manually by running a CPU stress test on the VM or sending requests to the web app. Having these alerts in place will let Copilot's queries (in Persona 4 demo) show results like "critical alerts in last 24h".
  
- **Security and Access:** Since this is a demo, we use **managed identity** for the web app to access the SQL Database securely. The database, Key Vault, and App Service are all secured with **private endpoints** to ensure secure network connectivity within the virtual network. The Key Vault stores database connection strings and other secrets securely.

- **Data and App Content:** The actual application code can be minimal. For instance, we could deploy a basic **.NET Core 6.0 web application** that connects to the Azure SQL Database and shows some hotel data. The benefit of deploying a sample app is that it can generate some logs (e.g., application logs or errors if misconfigured), which we can then query with Copilot. We could populate a bit of dummy hotel data in the SQL Database so the app runs and generates realistic telemetry.
  
  However, given time constraints for preparation, a simpler approach: deploy a known sample through Azure Developer CLI or manually follow a tutorial to have a working app with SQL Database. This way the environment has realistic components.

**Easiest Deployment Method:** The simplest path to stand up this environment is to use **Azure CLI with Bicep templates** using **Azure Verified Modules (AVM)** (as implemented in the `infra/main.bicep` file). The infrastructure uses modern Azure best practices with private endpoints, proper network segmentation, and comprehensive monitoring. The Bicep template can be deployed with Azure CLI to create all resources in one go and can be repeated if needed. Using Infrastructure as Code (IaC) also aligns with best practices and makes cleanup easier after the demo.

Alternatively, if time is short or for an initial quick setup, one could use the Azure Portal manually to create each component (there are only a handful). But manual setup should be followed carefully to ensure things like monitoring and networking are configured correctly.

Another approach is to use an existing **reference deployment**:
Microsoft has a GitHub repository called **Contoso Hotels Demo** which promises a “fully integrated Azure environment… deployed by at-scale best practices”. That sounds very relevant – it likely automates deploying a similar environment with best practices baked in. However, using that might introduce extra complexity or components we don’t need (and possibly require certain tools to deploy). For our focused scenario, building it manually or with a custom script might be more straightforward. Still, referencing that repository could be useful for inspiration or validation of our architecture choices.

**Verification:** After deployment, we should verify:

- The web app can reach the database (e.g., via a simple web page that fetches some data).
- Application Insights is logging requests from the web app.
- The VM is running and sending heartbeats to Log Analytics. Possibly generate some CPU load on the VM (using a script or stress tool) to test that our alert triggers.
- The Application Gateway is functioning (if configured to route to the web app, ensure the web app is accessible through the gateway’s public IP/DNS). If this is complicated, note that for the demo, we don’t actually *need* to demonstrate traffic flowing through App Gateway. We mainly included it as part of architecture and for Q&A with Copilot. We could simplify by not actually wiring it to the web app and just assume it’s there. But it might be nice to show in the Azure portal that App Gateway is deployed and perhaps has some metrics (though without sending traffic through it, metrics would be blank).

By having this environment ready, the Copilot prompts in the demo will return realistic information (especially for Persona 4 where we query logs/alerts – those require actual data). The environment should remain running during the presentation so that Copilot can query live info (Copilot in Azure uses the actual Azure environment data in real-time).

**Summary of Azure Components to Provision:** (for reference in a slide or documentation)

- Azure Resource Group: **rg-{environmentName}** in specified region.  
- **Web App (App Service)**: Name: *contoso-web-{uniqueSuffix}*, Runtime: .NET Core 6.0, Plan: *P0v3*, with App Insights and private endpoint.  
- **Azure SQL Database**: Name: *contoso-db-{uniqueSuffix}*, Basic tier (2GB), with private endpoint in backend subnet.  
- **Key Vault**: Name: *contoso-{uniqueSuffix}*, with private endpoint in shared subnet for secure secrets storage.
- **Virtual Network**: Name: *contoso-hotels-{uniqueSuffix}* (10.0.0.0/16) with subnets: *snet-appgw* (10.0.0.0/24), *snet-frontend* (10.0.1.0/24), *snet-backend* (10.0.2.0/24), *snet-vm* (10.0.3.0/24), *snet-shared* (10.0.4.0/24).  
- **Application Gateway**: Name: *contoso-{uniqueSuffix}*, Tier: WAF_v2, in *snet-appgw*, with public IP and WAF policy. Routes traffic to Web App via private endpoint.  
- **Virtual Machine**: Name: *contoso-backend*, Windows Server 2022, Size: B2ms, in *snet-vm*. Monitoring agent installed for telemetry collection.  
- **Log Analytics Workspace**: Name: *contosologs-{uniqueSuffix}*. App Service, VM, and SQL Database connected for unified monitoring.  
- **Alert Rules**: VM CPU > 80%, App Service HTTP 5xx errors > 5 in 5 minutes.  
- **Private DNS Zones**: Three zones for App Service, SQL Database, and Key Vault private endpoint resolution.

This environment setup covers the infrastructure needed to follow the narrative and is intentionally kept **as simple as possible while including common Azure services**. By using mostly PaaS (App Service, managed DB, App Gateway) and one VM, we ensure the demo touches on both worlds (PaaS and IaaS). Each component was chosen for a reason in the story and will allow demonstrating Copilot features:

- App Service & DB: for application design, cost, and some troubleshooting prompts.
- VM: for monitoring/alerting and an example of IaaS management with Copilot.
- App Gateway: primarily to discuss in design (Firewall vs Gateway question) and to complete a realistic architecture diagram.
- Azure Monitor components: to enable rich operations queries.

**Preparations:** The demonstrator (you) should deploy this ahead of the session, and perhaps **seed some activity**:
Deploy the sample app and generate some logs (open the site, maybe cause a 404/500 error to have something in logs), and artificially trigger the VM CPU alert (e.g., run `stress` or a CPU-bound task on the VM). This way, when Copilot is asked about “overnight alerts” or “why is the app slow?”, there is data to parse. Ensure that you have Microsoft Copilot in Azure enabled in that subscription and with access to the resource group. Then you’ll be ready to run the scripted prompts live.

---

## Additional Insights and Recommendations for an Engaging Demo  

To ensure this demonstration is **interesting, insightful, and credible**, consider the following tips and additional points:

- **Live Demo vs. Storytelling:** The plan above is narrative-driven, but whenever possible, use the actual **Copilot in Azure interface live** to execute the prompts. Seeing the AI respond in real time will greatly impress the audience. Practice each prompt beforehand to know what Copilot’s answer looks like, and adjust wording if needed. Copilot’s responses might vary, but the general capabilities should match what’s described (the example prompts we’ve cited are indicative of what it can do).
- **Emphasize AI-augmented Productivity:** Highlight quantitatively or qualitatively how Copilot made a difference. For example, “It might normally take me half a day to write this deployment template, but Copilot did it in 30 seconds.” Or “Without Copilot, diagnosing that 2 AM issue might have required combing through thousands of log lines; Copilot summarized the root cause almost instantly.” These comparisons drive home the value.
- **Multi-Persona Narrative Flow:** Though we present personas separately, connect the story: e.g., after Alex (pre-sales) wins the project, “Brenda picks up the baton to design it thoroughly…”, then after design, “Carlos and team build the solution…”, then “Once live, Diana ensures it runs well…”. This makes the demonstration feel like one coherent story of Contoso’s journey, rather than four disjointed demos.
- **Address the Audience Roles:** Since the attendees themselves range from pre-sales to engineers to ops, each persona’s segment will resonate with those specific people. Encourage them to notice the part most relevant to their daily job. This will make the demo personally relevant. For example, mention: “If you’re an architect, imagine having Copilot as your design assistant – as we see with Brenda – it’s like having an Azure expert on call.” Similarly for ops folks with Diana’s part.
- **Public Documentation and Transparency:** It may be worth mentioning that Copilot’s suggestions are based on Azure’s vast documentation and proven practices (and that it can even cite documentation or provide links when asked). In other words, it isn’t “making things up” – it often uses Azure Advisor and official guidance. This can build trust in the tool’s outputs. You can illustrate this by asking Copilot something like “Why do you recommend that?” after a suggestion, to show it can explain itself or refer to docs.
- **Safe Handling of Actions:** If performing any Copilot actions live (like enabling auto-heal, or running a script), reassure the audience that Copilot always asks for confirmation before making changes. This addresses any concern about an AI making unauthorized changes. And indeed, Copilot in Azure will not execute a destructive action without user approval.
- **Acknowledge Limitations (if asked):** While our scenario is very optimistic, be ready to answer questions like “What if Copilot gives a wrong answer?” or “Does it handle all Azure services?”. You can answer that Copilot is continually improving with new Azure services (the documentation says it’s not exhaustive but covers many scenarios). If an answer seems off, users can always double-check – but in practice, it’s a huge time-saver even if it occasionally needs slight corrections. The demo itself, if well-prepared, will show mostly accurate info.
- **No Credentials or Sensitive Data:** As per request, ensure any prompt or output in the demo does not show real passwords, keys, or sensitive info. Our scenario uses only fictitious data (Contoso, etc.). If Copilot tries to display a connection string or password, skip over or mask it. But likely it won’t unless specifically asked.
- **Engage the Audience with Q&A:** After the personas, consider asking the audience how **they** might use Copilot in their projects. For example, “Can you imagine how you would use Copilot day-to-day? Perhaps to quickly check on cost usage or generate a script? – The possibilities are broad.” This involvement makes the session interactive. 
- **Future Developments:** Mention that Copilot in Azure is part of a wave of AI assistance in Microsoft products (others being GitHub Copilot, Microsoft 365 Copilot, etc.), and that it’s evolving. For instance, integration with more Azure services and even deeper actions (maybe future it can handle complex multi-step tasks). This positions the partner to be excited that Microsoft is heavily investing in these AI tools.
- **Real-world Case (if available):** If any early adopter stories or case studies exist where Copilot helped a project (maybe internal anecdote or reference), that could add weight. Even a hypothetical: “Imagine onboarding a new team member – with Copilot, they can ask questions instead of always hunting through docs. It’s like training wheels that never leave, even experts can lean on it to save time.”
- **During the Demo – Show Both Prompt and Result:** For clarity, when you run a Copilot prompt, narrate or show what you asked and then scroll to the answer, highlighting key parts of the response. E.g., “Copilot just gave us a full Bicep file – here’s the snippet defining the web app and database. Notice it even configured the connection string setting in the web app for the database – pretty neat, it’s tying things together!” This helps people digest the content of the answers, which might be text-dense.
- **Timing:** Ensure each persona demo really stays around 5 minutes. Rehearse to trim extraneous steps. It’s tempting to explore more with Copilot, but given four personas that’s ~20 minutes of demo, plus intro/outro, which fits a typical session. If time is short, prioritize two or three key prompts per persona that best showcase unique capabilities (some might overlap otherwise).
- **Backup Plan:** Live demos can be unpredictable. It’s good to have screenshots or pre-recorded snippets of Copilot interactions in case something fails (network issues, etc.). For instance, have the Q&A already captured as images in the slide deck after the formal slides. That way you can smoothly switch to “Alright, if the Wi-Fi doesn’t cooperate, here’s what Copilot would have shown…”. This ensures the demo message still lands.

Finally, end the session on a high note by reiterating the transformative potential of Copilot. Perhaps something like: **“As we saw with Contoso Hotels, Microsoft Copilot in Azure augments human expertise with AI, making cloud solutions development and operations smarter and faster. It’s like having an Azure expert by your side at all times. We’re excited to see how you – as our partner – will leverage this tool for your customers and projects.”** This leaves the audience with the insight that embracing such AI tools can give them an edge in their work.

By following this plan, the demonstration will not only show *how* to use Copilot in Azure with practical prompts, but also *why* it matters for each stakeholder in a cloud project. It connects technology to business value (faster delivery, better systems, happier customers) which is key in any partner presentation. The audience should walk away both informed and inspired to try Copilot in their own Azure environment.

---
