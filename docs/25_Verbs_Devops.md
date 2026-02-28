<!--
meta:
  title: "The 25 Verbs of DevOps - Comprehensive Skills Assessment Framework"
  description: "The 25 Verbs of DevOps framework provides a comprehensive skills assessment methodology for technology teams. Learn the four pillars: Strategy, Provisioning, Operations, and Support with competency levels and upskilling roadmap."
  keywords: "DevOps skills assessment, DevOps competency framework, 25 Verbs DevOps, technology adoption checklist, DevOps training roadmap, platform engineering skills, MLOps skills, Kubernetes operations"
  author: "Drew (based on Michael Forrester's webinar)"
  date: "2025-01"
  type: "technical-framework"
  canonical: "https://awdemos.github.io/demos/docs/25_Verbs_Devops.html"

og:
  title: "The 25 Verbs of DevOps - Comprehensive Skills Assessment Framework"
  description: "A universal framework for DevOps skills assessment. 25 action verbs across Strategy, Provisioning, Operations, and Support pillars with competency levels and upskilling roadmap."
  type: "article"
  url: "https://awdemos.github.io/demos/docs/25_Verbs_Devops.html"
  image: "https://awdemos.github.io/demos/docs/og-25-verbs.png"

twitter:
  card: "summary_large_image"
  title: "The 25 Verbs of DevOps - Comprehensive Skills Assessment Framework"
  description: "Universal framework for DevOps skills assessment across Strategy, Provisioning, Operations, and Support."
  image: "https://awdemos.github.io/demos/docs/og-25-verbs.png"
-->

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "TechArticle",
  "name": "The 25 Verbs of DevOps: A Comprehensive Skills Framework",
  "description": "The 25 Verbs of DevOps framework provides a comprehensive skills assessment methodology for technology teams, grouping core actions into four pillars: Strategy, Provisioning, Operations, and Support. Includes 5-level competency model and upskilling roadmap.",
  "author": {
    "@type": "Person",
    "name": "Drew",
    "knowsAbout": ["DevOps", "Platform Engineering", "Kubernetes", "MLOps", "Skills Assessment", "Technology Adoption", "Infrastructure as Code"]
  },
  "datePublished": "2025-01",
  "about": [
    {"@type": "Thing", "name": "DevOps"},
    {"@type": "Thing", "name": "Platform Engineering"},
    {"@type": "Thing", "name": "Kubernetes Operations"},
    {"@type": "Thing", "name": "MLOps"},
    {"@type": "Thing", "name": "Skills Assessment Framework"}
  ],
  "keywords": "DevOps skills assessment, DevOps competency framework, 25 Verbs DevOps, technology adoption checklist, DevOps training roadmap"
}
</script>

---

## Table of Contents

