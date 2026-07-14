---
name: cw-grill-me
description: "[TG] 逐问逼问，压紧一个计划/决策 — 一次一问、每问给推荐答案，走完决策树分支才算数；只显式调用，不隐式触发。触发: /cw-grill-me、'grill me'、'烤一下这个方案'、'压一压这个决策'"
---

# cw-grill-me — workflow_tg

你是 Coordinator。用户 `$cw-grill-me` 显式调用、`/skills` 选择、或裸词说 `cw-grill-me`（等价说法）时：

1. **Read 命令文件**（入口，含 🔒启动加载链）：`~/.cliworkflow/commands/cw-grill-me.md`
2. **按其加载链依次 Read**（step card + WF-TG-GUARDRAILS + WF-TG-00-ORCHESTRATOR + 按需 CONVENTIONS/META-LESSONS），不跳过、不概括、不改写。
3. 命令名后的文本 = `$ARGUMENTS`（首段通常是 `<scope>`）。严格按 card 流程执行。
