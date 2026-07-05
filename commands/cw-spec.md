---
description: "[TG·G2] 新建需求设计文档 — 默认新 BS，建活规格 (SSOT)"
---

# /cw-spec — 新建需求设计文档（默认新 BS）

**角色**: Coordinator。**环节**: 为新 BS/能力域创建活规格（SSOT）。已有 BS 变更请用 /cw-change。
用户输入（`<scope>`，输入常来自 /cw-think 或 /cw-clarify）: `$ARGUMENTS`

## 🔒 启动加载链（按顺序 Read，不可跳过）
| # | 文件 | 目的 |
|---|------|------|
| 1 | `~/.cliworkflow/workflow_tg/cards/TG-SPEC.md` | 本环节 step card |
| 2 | `~/.cliworkflow/workflow_tg/WF-TG-GUARDRAILS.md` | 三事实/对账/护栏 |
| 3 | `~/.cliworkflow/workflow_tg/WF-TG-CONVENTIONS.md` | 持久化/成熟度 |
| 4 | `~/.cliworkflow/workflow_tg/templates/LIVING-SPEC.md` | 活规格模板 |
| 5 | `{项目}/docs/product/CONFIG.md` | **持久化根解析**（禁硬编码 docs/product）|
| 6 | `~/.cliworkflow/workflow_tg/WF-TG-META-LESSONS.md`（索引表）| 按 `trigger` 浮现匹配反模式自检（防 fake-done/硬编码/设计泄漏）|

## 执行
**先按 META-LESSONS 索引 `trigger` 浮现匹配反模式自检**，然后按 step card：在 **`<持久化根>/<scope>/spec.md`**（经 `{项目}/docs/product/CONFIG.md` 解析：默认 `docs/product/<scope>/`；**legacy 项目按其 CONFIG 映射到现有结构，禁双写**）建活规格（验收清单每条标判定方式、不复述代码事实），写 status.yaml（**intent_state：仅 Human 明确接受才 `accepted`，AI 草案=`exploring`，别自标 accepted 把草案冻成 SSOT** / ver=not-implemented）。**硬风险（schema/契约/迁移/安全/不可逆）→ 按 `ORCHESTRATOR §3 G3` 处置**（先停标高风险交 Human、`--guarded` 才续——单源 §3，此处只留触发关键词 + 指针）。跨域旅程用 JOURNEY-SPEC 模板（懒创建）。交付实现（含委派 codex）**须产偏差日志 `implementation-notes.md`**（撞边缘情况选保守路+记录+不停，GUARDRAILS §8）→ 后续 explore-full 对账消费。
