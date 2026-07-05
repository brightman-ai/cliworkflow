# TG-CHANGE — 变更已有需求（清晰时）

> 环节：`/cw-change <scope> "<诉求>"`。对**已有**活规格写一条清晰 delta。
> 先读 `WF-TG-GUARDRAILS.md` + `WF-TG-CONVENTIONS.md` + `{项目}/docs/product/CONFIG.md`（取**持久化根**，禁硬编码）。

## 何时用
已有 BS、需求相对清晰。诉求模糊 → 先 `/cw-clarify <scope>` 再回这里。
（**承接探索型 UX 日常变更**：核心思想"只重跑受影响部分"，作用对象 = 活规格相关小节，不做全局矩阵。）

## 流程
0. **先判 G0/G1（防把实现缺陷误写成规格变更）**：只是"实现没达到既定意图"(A 类缺陷) → **直接修码 → `/cw-experience-verify`，不写 delta**（规格没变；**A 类修码后由 verify 置该 scope `verification_state=pending`/重验——代码变=证据可能 stale，别让 A 类绕过 stale 检测**，CONVENTIONS §5）；**确是 Human 意图变了**才继续往下写 delta。
1. 读 **`<持久化根>/<scope>/spec.md` + `status.yaml`**（持久化根经 `{项目}/docs/product/CONFIG.md` 解析：默认 `docs/product/<scope>/`；**legacy 项目按其 CONFIG 映射到现有结构，禁双写**）。
2. 在 **`<run_root>/<thread-id>/`**（经 CONFIG 解析）写：`request.md`（人话原文，一字不改）+ `delta.md`（ADDED/MODIFIED/REMOVED + 验收变化 + 受影响 requirement-id）。
3. **影响判定（轻量）**：只列受影响的 spec 小节 + 验收条目（不做全局矩阵）。**硬风险（schema/契约/迁移/安全/不可逆）→ 按 `ORCHESTRATOR §3 G3` 处置**（先停、标高风险、交 Human；`--guarded` 才续——单源在 §3，此处只留触发关键词 + 指针，防多处复制漂移）。
4. 活规格成熟度：相关条目 `verification_state=pending`（重新打开 ■→△）。
5. 交付实现（**实现须维护偏差日志 `implementation-notes.md`——撞边缘情况选保守路+记录+不停下问，契约见 GUARDRAILS §8**；**若 delta 触及共享身份/状态/数据契约/生命周期**——多处依赖同一东西——实现前/后考虑 `/cw-design-review <scope>`：结构性·非阻断,防 SSOT 违反类"1 根因炸 N 症状")→ 然后 `/cw-experience-verify <scope>`（小确定性改动）或 `/cw-experience-explore-full <scope>`（涉体验）。
6. **合并**：验收通过后把 delta 合并进 `spec.md` 正文（可重写表达，语义不变、id 稳定）；`delta.md` **归档到 run-dir**、对账 A–E 结果落 `reconcile.md`（CONVENTIONS §2 标准产物）、更新 `spec.md` §8 变更摘要行。**不让 spec 变 delta 堆积。**

## DONE-WHEN
- delta 清晰、受影响小节明确（**机器门**：run-dir 有 `request.md`(原文) + `delta.md` 含 `ADDED/MODIFIED/REMOVED`，可 grep）；实现后经第一面墙验收并合并回干净 spec。

## 纪律
- 只有 Human 明确表达的意图变化才改正式规格；AI 推断进 assumptions。
- 穿墙非绕墙：正面改需求/实现，不打补丁绕。
