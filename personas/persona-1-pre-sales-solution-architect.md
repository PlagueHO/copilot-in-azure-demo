---
title: "Persona 1: Pre-Sales Solution Architect"
---

## Persona 1: Pre-Sales Solution Architect (Sales/Technical Evangelist)

**Name & Role:** *Alex Chen* – Pre-Sales Solutions Architect at Contoso’s partner firm. Alex works closely with the sales team and client stakeholders early in the project. Alex’s job is to understand the customer’s business challenges and design a high-level solution that demonstrates how Azure can meet those needs. Alex often creates proposal decks, architecture diagrams, and cost estimates as part of the sales process. With ~10 years of experience in cloud solutions, Alex has a strong technical background (spanning Azure services, security, and cost management) and serves as a **trusted advisor** to customer executives.

**Challenges:** In the pre-sales phase, time and clarity are critical. Alex needs to **quickly craft an architecture** that addresses Contoso Hotels’ requirements and aligns with Microsoft’s best practices (to inspire confidence). This includes mapping business requirements (e.g. “support peak seasonal traffic” or “improve uptime”) to appropriate Azure services. Alex must also answer on-the-spot questions from the customer – for instance, *“Can the system handle a regional outage?”* or *“How will this solution save us money?”* – even if Alex doesn’t have every detail memorized. **Cost estimation** is another challenge: Alex must outline the expected Azure costs for the proposed design and ensure the solution is cost-optimized (using the right pricing tiers, reserved instances, etc.). Additionally, Alex needs to articulate the **business value** of the Azure solution in simple terms (why this architecture is secure, reliable, and innovative) to excite non-technical decision makers. Overall, pre-sales architects often work under pressure to tailor solutions to client needs quickly and accurately.

**How Copilot in Azure Helps:** Microsoft Copilot in Azure acts as a smart cloud assistant that Alex can leverage during customer engagements. It can rapidly generate solution outlines and compare Azure services, drawing on Azure Architecture Framework guidelines and Alex’s own environment context. For example, if Alex needs to propose a secure and scalable web architecture, Copilot can suggest an appropriate mix of services (App Service, App Gateway, PostgreSQL, etc.) and even indicate how they fulfill the requirements (security, scalability, etc.). Copilot’s integration with Azure Cost Management means Alex can ask about **costs and pricing** in natural language – for instance, to forecast the monthly cost of the proposed environment – without manually crunching numbers. This helps Alex present a realistic budget to the customer on the fly. Copilot also has knowledge of Azure best practices and can **explain the benefits** of using certain services or architectures, which Alex can use to bolster the proposal. Essentially, Copilot provides Alex with on-demand technical knowledge and calculations, so Alex can **confidently answer customer questions and refine the solution live** in meetings. This creates confidence and excitement for the customer about the Azure plan.

## Demo Script – Pre-Sales Scenario

### Pre-Sales Scenario – Prompt 1

```text
Generate a high-level Azure architecture for an online hotel booking system with a web front-end, an application gateway, a PostgreSQL database, and a VM for background services. Include best practices for security and availability.
```

#### Rationale & Copilot Outcome

Alex asks Copilot for an architecture recommendation. Copilot will outline a solution using the mentioned services and align with best-practice principles, saving time in manually drafting diagrams.

### Pre-Sales Scenario – Prompt 2

```text
What would be the estimated monthly cost of running this Azure architecture for Contoso Hotels?
```

#### Rationale & Copilot Outcome

Cost is a major factor in any proposal. Copilot can interface with Azure Cost Management to provide a breakdown or total, streamlining budgeting in real time.

#### Pre-Sales Scenario – Prompt 3

```text
How does this solution follow Microsoft’s best practices, and what are the benefits for Contoso Hotels?
```

#### Rationale & Copilot Outcome

This prompt asks Copilot to articulate the **justification and value** of the proposed design. Copilot might enumerate that the solution adheres to the **Azure Well-Architected Framework’s five pillars – reliability, security, cost optimization, operational excellence, and performance efficiency** – and give examples: e.g., *“Using a fully managed App Service and Database increases reliability and security (patching and high availability are built-in), and the design can scale out to meet performance needs. The Application Gateway with WAF adds security against web threats. This alignment with best practices ensures Contoso’s solution will be resilient and efficient.”* Copilot will effectively summarize **why the architecture is a good one**, referencing best practices or Azure features. (Copilot might even pull from Azure Advisor recommendations for the deployed resources to highlight any improvements or confirmations of best practices.) Alex can use this output to explain to the customer *why* moving to Azure in this way is beneficial, thus driving excitement. It’s like having an expert cloud consultant validating the approach in real time.  

- *(Optionally,* **Prompt 4:** *“What are the benefits of using Azure App Service for our web application as opposed to VMs?”* *)**  
  **(Optional Outcome):** If time allows, Alex could drill into a specific service choice. For instance, asking why App Service is advantageous gives Copilot a chance to list benefits: fully managed PaaS (no server maintenance), auto-scaling, built-in security and compliance, faster development deployment, etc.. This is directly useful to persuade stakeholders that the team chose the right components. (This prompt is inspired by how Copilot can explain service benefits similar to documentation — e.g., a user could ask “What are the benefits and applications of Azure API Management?” and Copilot will explain. We expect a similar explanatory answer for App Service or any service in question.)

By the end of Persona 1’s demo, the audience sees that **Copilot enables a pre-sales architect to deliver a polished, well-architected solution proposal very quickly**. Alex was able to interact naturally with Azure Copilot to design an architecture, estimate its cost, and articulate its value – all in real time. This builds confidence that the Azure plan for Contoso Hotels is solid and aligns with Microsoft’s expertise, thereby helping win the customer’s approval.
