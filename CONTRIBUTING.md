# Contributing

This is the **Manus port** of [exchekinc/exchekskills](https://github.com/exchekinc/exchekskills). Most regulatory content (Order of Review, license exceptions, Country Chart, CUI gate, etc.) lives upstream — fix it there first, then resync into this repo.

Three kinds of changes belong here:

1. **Regulatory updates** — a part changed, a list moved, an exception was rewritten. Pull the fix from upstream into the matching `skills/<skill-name>/references/` file, then rebuild.
2. **Manus-format adaptations** — the upstream `SKILL.md` references a Claude Code MCP tool or Node script that doesn't exist in Manus. Translate to a direct API call or to "Manus emits Markdown."
3. **New skills** — covering an export-control corner the upstream repo also lacks. Add upstream first if you can; otherwise add here following the same canonical 7-step flow.

## Before opening a PR

1. **Open an issue first** if the change is more than a typo. ExChek skills produce audit-ready compliance memos. Drive-by changes that alter regulatory citations or the canonical AI-disclosure schema can break downstream users' records.
2. **Run the build** — `bash build.sh` from the repo root. Confirm `dist/individual/<your-skill>.skill` and `dist/exchek-all-skills.zip` regenerate without errors.
3. **Verify the zip structure** — `unzip -l dist/individual/<your-skill>.skill` should show `<skill-name>/SKILL.md` at the root level of the skill directory (not at the absolute zip root).
4. **Round-trip the skill in Manus** — upload the `.skill`, ask Manus to invoke it, confirm the CUI gate fires before any other action.

## What we will and won't merge

| Change type | Disposition |
|---|---|
| Regulatory update (eCFR cite changed) | Always welcome. Include the new cite + the date eCFR changed. |
| Bug fix in a `SKILL.md` or reference file | Always welcome. |
| New SMB-friendly skill | Welcome. Must include `SKILL.md` (with `name:` + `description:` YAML frontmatter), `references/` for any regulatory guidance, and follow the canonical 7-step flow (CUI gate → privacy attestation → untrusted-input handling → regulatory data pull → HITL → Markdown report → drift caveat). |
| Voice change toward SMB manufacturer audience | Welcome. The target reader doesn't have a compliance team. |
| Voice change toward jargon-heavy compliance-officer audience | Decline by default. Wrong audience. |
| New paid integration | Decline. ExChek is free. The only paid dependency we'd consider is one the user already has (e.g., their own CRM). |
| Re-introducing Claude Code MCP tool calls into Manus skills | Decline. They don't exist in Manus. Use direct HTTP calls. |
| Re-introducing `compatibility:` to frontmatter | Decline. Manus reads only `name:` and `description:`; extra fields just bloat the index. |

## SKILL.md format reminder (Manus)

```yaml
---
name: exchek-<slug>
description: <one sentence: what the skill does AND when to invoke it>
---

# <Skill Title>

<body>
```

- `name:` and `description:` are the **only** frontmatter fields Manus reads. Make the description specific — it's the trigger.
- The body should be under ~500 lines. Push deep regulatory text into `references/` and link to it.
- Imperative voice ("Apply Order of Review per Supplement No. 4…"), not descriptive ("This skill applies Order of Review…").

## File names

- Skill folder: `kebab-case` matching the `name:` field exactly (e.g., folder `exchek-classify/` ↔ `name: exchek-classify`).
- Reference files: `kebab-case.md`.
- Top-level docs: `SCREAMING-SNAKE.md`.

## License

By contributing, you agree your contribution is licensed under the same terms as the rest of the repo (see `LICENSE.md`). The Manus port is governed by the same ExChek, Inc. Proprietary License as the upstream Claude Code plugin.

## Reporting security issues

Email `matt@exchek.us`. Do not file a public issue. See `SECURITY.md`.
