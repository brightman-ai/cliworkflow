---
description: "[TG] 轻量富化 — human-style 模糊需求→清晰可验诉求 (≤3问)"
---

# /cw-clarify — 轻量富化（表达模糊）

**角色**: Coordinator。**环节**: 把人话模糊需求富化为清晰可验诉求；新 portal 出给 /cw-spec，已有出给 /cw-change。
用户输入（`<scope> "<人话>"`）: `$ARGUMENTS`

## 🔒 启动加载链（按顺序 Read，不可跳过）
| # | 文件 | 目的 |
|---|------|------|
| 1 | `~/.cliworkflow/workflow_tg/cards/TG-CLARIFY.md` | 本环节 step card |
| 2 | `~/.cliworkflow/workflow_tg/WF-TG-GUARDRAILS.md` | 三事实/护栏 |
| 3 | `{项目}/docs/product/CONFIG.md` → 再读 `<持久化根>/<scope>/spec.md`（如存在）| 经 CONFIG 解析持久化根；已有意图判新建 vs 变更 |
| 4 | `~/.cliworkflow/workflow_tg/WF-TG-CONVENTIONS.md` | run-dir 格式（诉求 request.md 落 `<run_root>/<thread-id>/`）|

## 执行
按 step card：**先抓真意图、别顺字面跑偏**（核心意图读不准=最高优先级的那 ≤3 问之一；症状/回归类输入先钉"持续vs瞬时/同一实例？/决定性观察"再归因）→自动填→仅高杠杆留白提 **≤3 问**→产出含 **7 要素**(意图/范围锚定/显式非目标/验收清单每条标判定方式/视觉对标/隐含意图/验证可达性)的清晰诉求→路由 spec(新)/change(旧)/**快修分支**(G0 小修：开工声明直落 + runtime 证据 + delta 一行回写，见卡)。UX 类必出"逐项视觉对标"。
