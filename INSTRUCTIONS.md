# Notes on Creating the Demonstration of Microsoft Copilot in Azure

I am preparing a demonstration of Microsoft Copilot in Azure to a Services Partner. The attendees at the session are ranging from pre-sales architects, to architects, engineers and SRE/Ops people. I am presenting an overview of Copilot in Azure but want to assemble a set of practical demos that I will run in Azure to demonstrate the power of this product.

I want you to assemble:

1. The story of the demonstration customer "Contoso Hotels" that is planning to migrate and modernize their hotel management solution to Azure as well as their front end web-booking and guest management system.
1. Come up with a demonstration script with prompts showing how Copilot for Azure can be used to assist the following personas:
    1. Pre-sales architects/sellers
    1. Architecture &amp; Design
    1. Engineering &amp; DevOps
    1. Ops and SRE

The demos should take no more than 5 minutes per persona and show a compelling narrative across all of the areas. The prompts should be clear and impactful as well as interesting. You should use https://learn.microsoft.com/en-us/azure/copilot/example-prompts as a starting point for prompts, but make them a bit more interesting and complex/challenging (stretch the limits).
Please provide:

1. The story narrative.
1. Details of the 4 personas (name, experience, challenges and how Copilot in Azure can help them)
1. The prompts they would run in Copilot for Azure to fill out a 5 minute demo for each persona.
1. The Azure resources and set up I would need to provide (including the easiest way to stand up the architecture in Azure/components required) for the demo environment.
1. The content that could be used for a couple of slides to introduce the demo scenarios, personas and the outcomes.
1. Anything else you think that would help make this an interesting and insightful demo.

## Personas

- Pre-sales architects/sellers: Need to create architecture quickly, answer customer questions on the fly and provide confidence and excitement to customers about what they're building in Azure. Need to define the costs of the architecture and ensure it solves business challenges in the right way using MS best practices.
- Architecture & Design: need to build and solve the appropriate business challenges, using Microsoft best practices, and well-architected framework. Need to have confident that they'll meet the functional/non-functional requirements and aide in choosing the appropriate technologies.
- Engineering and Devops: Need to build the right thing, the right way. Need to diagnose and solve bugs, write code, write infrastructure as code, using the correct engineering patterns. Might not be experts in every aspect of Azure, but need to get technical answers fast and build using the well-architected framework.
- Ops and SRE: Need to operate the platform, keep it up-to-date, ensure it operates optimally, diagnose errors and provide feedback to engineering on how to improve platform reliability. Need to provide patterns and practices to the rest of the team on how to operate the platform and keep improving it. Need to identify areas of weakness and issues before they arise and keep everything running smoothly. Need to diagnose live site issues quickly and effectively and document the issues and make improvements to prevent them in future.

I want to stick with mostly PaaS servers and VMs and common services (VM, VNET, App Gateway, Log Analytics/App Insights, Azure Database for PostgreSQL and Azure WebApp).I want things to be kept simple enough for users with limited technical knowledge to be able to understand, but get complex enough that even seasoned architects/engineers get benefit. I want it to be simple and quick for me as the demonstrator to quickly digest and prepare for.