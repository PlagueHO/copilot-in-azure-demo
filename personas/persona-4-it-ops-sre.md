---
title: "Persona 4: IT Operations Lead / SRE (Operations Phase)"
---

## Persona 4: IT Operations Lead / SRE (Operations Phase)

**Name & Role:** *Diana Lee* – Site Reliability Engineer (SRE) and Operations Lead for Contoso’s Azure environment. Once the new system is live in Azure, Diana’s team is responsible for **running and maintaining** it. This includes monitoring system health, responding to incidents and alerts, performing routine maintenance (updates, scaling, backups), and continuously improving reliability and performance. Diana has a background in IT operations and has embraced SRE principles to bring a more proactive, engineering-driven approach to operations. She works closely with the development team to feed back any issues (so they can be fixed at the source) and to automate reliability improvements.

**Challenges:** The Ops/SRE role comes with the challenge of ensuring **everything runs smoothly 24/7**. Specific challenges for Diana are:

- **Incident Detection and Response:** When something goes wrong (e.g., the website goes down, or users experience errors), Diana must quickly detect it (through alerts or monitoring), diagnose the root cause, and fix it or escalate to engineering. Time is of the essence to minimize downtime. SREs like Diana aim to automate this where possible, but unexpected incidents still occur. They have to sift through logs, metrics, and sometimes use trial and error to pinpoint issues.
- **Maintaining Reliability and Performance:** Even when no incidents occur, Diana is constantly checking that the system meets its Service Level Objectives (SLOs) for uptime and response time. If database queries are slowing down or memory usage is climbing, she needs to catch that **before it becomes a user-facing problem**. This involves analyzing a lot of operational data and perhaps running experiments.
- **Optimizing and Updates:** The cloud environment should not be static; over time, improvements are needed – maybe adding an autoscaling rule, updating to a newer VM SKU for better performance, or tuning the database. Identifying what to optimize (and ensuring such changes don’t regress reliability) is a challenge. Cost optimization is also in scope; an SRE might notice idle resources or opportunities to downgrade SKU to save money without impacting performance.
- **Knowledge Sharing and Post-mortems:** After incidents, Diana must write up **root cause analyses (RCAs)** and share patterns and practices to prevent recurrence. This requires clearly understanding what went wrong and what can be improved. It can be difficult to compile all logs and timeline after a firefight.
- **Scaling Operations:** As the system grows, manually monitoring everything is not feasible. Diana’s team needs to implement automation (scripts, runbooks, auto-healing mechanisms). Deciding what to automate and writing that code is yet another task on her plate. For example, setting up an auto-heal rule or a self-correcting script for a known issue.

**How Copilot in Azure Helps:** Copilot in Azure is extremely valuable for Diana’s operations work, as it can quickly analyze and summarize vast amounts of operational data and recommend actions. It has direct integration with Azure Monitor, meaning Diana can ask natural language questions of logs and metrics. For instance, instead of manually writing a Kusto query, she could ask Copilot: *“Show me all error logs from the web app in the last hour”* and Copilot will retrieve that information. This speeds up incident diagnosis. Copilot can also detect anomalies and patterns: using AI, it might highlight that *“The CPU usage on the database jumped to 90% at 2 AM”* or *“There were five timeouts to the external API just before the outage”*. In fact, Copilot has specific capabilities to **run anomaly investigations** on resources and perform root cause analysis by correlating data across sources. So during an incident, Diana can rely on Copilot as a virtual **incident responder** that aggregates clues rapidly. 

Beyond reactive tasks, Copilot helps in proactive optimization. Diana can ask *“Do we have any inefficient or idle resources that can be optimized?”* – Copilot might interface with **Azure Advisor** and cost management data to answer that. For example, it could identify an unattached disk or an underutilized VM and suggest removing or resizing it (similar to how a user found an unattached disk saving costs via Copilot). For reliability, Copilot can suggest best practices: e.g., if auto-heal is not enabled on the App Service and frequent crashes occur, Copilot might advise enabling it. If no backup is configured for the database, Copilot would highlight that as a risk. Essentially, it surfaces **patterns and recommendations** that an SRE might otherwise get from Azure Advisor or personal expertise, but in a convenient, conversational way.

Copilot also aids with documentation and knowledge sharing. After an incident, Diana can ask Copilot to *“summarize the events of the outage and probable root cause”* from the logs, which can serve as a starting point for an RCA report. It can also generate or retrieve instructions to fix certain issues so Diana can add them to the team’s runbooks.

In short, Copilot allows Diana to manage the platform more effectively by **quickly interrogating the environment in natural language** and obtaining insights that normally require complex queries or analysis. It augments her expertise with Azure’s machine learning-driven recommendations and saves time in diagnosing and optimizing the system.

## Demo Script – Ops/SRE Scenario

### Ops/SRE Scenario – Prompt 1

```text
It’s 9am, did any critical alerts trigger overnight on the Contoso Hotels system? Summarize any incidents.
```

