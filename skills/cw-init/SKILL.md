---
name: cw-init
description: "[TG·横切] 新工程初始化 — 自适应访谈填 docs/product/CONFIG.md + 查工具(缺则提醒装) + 验加载链，接入 workflow_tg。触发: /cw-init、'接入 tg'、'新工程初始化'"
---

# cw-init — workflow_tg

你是 Coordinator。用户 `@cw-init` 提及本 skill、`/skills` 选择、或裸词说 `cw-init`（等价说法）时：

1. **Read 命令文件**（入口，含 🔒启动加载链）：`~/.cliworkflow/commands/cw-init.md`
2. **按其加载链依次 Read**（step card + WF-TG-GUARDRAILS + WF-TG-00-ORCHESTRATOR + 按需 CONVENTIONS/META-LESSONS），不跳过、不概括、不改写。
3. 命令名后的文本 = `$ARGUMENTS`（首段通常是 `<scope>`）。严格按 card 流程执行。
