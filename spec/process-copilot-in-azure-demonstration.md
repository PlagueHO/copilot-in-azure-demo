---
title: "Copilot in Azure Demonstration"
version: "1.0"
date_created: "2025-06-11"
last_updated: "2025-06-11"
owner: "Contoso Cloud Demo Team"
tags: ["process", "demo", "azure", "copilot"]
---

# Introduction

This specification defines the requirements, constraints, interfaces, and validation criteria for the Copilot in Azure demonstration. It guides the creation of scripted scenarios, environment configuration, and personas to ensure a coherent, secure, and repeatable demonstration of Microsoft Copilot capabilities in Azure.

## 1. Purpose & Scope

This specification outlines the scripted demonstration steps and prompts for showcasing Copilot in Azure to the Contoso Hotels audience. It covers:

- The narrative flow and defined personas for each segment of the demo.
- The structured Copilot prompts tailored to each persona’s goals and challenges.
- The expected Copilot responses and validation criteria to ensure consistency.

Intended audience: Pre-sales architects, solution architects, engineers, DevOps practitioners, and SRE/Ops teams familiar with Azure fundamentals.

## 2. Definitions

<!-- Definitions of core terms used in the demonstration script -->
- **CiA**: Copilot in Azure – AI assistant integrated into Azure experiences.
- **Contoso Hotels**: Fictional customer context used throughout the demo.
- **Persona**: The target role interacting with Copilot (Pre-sales Architect, Designer, Engineer, SRE).
- **Prompt**: A user input submitted to Copilot guiding the AI response.
- **Validation**: Criteria used to assess the Copilot output during the demo.

## 3. Requirements, Constraints & Guidelines

- **REQ-001**: Demonstration prompts shall follow Microsoft Copilot best practices and challenge AI capabilities.
- **REQ-002**: Each persona must have at least three distinct prompts highlighting their scenario.
- **CON-001**: Prompts must be self-contained, using only Contoso Hotels context; no external dependencies.
- **TIM-001**: Each persona segment (prompts plus interaction) shall complete within 5 minutes.
- **GUD-001**: Prompts should incorporate Azure Well-Architected Framework pillars where relevant.
- **VAL-001**: Validation criteria must be defined per prompt to verify Copilot’s response accuracy.

<!-- Continuation of Rationale & Context and subsequent sections -->

## 4. Rationale & Context

Contoso Hotels seeks a rapid, engaging demonstration of Copilot in Azure to showcase design, deployment, and operational scenarios. The requirements prioritize security (no secrets), operational visibility, and cost control, ensuring a realistic but controlled demo.

## 5. Validation Criteria (Demo Script)

- Each persona’s prompts produce coherent, contextually appropriate Copilot responses.
- Copilot outputs align with expected guidance for architecture, design, engineering, and operations scenarios.
- Prompt-response cycles per persona complete in under 5 minutes.
- Audience can successfully follow demo steps and achieve insights without additional clarification.

## 6. Related Specifications / Further Reading

- [INSTRUCTIONS.md](../INSTRUCTIONS.md)
- [Azure Copilot example prompts](https://learn.microsoft.com/azure/copilot/example-prompts)
- [Azure Well-Architected Framework](https://docs.microsoft.com/azure/architecture/framework/)