#### Rationale & Copilot Outcome

Diana starts her day checking for issues. Copilot can retrieve alerts from Azure Monitor. For example, it might find that an alert for high CPU on the VM was triggered at 3am. Copilot could respond: *“Yes, there were 2 critical alerts in the last 12 hours. At 2:45 AM, a ‘High CPU usage’ alert on the backend VM was triggered (CPU > 85%). At 2:50 AM, an alert for ‘App Service response time’ was triggered (response time exceeded threshold).”* It may then summarize the current status (perhaps the alerts auto-resolved or still ongoing). This uses Copilot’s ability to **list and summarize alerts**. Diana can quickly get the incident context without wading through the Azure Portal UI. 

### Ops/SRE Scenario – Prompt 2

```text
Run a root cause analysis for the high CPU alert on the backend VM around 2:45 AM.
```

#### Rationale & Copilot Outcome

Now that she knows something happened, Diana asks Copilot to investigate. Copilot’s AI might correlate metrics and logs for that VM around 2:45 AM. It could find, for example, a spike in traffic or a specific process. The response might be: *“The VM ‘contoso-backend’ experienced 90% CPU at 2:45 AM due to a surge in incoming requests. IIS logs show a high volume of requests to the `/exportData` endpoint at that time. This likely caused CPU exhaustion. The system recovered at 2:55 AM after the surge ended. No manual intervention was required.”* This is an illustrative answer; Copilot can use Azure Monitor’s **Performance analysis and log search features** to gather such info. The key is showcasing Copilot’s **troubleshooting capability – identifying why a resource misbehaved**. Even if it doesn’t nail the cause perfectly, it will give useful hints (perhaps it would mention garbage collection or memory swap if relevant). This drastically reduces the time Diana spends in diagnosing – Copilot did in seconds what might take an SRE an hour (checking metrics, logs, etc.). Diana can now confirm this with her own knowledge and decide on next steps.

### Ops/SRE Scenario – Prompt 3

```text
What actions can we take to prevent or mitigate this kind of high CPU event on the VM in the future?
```

#### Rationale & Copilot Outcome

Copilot can recommend **reliability improvements**. For a high CPU incident on a VM, it might suggest scaling up the VM size or scaling out (if in a scale set), or offloading some work to another service. It could say: *“Consider enabling auto-scale for the VM (or using VM Scale Sets) so that additional instances come online during high load. Alternatively, optimize the code for the `/exportData` endpoint if it’s CPU-intensive. You could also add an Azure Function to handle those requests on-demand. Monitoring should be set to alert at 70% CPU to catch issues earlier.”* If the VM’s role can be replaced with a PaaS (like if it was doing batch jobs), Copilot might even suggest using Azure Functions or App Service for better scaling. The idea is that Copilot surfaces various **Well-Architected recommendations** relevant to the issue (performance and scalability in this case). It may also mention using Azure Advisor which often points out if a VM is under pressure frequently. This demonstrates that Copilot not only helps put out fires but also guides the **continuous improvement** so fires are less likely.

#### Ops/SRE Scenario – Prompt 4

```text
Enable auto-healing on the Contoso web app and set up a rule to recycle the app if CPU usage stays high for 5 minutes.
```

#### Rationale & Copilot Outcome

Taking a concrete action from recommendations, Diana decides to implement an auto-heal policy on the App Service (since Azure App Service has an Auto-Heal feature for certain conditions). Instead of navigating the portal, she instructs Copilot to do it. Copilot can directly execute or provide the steps to enable auto-heal for the web app. For example, it might confirm: *“Auto-Heal has been enabled on the web app. A rule is created to restart the web app if CPU remains above 80% for 300 seconds.”* In a Copilot integrated environment, it might even just do it (after confirmation). This highlights **Copilot’s action capability** – not only diagnosing but also taking steps to fix/optimize. The audience sees that with a single command, an important reliability feature was configured, which contributes to operational excellence by automatically recovering the app from stress conditions.

### Ops/SRE Scenario – Prompt 5 (Optional)

```text
Are there any security or compliance issues in our Azure environment right now?
```

#### Rationale & Copilot Outcome

This prompt uses Copilot to do a quick security audit. It could check Azure Security Center/Defender findings or Azure Policy compliance. For instance, it might report: *“All resources are compliant with the configured policies. However, Azure Advisor recommends enabling Multi-Factor Authentication for the admin accounts and notes that the Storage account X is not using a private endpoint.”* This is another angle of operations – proactive risk management. If time allows, including it shows the breadth of Copilot (covering security checks as well).

In the Persona 4 demo, we demonstrate Copilot’s power in the **live operations context** – querying logs and alerts, diagnosing a problem, and even implementing a fix, all through conversational interactions. Diana effectively had an AI co-pilot through the on-call process: it summarized what happened, why it happened, and how to prevent it, then even applied a fix (auto-heal). The outcome is that Contoso Hotels’ system is not just running, but is continually improving in reliability with minimal manual effort, thanks in part to Copilot. 