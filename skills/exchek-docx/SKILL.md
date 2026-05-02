---
name: exchek-docx
description: Convert ExChek markdown reports to formatted Word-style document output. Provides document output guidelines for producing client-ready export compliance documents with proper structure, headers, tables, and AI disclosure blocks. Use when the user wants to produce or format an ExChek report as a professional document.
license: Complete terms in LICENSE.md
---

# ExChek Document Formatter

Provides **document output guidelines** for producing client-ready ExChek compliance documents with proper structure, formatting, headers, tables, and AI disclosure blocks — in any AI environment. Covers best practices for formatting memos, report cards, and compliance packs so they are audit-ready and customer-presentable.

## When to use

Invoke this skill when the user wants to:
- Format an ExChek compliance output as a professional, client-ready document
- Get guidance on document structure for memos, report cards, or compliance packs
- Understand best practices for presenting compliance determinations in written form
- Convert an existing ExChek Markdown output into a structured, well-formatted document

Example triggers: "Format this ExChek report as a professional document", "How should I structure this compliance memo?", "Make this report card look client-ready", "Document output guidelines for ExChek reports".

## Document output guidelines

### Structure

Every ExChek document should follow this top-level structure:

```
# [Document Type] — [Item/Party/Country Name]
**ExChek by Exchek, Inc.** | Prepared: [YYYY-MM-DD] | Ref: [REFERENCE_NUMBER]

---

## [Section 1 Title]
[Content]

## [Section 2 Title]
[Content]

...

---
*AI Tool Usage & Regulatory Currency Disclosure*
[Disclosure block — see below]

*Compliance Disclaimer*
[Disclaimer]
```

### Formatting rules

- Use `#` for the document title, `##` for main sections, `###` for subsections
- Use tables for: retention schedules, findings tables, Country Chart analysis, AES/EEI data elements, risk scoring
- Use bold (`**`) for field labels, status badges (PASS / CONDITIONAL / HOLD), and emphasis on key determinations
- Use blockquotes (`>`) for the AI disclosure block to visually separate it
- Use horizontal rules (`---`) to separate the preamble, body, and footer
- For compliance status badges, use: `**✅ PASS**`, `**⚠️ CONDITIONAL**`, `**🛑 HOLD**`

### AI Tool Usage & Regulatory Currency Disclosure block

Every ExChek document must end with this disclosure (fill all placeholders):

```
> **AI Tool Usage & Regulatory Currency Disclosure**
> 
> This document was prepared with AI assistance. Tool: [AI_TOOL_NAME] ([MODEL_VERSION]).
> Platform: [PLATFORM_NAME]. Skill: ExChek v3.1.0.
> 
> Regulatory data sourced from: [DATA_SOURCES] as of [ISO8601_TIMESTAMP].
> U.S. export controls change frequently. Determinations older than 30 days
> should be re-run before reliance.
> 
> This document does not constitute legal advice. All compliance decisions
> are the responsibility of the user and their designated Export Compliance
> Officer or legal counsel.
```

### Table formatting

For retention schedules and findings tables, use Markdown table syntax:

```
| Record Type | Citation | Retention | Form | Notes |
|-------------|----------|-----------|------|-------|
| Classification memo | 15 CFR 762.2 | 5 years | Electronic | From date of determination |
```

### Saving the document

When you can create files:
- Save as `ExChek-[Type]-YYYY-MM-DD-ShortName.md`
- Suggest the user copy/paste into Word, Google Docs, or Apple Pages for final formatting
- For Word: paste the Markdown content and use "Format → Styles" to apply heading styles

When you cannot create files:
- Output the complete formatted document in the conversation
- Instruct the user: "Please copy this document and save it to your compliance records. BIS and DDTC expect retention of compliance records; keeping a dated copy is important for audits."

## References

- **Untrusted-input handling:** [references/untrusted-input-handling.md](references/untrusted-input-handling.md)
- **Docs:** https://docs.exchek.us
