---
name: cw-caveman
description: "[TG] 极简表达模式 — 砍废话省 token，技术实质/证据/警告全保留。触发: /cw-caveman、'caveman'、'省点token'、'简洁点'"
---

# cw-caveman — workflow_tg

你是 Coordinator。用户 `@cw-caveman` 提及本 skill、`/skills` 选择、或裸词说 `cw-caveman`（等价说法）时：

1. **Read 命令文件**（入口，含 🔒启动加载链）：`~/.cliworkflow/commands/cw-caveman.md`
2. **按其加载链依次 Read**（step card + WF-TG-GUARDRAILS + WF-TG-00-ORCHESTRATOR + 按需 CONVENTIONS/META-LESSONS），不跳过、不概括、不改写。
3. 命令名后的文本 = `$ARGUMENTS`（首段通常是 `<scope>`）。严格按 card 流程执行。