1. [Why 25 Verbs Matter](#-why-25-verbs-matter)
2. [The Four Pillars and 25 Verbs](#-the-four-pillars-and-25-verbs)
3. [The 25 Verbs Table](#-the-25-verbs-table)
4. [Applying 25 Verbs: Example with Kubernetes](#-applying-25-verbs-example-with-kubernetes)
5. [The 5-Level DevOps Competency Model](#-the-5-level-devops-competency-model)
6. [Skills Assessment and Upskilling Roadmap](#-skills-assessment-and-upskilling-roadmap)
7. [Best Practices and Industry Guidance](#-best-practices-and-industry-guidance)
8. [Summary](#-summary)

---


# The 25 Verbs of DevOps: A Comprehensive Skills Framework

This briefing distills the webinar by Michael Forrester, "Mind the Gap: DevOps Skills Assessment Made Simple," integrating the **complete set of 25 DevOps action verbs** you need to know in order to successfully deploy a technology for a commercial application. This framework is designed for technical leaders, DevOps engineers, and platform teams to systematically identify, benchmark, and close skills gaps for any technology adoption-from Kubernetes to IaC, ML Ops, and beyond.

---

## 🚦 Why the 25 Verbs Matter

The pace of technological change (cloud, Kubernetes, platform engineering, AI/ML) has outstripped most teams’ ability to keep up. The 25 verbs represent the **core, repeatable actions** required to successfully launch, operate, and support any technology in production. They serve as a universal checklist for skills assessment, upskilling, and team maturity mapping.

> Console based workflows ("clickops") don't scale with increasing complexity. You could hire a hundred Starcraft esports professionals or you can use infrastructure as code. One of these options is better and cheaper than the other!

---

## 🏗️ The Four Pillars and the 25 Verbs

The verbs are grouped into four pillars, each representing a phase of the technology lifecycle. Mastery across all verbs ensures robust, production-ready DevOps capability.

### **1. Strategy (6 Verbs)**
- **Justify**: Build the business case for using a particular technology and articulate value.
- **Design**: Architect solutions, both high-level and tactical for implementing it.
- **Cost**: Estimate, track, and optimize costs (TCO, ROI) before deploying so that you know you can afford to operate the underlying infrastructure.
- **Productize**: Package as a service/platform for internal/external users. Developers, administrators, and users need access to the same platform to know how it works.
- **Implement**: Plan and execute the rollout in small and manageable milestones.
- **Enroll**: Drive adoption of the technology through training, enablement, and change management.

### **2. Provisioning (8 Verbs)**
- **Build**: Automate builds (CI, pipelines, image creation).
- **Configure**: Apply configuration management (Terragrunt, Spacelift, Pulumi).
- **Deploy**: Automate deployments (Helm, Kustomize, GitOps).
- **Discover**: Enable service discovery and registration.
- **Distribute**: Handle replication, federation, and multi-region rollout.
- **Network**: Design and implement networking (CNI, service mesh, DNS).
- **Secure**: Implement access control, secrets, and compliance before deployment to production.
- **Store**: Manage persistent and ephemeral storage.

### **3. Operations (6 Verbs)**
- **Govern**: Develop accountability, policy, compliance, and guardrails.
- **Audit**: Track changes, access, and security events.
- **Document**: Maintain runbooks, code comments, and operational docs.
- **License**: Ensure legal compliance (open source, enterprise).
- **Maintain**: Patch, upgrade, and fix systems.
- **Perform**: Monitor and optimize for performance, scale, and SLOs.

### **4. Support (5 Verbs)**
- **Support**: Create support workflows (on-call, escalation, incident response).
- **Recover**: Plan for disaster recovery, HA, and backup/restore.
- **Monitor**: Implement observability (metrics, dashboards) not just monitoring.
- **Log**: Centralize and analyze logs.
- **Trace**: Enable distributed tracing and root cause analysis.

---

## 📋 The 25 Verbs Table

```markdown
| Pillar         | Verbs                                                                                       |
| -------------- | ------------------------------------------------------------------------------------------- |
| Strategy       | Justify, Design, Cost, Productize, Implement, Enroll                                        |
| Provisioning   | Store, Network, Build, Configure, Secure, Discover, Deploy, Distribute                      |
| Operations     | Govern, Audit, Document, License, Maintain, Perform                                         |
| Support        | Support, Recover, Monitor, Log, Trace                                                       |
```

---

## 🛠️ Applying the 25 Verbs: Example with Kubernetes

- **Strategy**: Can you justify Kubernetes for your org? Have you designed the cluster architecture? Do you know the costs (cloud, on-prem)? How will you productize it as a platform? Who will implement the rollout? How will you enroll and train users?
- **Provisioning**: Do you know how to configure persistent volumes? Set up CNI plugins and service meshes? Automate builds and configs? Secure with RBAC and secrets? Enable service discovery? Deploy with Helm/GitOps? Distribute across regions?
- **Operations**: Are there policies and guardrails (OPA, Kyverno)? Is auditing in place? Is documentation current? Are you compliant with licenses? Can you patch and upgrade clusters? Are you monitoring performance and scaling?
- **Support**: Is there an on-call and escalation process? Is DR tested? Are Prometheus/Grafana dashboards in place? Are logs centralized (EFK/Loki)? Is tracing (Jaeger, OpenTelemetry) enabled?

---

## 📈 The 5-Level DevOps Competency Model

Each verb is assessed on a 1–5 maturity scale:

1. **Manual/Undocumented**: Ad hoc, clickops, inconsistent quality. FIguring it out as you go.
2. **Manual/Tribal**: Some consistency, but not documented, only in the heads of senior engineers.
3. **Process-Driven**: Documented, partial automation.
4. **Automated/Versioned**: Automated, version-controlled, industry best practice.
5. **Self-Healing/AI-Driven**: Fully automated, GitOps/AI, minimal manual intervention.

> **Goal:** Most teams should target at least Level 4. Level 5 is increasingly achievable with automation and AI.  
> Engineers should never manually intervene in broken systems but fix issues in pipelines that restore a desired (working) system state.

---

## 🧭 Skills Assessment and Upskilling Roadmap

- **Assessment**: You can use the 25 verbs to benchmark your (or your team’s) skills per technology.
- **Gap Analysis**: Visualize strengths/weaknesses (e.g., radar chart).
- **Roadmap**: Prioritize verbs/pillars with lowest maturity. Suggested sequence:
  - Weeks 1–8: Strategy + Provisioning (especially storage, networking, configuration)
  - Weeks 9–12: Operations (maintenance, performance)
  - Weeks 13–16: Remaining operations (governance, documentation, licensing)
  - Weeks 17–24: Support (observability, recovery, escalation)
- **Continuous Improvement**: Reassess regularly, especially after major tech or org changes.

---

## 🏆 Best Practices and Industry Guidance

- **AI in DevOps**: AI is a force multiplier (Copilot, Cursor, LLM troubleshooting), but critical thinking remains essential.
- **Open Source First**: Where possible, favor open-source tooling for observability, automation, and platform engineering.
- **Hands-On Learning**: Prioritize scenario-based, hands-on labs for each verb. Implement learnings immediately.
- **Ecosystem Awareness**: The 25 verbs apply to every technology use case, use them to map not just skills, but also required adjacent tools (e.g., for Kubernetes: Helm, Istio, Backstage, Kyverno, etc.).
- **Adaptability**: The landscape is evolving (AI, platform engineering, ML Ops)-continuous learning is non-negotiable. What was typical in 2020 is behind the curve in 2025.

---

> **"These verbs and skills are extremely useful and can be a framework for methodically thinking about all the things that you need to checklist from a skills perspective before you launch a technology into production."**  
> - Michael Forester

---

## 📝 Summary

The 25 verbs of DevOps provide a **universal, actionable framework** for assessing and closing skills gaps at the individual, team, or organizational level. Use them to drive upskilling, technology adoption, and production readiness-no matter what stack or ecosystem you’re working with. Regularly assess, automate, and iterate for continuous improvement and resilience in the face of rapid change.

---

_Want a printable checklist or a template for team assessment? Drop an issue or PR!_


---

**Last Updated:** January 2025
**Based On:** "Mind the Gap: DevOps Skills Assessment Made Simple" webinar by Michael Forrester

[← Back to Main Documentation](index.md) | [See Related AI Infrastructure Work](index.md) | [Explore DevOps Demos](#)