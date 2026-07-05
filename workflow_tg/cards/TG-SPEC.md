# TG-SPEC — 新建需求设计文档（默认新 BS）

> 环节：`/cw-spec <scope>`。为**新 BS/能力域**创建活规格（SSOT）。
> 先读 `WF-TG-GUARDRAILS.md` + `WF-TG-CONVENTIONS.md` + `{项目}/docs/product/CONFIG.md`（取**持久化根**，禁硬编码）。

## 何时用
新建 BS（greenfield）。输入通常来自 `/cw-think`（场景清单）或 `/cw-clarify`（新 portal 富化结果）。
> 已有 BS 的变更 → 用 `/cw-change`，不是这里。

## 流程
1. 取输入（think 的场景清单 / clarify 的诉求）；**原始诉求一字不改存 `<run_root>/<thread-id>/request.md`**（GUARDRAILS §4 护栏4 可追溯——greenfield 也要留痕，别让原话直接写进 spec 正文就被 AI 重新表达掉）。
2. 按 `templates/LIVING-SPEC.md` 在 **`<持久化根>/<scope>/spec.md`** 创建活规格（**持久化根经 `{项目}/docs/product/CONFIG.md` 解析**：新项目默认 `docs/product/<scope>/`；**legacy 项目按其 CONFIG 映射到现有结构，禁新建第二份双写**）：意图/使用者/情境/范围与非目标/**验收清单(每条标 oracle)**/视觉对标/约束与证据级。requirement-id 稳定。
3. 写 `status.yaml`：`intent_state`（**AI 草案先写 `exploring`，仅 Human 明确接受才 `accepted`**——别自标 accepted 把草案冻成 SSOT）/ `verification_state=not-implemented`。
4. **不复述代码/运行时事实**；只写"要达到什么+怎样算达到"。
5. 去向：交付实现（agent 直接实现或委派 codex；**实现须维护偏差日志 `implementation-notes.md`——撞边缘情况选保守路+记录+不停下问，契约见 GUARDRAILS §8，G0 trivial 豁免**）→ 然后 `/cw-experience-explore-full <scope>`。

## DONE-WHEN
- `spec.md` 干净可读、验收清单每条可被第一面墙判定且标了 oracle（**机器门**：验收清单每行含 `oracle:` 标记，可 grep 校验——对齐框架"禁纯自评"）；`status.yaml` 就位。
- Human 已确认意图（intent_state=accepted）。

## 纪律
- **硬风险（schema 破坏/契约不兼容/迁移/安全/不可逆）→ 按 `ORCHESTRATOR §3 G3` 处置**（先停、标高风险、交 Human；`--guarded` 才续——单源在 §3，此处只留触发关键词 + 指针，防多处复制漂移）。
- 跨域旅程 → 在 `<持久化根>/journeys/<journey>/`（同经 CONFIG 解析）用 `templates/JOURNEY-SPEC.md` 建（懒创建）。
