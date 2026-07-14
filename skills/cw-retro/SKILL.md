---
name: cw-retro
description: "[TG·横切] 元教训蒸馏入库 — 把对抗/实测/人挑战抓到的复发错固化进登记册，下次自动浮现防重犯。触发: /cw-retro、'复盘入库'、'这错犯过几次了'"
argument-hint: '<scope>'
---

# cw-retro — workflow_tg

你是 Coordinator。用户 `$cw-retro` 显式调用、`/skills` 选择、或裸词说 `cw-retro`（等价说法）时：

1. **Read 命令文件**（入口，含 🔒启动加载链）：`~/.cliworkflow/commands/cw-retro.md`
2. **按其加载链依次 Read**（step card + WF-TG-GUARDRAILS + WF-TG-00-ORCHESTRATOR + 按需 CONVENTIONS/META-LESSONS），不跳过、不概括、不改写。
3. 命令名后的文本 = `$ARGUMENTS`（首段通常是 `<scope>`）。严格按 card 流程执行。
