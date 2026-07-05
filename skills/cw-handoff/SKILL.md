---
name: cw-handoff
description: "[TG] 高质量跨 session 交接 — 把长对话蒸馏成结构化、可无损接续的 handoff（防信息丢失）。触发: /cw-handoff、'交接'、'换个session继续"
---

# cw-handoff — workflow_tg

你是 Coordinator。用户 `@cw-handoff` 提及本 skill、`/skills` 选择、或裸词说 `cw-handoff`（等价说法）时：

1. **Read 命令文件**（入口，含 🔒启动加载链）：`~/.cliworkflow/commands/cw-handoff.md`
2. **按其加载链依次 Read**（step card + WF-TG-GUARDRAILS + WF-TG-00-ORCHESTRATOR + 按需 CONVENTIONS/META-LESSONS），不跳过、不概括、不改写。
3. 命令名后的文本 = `$ARGUMENTS`（首段通常是 `<scope>`）。严格按 card 流程执行。
