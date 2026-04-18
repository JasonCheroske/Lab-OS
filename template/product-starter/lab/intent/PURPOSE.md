---
created: 2026-04-17
updated: 2026-04-17
---

﻿# Purpose

This lab is an **operations-research artifact**: it pairs a **Lab OS knowledge layer** (`lab/`, `lab.yaml`) with a **Terraform code layer** (`modules/`, `environments/`, `.github/`). The goal is teachable, copy-paste-friendly patterns for modular AWS IaC, CI/CD, drift awareness, and zero-cost local study via LocalStack.

**Who it is for**

- Engineers learning enterprise Terraform layout
- SREs and platform teams standardizing modules and environments
- AI agents that need explicit WHY/WHAT/HOW context bound to real paths

**Two-layer principle:** Every structural choice in Terraform should have a traceable explanation under `lab/` (intent, reality, delta, behavior, or evidence).
