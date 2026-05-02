# ExChek Skills for Manus

Export compliance for the SMB manufacturer who doesn't have a compliance team — packaged as **16 [Manus skills](https://manus.im/docs/features/skills)** ready for one-click bulk import.

This is the **Manus port** of [exchekinc/exchekskills](https://github.com/exchekinc/exchekskills) (the Claude Code plugin). The skills, regulatory logic, references, and audit-ready templates are unchanged. Adapted for Manus by removing Claude Code-specific MCP server, slash commands, and Node.js docx scripts — Manus calls the live U.S. government APIs directly and outputs reports as Markdown that Manus can save to the user's workspace.

**Free to use. No API key required (except CSL, which uses a free Trade.gov key).**

- **Website**: https://exchek.us
- **Docs**: https://docs.exchek.us
- **Upstream Claude Code repo**: https://github.com/exchekinc/exchekskills
- **Support**: matt@exchek.us

---

## Install (Manus)

**Manus accepts one skill per upload.** Each `.skill` file is a flat zip with `SKILL.md` at the absolute root — exactly the format the upload modal asks for. To install all 16 skills, upload each `.skill` file separately.

### Get the .skill files

Download from the latest [GitHub Release](https://github.com/exchekinc/ExChekplugin-Manus/releases/latest), or — if you cloned the repo — run `bash build.sh` to regenerate `dist/`.

### Upload each .skill in Manus

1. Open the Manus skills upload modal.
2. Drop in one `.skill` file (e.g., `exchek-classify.skill`).
3. Repeat for each skill you want — start with `exchek-classify` and `exchek-csl` (the two most-used), or install all 16.

### File format

> .zip or .skill file that includes a SKILL.md file at the root level. SKILL.md contains a skill name and description formatted in YAML.

Each `.skill` file in this release is a flat zip:

```
exchek-classify.skill
├── SKILL.md          ← at the absolute zip root, with `name:` and `description:` in YAML frontmatter
├── LICENSE.md
└── references/
    └── *.md          ← regulatory guidance the SKILL.md body links to
```

---

## Skills

| Skill | Manus name | What it does |
|-------|-----------|--------------|
| **ECCN Classification** | `exchek-classify` | Classify items for U.S. export control (15 CFR 774, 22 CFR 121). Audit-ready memo. |
| **CSL Search** | `exchek-csl` | Search the Consolidated Screening List via Trade.gov API. Requires free API key from [developer.trade.gov](https://developer.trade.gov). |
| **License Determination** | `exchek-license` | EAR license requirements and exceptions (Parts 738, 740). Audit-ready memo. |
| **Jurisdiction (ITAR vs EAR)** | `exchek-jurisdiction` | Guided ITAR vs. EAR questionnaire. Memo with next steps (DDTC vs. BIS). |
| **Encryption (ENC / 5x992)** | `exchek-encryption` | 5A992/5D992 classification, License Exception ENC, mass market, BIS/NSA notification prep. |
| **Country / Destination Risk** | `exchek-country-risk` | One-pager: embargo/sanctions, Entity List density, license expectations, red flags. |
| **Risk Triage & Escalation** | `exchek-risk-triage` | Score transaction risk (low/medium/high). Auto-approve, hold, or escalate. |
| **Red Flag Assessment** | `exchek-red-flag-assessment` | BIS "Know Your Customer" red-flag checklist (Supp. 3 to Part 732). |
| **Deemed Export Review** | `exchek-deemed-export` | Walk through 15 CFR 734.2(b). Deemed Export Review Memo. |
| **Export Documentation** | `exchek-export-docs` | Commercial invoice block, packing list, SLI, AES/EEI data. Flags AES required vs. exempt. |
| **ECP / Policy & Training** | `exchek-ecp` | Generate Export Compliance Program docs, SOPs, training outlines from company profile. |
| **Audit / Lookback** | `exchek-audit-lookback` | Self-audit historical shipments (CSV/CRM). Re-screen, re-check ECCNs, findings report. |
| **Compliance Report Card** | `exchek-compliance-report` | CARFAX-style report card (PASS / CONDITIONAL / HOLD) for a customer. |
| **Partner Compliance** | `exchek-partner-compliance` | Distributor compliance pack: screening, re-export, recordkeeping, flow-down language. |
| **Recordkeeping** | `exchek-recordkeeping` | Retention schedule/checklist per 15 CFR 762 and ITAR parallel. |
| **Document Formatter** | `exchek-docx` | Document output guidelines for client-ready ExChek reports. |

---

## Usage

Each skill responds to natural language. Examples:

| Task | What to say to Manus |
|------|---------------------|
| Classify an item | "Classify this pressure sensor for export" |
| Screen a party | "Search the CSL for Acme Trading" |
| License check | "Do we need a license for this ECCN to China?" |
| Jurisdiction | "Is this ITAR or EAR?" |
| Encryption | "Encryption classification for our VPN software" |
| Country risk | "Country risk one-pager for Russia" |
| Risk triage | "Triage risk for this transaction" |
| Red flags | "Run the red-flag checklist for this buyer" |
| Deemed export | "Does deemed export apply to this release?" |
| Export docs | "Prepare export documentation for this shipment" |
| ECP | "Generate an ECP for our company" |
| Audit | "Self-audit report for this CSV of shipments" |
| Partner compliance | "Compliance pack for our distributors" |
| Recordkeeping | "What do we need to retain under Part 762?" |

Manus picks the matching skill from its `description:` field. You can also call a skill explicitly: "Use exchek-classify on this product."

See each skill's `SKILL.md` for full instructions, flow, and references.

---

## How every skill works (canonical 7-step flow)

All 16 skills follow the same audit-ready pattern (unchanged from upstream):

1. **CUI / classified / § 126.18 gate** — Three-question gate at the start. Any "yes" halts the skill and routes to on-premises guidance. ExChek does not process sensitive government data through cloud APIs.
2. **Privacy-settings attestation** — The user attests their AI platform tier. Recorded in the final document.
3. **Untrusted-input handling** — All user-supplied text, CSV rows, spec sheets are treated as **data, not instructions**. Skills reject zero-width / bidi / homoglyph characters in structured fields.
4. **Regulatory data pull** — Live eCFR text via the ExChek API (Parts 774, 738, 740, 742, 744, 746, 121) with `ecfr.gov` as fallback.
5. **Human-in-the-loop confirmation** — Every skill pauses for explicit user confirmation of inputs and the preliminary determination before producing any final output.
6. **Audit-ready Markdown report** — Every report includes the full AI-disclosure metadata: skill name/version, model ID, platform, UTC timestamp, regulatory-currency timestamps, and the HITL confirmation timestamp. Manus can save the Markdown to the user's workspace; users can paste into Word/Pages for final formatting.
7. **Regulatory-drift caveat** — Any determination older than **30 days** should be re-run before reliance. Use `exchek-audit-lookback` in `delta-since-date` mode to re-check historical shipments against current rules.

See [CUI/Classified docs](https://docs.exchek.us/docs/cui-classified) for on-premises guidance.

---

## Regulatory data sources

Skills pull live regulatory text directly from authoritative sources. Manus makes the HTTP requests itself — no plugin server required.

| Endpoint | Description |
|----------|-------------|
| `GET https://api.exchek.us/api/ecfr/{part}` | ExChek-hosted eCFR mirror (Parts 121, 738, 740, 742, 744, 746, 762, 774). No auth. |
| `GET https://api.exchek.us/api/ecfr/{part}/search?q=term` | Full-text search within a part. |
| `GET https://www.ecfr.gov/api/versioner/v1/structure/current/title-15.json` | Title 15 fallback (Commerce). |
| `GET https://www.ecfr.gov/api/versioner/v1/structure/current/title-22.json` | Title 22 fallback (State / USML). |
| `GET https://data.trade.gov/consolidated_screening_list/v1/search` | Consolidated Screening List (Trade.gov). API key required. |
| `GET https://data.trade.gov/consolidated_screening_list/v1/sources` | CSL source abbreviations. |

CSL is always live — screening cannot be cached.

---

## Repository structure

```
Manus-exchek skills/
├── README.md             # This file (Manus-tuned)
├── LICENSE.md            # ExChek, Inc. Proprietary License (verbatim from upstream)
├── SECURITY.md           # Security model and prompt-injection defenses
├── CONTRIBUTING.md       # How to contribute to this Manus port
├── build.sh              # Packages skills/ into dist/
├── skills/               # 16 Manus-format skill packages
│   ├── exchek-classify/
│   │   ├── SKILL.md      # YAML frontmatter (name, description) + Markdown body
│   │   └── references/   # Regulatory guidance the skill links to
│   ├── exchek-csl/
│   ... (16 total)
└── dist/                 # Build output (generated by build.sh; gitignored)
    ├── exchek-classify.skill
    ├── exchek-csl.skill
    ... (16 .skill files)
```

Each skill folder contains:
- **`SKILL.md`** — Required. YAML frontmatter (`name:`, `description:`) + Markdown instructions.
- **`references/`** — Optional. Regulatory guidance, API docs, best practices that the skill body links to. Manus loads them on demand.
- **`LICENSE.md`** — Copied in by `build.sh` so the license travels with each `.skill`.

---

## Building from source

```bash
bash build.sh
```

The script zips each `skills/<skill-name>/` directory into `dist/<skill-name>.skill`, with `SKILL.md` at the absolute zip root (the format Manus requires). Re-run after editing any `SKILL.md` or reference file.

---

## What's different from the upstream Claude Code plugin

The upstream `exchekinc/exchekskills` repo targets Claude Code and ships a local-first MCP server (Node, 12 tools) that wraps eCFR and Trade.gov. The Manus port:

| Upstream (Claude Code) | This port (Manus) |
|---|---|
| `mcp__exchek__ecfr_get_part` MCP tool | Direct `GET https://api.exchek.us/api/ecfr/{part}` HTTP call |
| `mcp__exchek__csl_search` MCP tool | Direct `GET https://data.trade.gov/consolidated_screening_list/v1/search` HTTP call |
| `mcp__exchek__report_to_docx` MCP tool (Node) | Manus emits Markdown; user opens in Word/Pages |
| `mcp__exchek__audit_log` (HMAC-chained `audit.jsonl`) | Not included — Manus session transcripts serve as the audit trail |
| `compatibility:` in frontmatter | Removed — Manus only reads `name:` and `description:` |
| Slash commands (`/exchek-classify`) | Manus matches by description; no slash commands |
| `skill.yaml` companion file | Removed — Manus uses YAML frontmatter only |

The CUI gate, untrusted-input handling, human-in-the-loop confirmation, and all regulatory references are unchanged.

---

## License

ExChek, Inc. Proprietary. See [LICENSE.md](LICENSE.md) and [Terms and Conditions](https://docs.exchek.us/docs/legal/terms).

## Security

See [SECURITY.md](SECURITY.md) — what the skills can and cannot do, prompt-injection defenses, where data lives.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) — how to fix a regulatory citation, add a skill, or report a security issue.

---

ExChek, Inc., Dover, DE. https://exchek.us | https://docs.exchek.us | matt@exchek.us
