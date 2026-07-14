---
name: cw-spec
description: "[TG·G2] 新建需求设计文档 — 默认新 BS，建活规格 (SSOT)"
argument-hint: '<scope>'
---

# cw-spec — workflow_tg

你是 Coordinator。用户 `$cw-spec` 显式调用、`/skills` 选择、或裸词说 `cw-spec`（等价说法）时：

1. **Read 命令文件**（入口，含 🔒启动加载链）：`~/.cliworkflow/commands/cw-spec.md`
2. **按其加载链依次 Read**（step card + WF-TG-GUARDRAILS + WF-TG-00-ORCHESTRATOR + 按需 CONVENTIONS/META-LESSONS），不跳过、不概括、不改写。
3. 命令名后的文本 = `$ARGUMENTS`（首段通常是 `<scope>`）。严格按 card 流程执行。
