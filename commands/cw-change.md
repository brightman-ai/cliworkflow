---
description: "[TG·G1] 变更已有需求 — 清晰时写 delta，验收后合并回干净规格"
---

# /cw-change — 变更已有需求（清晰时）

**角色**: Coordinator。**环节**: 对已有活规格写一条清晰 delta。诉求模糊先 /cw-clarify。
用户输入（`<scope> "<诉求>"`）: `$ARGUMENTS`

## 🔒 启动加载链（按顺序 Read，不可跳过）
| # | 文件 | 目的 |
|---|------|------|
| 1 | `~/.cliworkflow/workflow_tg/cards/TG-CHANGE.md` | 本环节 step card |
| 2 | `~/.cliworkflow/workflow_tg/WF-TG-GUARDRAILS.md` | 三事实/对账/护栏 |
| 3 | `~/.cliworkflow/workflow_tg/WF-TG-CONVENTIONS.md` | 持久化/delta/合并 |
| 4 | `{项目}/docs/product/CONFIG.md` → 再读 `<持久化根>/<scope>/spec.md`+`status.yaml` | **持久化根经 CONFIG 解析**（legacy 项目映射到其现有结构，禁硬编码 docs/product）|
| 5 | `~/.cliworkflow/workflow_tg/WF-TG-META-LESSONS.md`（索引表）| 按 `trigger` 浮现匹配反模式自检（防 fake-done/硬编码/设计泄漏）|

## 执行
**先按 META-LESSONS 索引 `trigger` 浮现匹配反模式自检**，然后按 step card：**第 0 步先判 G0/G1**——只是"实现没达到意图"(A 类缺陷)→**直接修码→verify，不写 delta**；**确是 Human 意图变了**才写 delta。写 `<run_root>/<thread-id>/`(经 CONFIG 解析，request.md 原文 + delta.md ADDED/MODIFIED/REMOVED + 受影响 req-id)，相关条目 ver=pending（A 类无 delta 时由 verify 置 pending，CONVENTIONS §5）；**硬风险（schema/契约/迁移/安全/不可逆）→ 按 `ORCHESTRATOR §3 G3` 处置**（先停标高风险交 Human、`--guarded` 才续——单源 §3）。实现（**产偏差日志 implementation-notes.md**：撞边缘情况选保守路+记录+不停，GUARDRAILS §8）→ verify/explore-full；验收通过把 delta 合并回干净 spec.md 并归档(位置经 CONFIG)。
