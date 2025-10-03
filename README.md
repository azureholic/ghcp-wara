# ghcp-wara (Well-Architected Resiliency Assessment Helper)

This repository provides a PowerShell export utility plus an AI-assisted assessment workflow to generate a Well-Architected Resiliency Assessment (WARA) report from offline Azure resource JSON definitions.

The workflow:
1. Export your Azure subscription's resource groups & resources to structured JSON with `Export-AzureResources.ps1` (uses your *current Azure CLI context* by default).
2. In GitHub Copilot Chat switch to **Agent Mode** (GHCP agent) and invoke the `/wara` command to analyze the exported JSON and automatically produce a multi‑pillar Well-Architected report (Cost, Reliability, Security, Operational Excellence, Performance Efficiency).

---
## Contents
- `Export-AzureResources.ps1` – Exports all resource group and resource definitions for the active subscription (or a specified subscription) via Azure CLI.
- `resources/` – Output folder (created automatically) containing per‑subscription subfolders named `<Subscription Name> (<Subscription Id>)` with nested resource group folders and JSON resource definition files.
- `templates/commands/wara.md` – Instruction template describing how the `/wara` command processes the exported JSON and what to include in the assessment.
- `WARA-<subscription>-<date>-vX.md` – Generated assessment reports.

---
## Prerequisites
| Requirement | Notes |
|-------------|-------|
| Azure CLI | https://learn.microsoft.com/cli/azure – Keep reasonably current for best API coverage. |
| PowerShell | Windows PowerShell 5.1+ or PowerShell 7+ (recommended). |
| Azure Access | At least Reader on the target subscription (additional permissions needed only if you later enable diagnostics, policies, etc.). |
| VS Code + GitHub Copilot Chat | For invoking the `/wara` command to generate the assessment. |

Optional (recommended):
- Role assignments / policy definitions exported separately if you want governance analysis depth (not currently exported by the script).

---
## Export Script Overview (`Export-AzureResources.ps1`)
The script:
- Validates Azure CLI availability & version (offers upgrade prompt if an update is detected).
- Uses your current Azure CLI context: obtains the active account via `az account show` unless you explicitly pass `-SubscriptionId` (in which case it sets it with `az account set`).
- Enumerates all resource groups, saves each resource group definition, then enumerates resources in each group and saves individual JSON artifacts.
- Handles resource provider / API version issues by pattern‑matching common error messages and logging structured JSON lines to `resource-provider-issues.log` inside the subscription output folder.
- Logs other export failures separately in the same log file with different `IssueType` values.

### Output Structure Example
```
resources/
  Contoso Production (00000000-0000-0000-0000-000000000000)/
    resource-provider-issues.log
    rg-network/
      rg-network.json
      vnet-hub.json
      firewall-fw01.json
    rg-app/
      rg-app.json
      appservice-plan-web.json
      webapp-frontend.json
```

### Key Features
- Safe filename sanitization for Windows.
- Colored progress output.
- Segregated error logging with machine‑parseable JSON per line for later tooling or diffing.

---
## Running the Export
Login & select the subscription (if not already set):

```powershell
# Login (device / browser flow)
az login

# (Optional) Target a specific subscription
az account set --subscription "<SUBSCRIPTION_ID_OR_NAME>"

# Run export (uses active subscription context)
./Export-AzureResources.ps1

# (Optional) Explicit subscription (sets Azure CLI context first)
./Export-AzureResources.ps1 -SubscriptionId 00000000-0000-0000-0000-000000000000
```

Notes:
- If you specify `-SubscriptionId`, the script calls `az account set --subscription <value>` ensuring the Azure CLI context is switched *before* enumeration.
- Without `-SubscriptionId`, whatever `az account show` returns becomes the source of truth; no additional context switching occurs.
- Rerunning the script overwrites individual JSON files (idempotent for content) and appends new issue lines to the log.

---
## Error & Issue Logging
A file named `resource-provider-issues.log` is created per subscription export. It begins with a comment header, then each line after the header is a compact JSON object.

Common `IssueType` values:
- `ResourceProviderApiVersion` – API version or provider registration issues.
- `ResourceExportFailure` / `ResourceExportException` – Failures retrieving a specific resource.
- `ResourceGroupExportFailure` / `ResourceGroupExportException` – Failures on resource group definition retrieval.
- `ResourceListingFailure` – Listing resources inside a resource group failed.

You can post‑process this file, for example:
```powershell
Get-Content resources/*/resource-provider-issues.log | Where-Object { $_ -like '{*}' } | ConvertFrom-Json | Group-Object IssueType
```

---
## Generating a WARA Report with `/wara`
After export:
1. Open VS Code with GitHub Copilot Chat enabled in this repository.
2. Switch Copilot Chat to **Agent Mode** (GHCP agent panel) so the agent can autonomously read the exported JSON files.
3. In the chat input, type `/wara` and send.
4. The agent reads the JSON artifacts under `resources/<subscription name (id)>/`.
5. It produces a Markdown file in the repo root: `WARA-<subscription>-<yyyy-mm-dd>-v1.md` containing:
   - Network architecture overview (VNet, subnets, NSGs where present)
   - Pillar recommendations: Cost, Reliability, Security, Operational Excellence, Performance Efficiency
   - Risk summary, 30‑day plan, longer‑term roadmap, assumptions & data gaps

### Multiple Subscriptions
If you export multiple subscriptions (multiple sibling folders under `resources/`):
- Current behavior: The `/wara` command processes a single subscription directory (the example just analyzed the one present). If multiple exist, you may need to clarify which one to assess (future enhancement: automatic prompt & merge capability).
- Workaround: Temporarily rename or move unneeded subscription folders before invoking `/wara` if selection is ambiguous.

### Regenerating / Versioning
- Re-run `/wara` to generate a new report (increment the version suffix manually if you wish, e.g., `-v2.md`).
- Consider committing both the raw exports and the generated WARA report for traceability.

---
## Ensuring the Script Uses Current Azure CLI Context
The script inherently trusts and uses the Azure CLI login session:
- Auth status is verified via `az account show`.
- If you don't pass `-SubscriptionId`, whatever `az account show` returns (name + id) is used to build the export folder.
- If you do pass `-SubscriptionId`, the script explicitly sets the CLI context (`az account set`) and then proceeds—so the rest of the calls inherit that context.
No embedded credentials, service principals, or custom tokens are stored—everything relies on your existing Azure CLI auth session.

Validation tip:
```powershell
az account show --output table
./Export-AzureResources.ps1
# Confirm export landed under resources/<ActiveSubscriptionName (ActiveSubscriptionId)>
```

---
## FAQ
**Q: Does the script modify any Azure resources?**  
A: No. All operations are read-only (`az group show`, `az resource show`, `az resource list`).

**Q: Can I limit export to a specific resource group?**  
A: Not currently; you can fork and add a `-ResourceGroup` filter to the `az resource list` and resource group loop if desired.

**Q: Are secrets exposed?**  
A: Resource definitions may include some configuration details; avoid committing sensitive values if any appear. Mask or filter before sharing externally.

---
## Quick Start TL;DR
```powershell
az login
az account set --subscription "<SUBSCRIPTION_ID>"   # optional if already active
./Export-AzureResources.ps1                         # exports JSON into resources/<Subscription Name (Id)>
# In VS Code Copilot Chat (Agent Mode):
/wara                                                # generates WARA-<subscription>-<date>-v1.md
```

Happy assessing! 
