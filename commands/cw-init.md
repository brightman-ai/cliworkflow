---
description: "[TG·横切] 新工程初始化 — 自适应访谈填 docs/product/CONFIG.md + 查工具(缺则提醒装) + 验加载链，接入 workflow_tg。触发: /cw-init、'接入 tg'、'新工程初始化'"
---

# /cw-init — 新工程初始化（接入 workflow_tg）

**角色**: Coordinator。**环节**: 一次性把新工程接入 tg：探测 repo → 自适应访谈填 CONFIG → preflight 查工具 → 验加载链。
用户输入（`[<工程路径>]`，默认当前工程）: `$ARGUMENTS`

## 🔒 启动加载链（按顺序 Read，不可跳过）
| # | 文件 | 目的 |
|---|------|------|
| 1 | `~/.cliworkflow/workflow_tg/cards/TG-INIT.md` | 本环节 step card |
| 2 | `~/.cliworkflow/workflow_tg/experience/CONFIG-TEMPLATE.md` | 要填的 CONFIG 模板 |
| 3 | `~/.cliworkflow/workflow_tg/WF-TG-GUARDRAILS.md` | 三事实/护栏 |

## 执行
按 step card：**探测 repo**（build/server/UX 工具在 PATH/既有持久化体系，能查先查）→ **自适应访谈**（一次一问、带探测推出的推荐默认）填 `CONFIG-TEMPLATE` 7 段（研究/实验型 +`empirical_measurement` 段）→ **preflight** `command -v <tool>` 缺则**提醒装不自动装** → 写/更新 `{工程}/docs/product/CONFIG.md`（**幂等**：已存在则读+补缺字段、禁盲覆盖；多模块软链共享一份、不另起第二份）→ **验加载链**（ENGINE+GUARDRAILS+CONFIG 可达、变量无歧义）。产出填好 CONFIG + 下一步指针。持久化根新工程默认 `docs/product/` 基目录、有既有体系则映射禁双写。
