# WF-TG-00 — workflow_tg 编排协议（Orchestrator）

> workflow_tg = 面向**探索型 UX 产品**的轻量自适应变更管线。与 workflow_ng（重型前置设计，留给 Epic/绿地大平台）并存、不替代。
> 设计理念与依据（人读）见 `design/`（本框架内：元 schema + 每命令设计文档，可移植不依赖具体项目）。本文件是可执行的操作总纲。
> **角色**：Coordinator（智能调度器）。本文件被 `/cw-*` 命令加载。

---

## 1. 内核：三事实 + 对账闭环（一切的根）

```
① 规范真相 = Human 接受的产品意图   ← 唯一 SSOT（落"活规格" spec.md）
② 实现事实 = 代码与运行时实际行为   ← 证据
③ 用户事实 = 真实用户使用的实际经历 ← 证据
```
- **SSOT = ①**。②③ 是**证据**，用来挑战/校准 ①，**绝不能直接变成 ①**（实现有 bug 时把现实当真相 = 把 bug 反写进规格）。
- 提供 ③ 的智能体 = **Experience Witness（见证者，非预言机）**：纯用户视角、禁读规格/代码、只凭屏幕。
- workflow_ng 的病根 = 只维护一种事实（意图写成文档）、从不对账 → 必腐烂。**workflow_tg 的重心就是 Verify→Reconcile。**

闭环：`Capture → Clarify/Brainstorm/Think →[研究/实验型可选: Experiment 发现态=测出方向]→ Spec/Change → Implement(撞上未知→产偏差日志, GUARDRAILS §8) → Experience/Verify(取②③+偏差日志+对账; 量化指标走 Experiment 验证态=Empirical oracle) → Decide(必要才上Human) → Merge(合并delta+归档+蒸馏基线)`

---

## 2. 命令层：环节固定，范围作参数（核心可靠性原则）

**命令轴 = 开发环节（固定，可预测）；产品范围 `<scope>` = 参数（chat/design/某BS/某跨域旅程）。新增 BS = 新参数值，不新增命令。** 不存在吞一切的单门，不动态注册命令。

| 命令 | 环节 | step card |
|------|------|-----------|
| `/cw-clarify <scope> "<人话>"` | D0 表达模糊→单轮≤3问结构化放大(产出含意图/范围/非目标/验收+oracle/视觉对标/隐含意图/验证夹具 7 要素)→新portal出spec/已有出change/**G0 快修直落(按卡：仅A类+声明+runtime证据+impl-notes回写)** | `cards/TG-CLARIFY.md` |
| `/cw-brainstorm <scope> "<想法>"` | D1 方向逼问收敛→自适应逼问(默认一次一问/每问带推荐/按依赖排序)逐个拍定方向+关键决策（"不知选哪条路"时）| `cards/TG-BRAINSTORM.md` |
| `/cw-think <scope>` | 深碰(先锚定真问题→问题/解空间分开→撞第一面墙→三域；贯穿 AI-native 自检+grill-me 共创)→想清楚+场景清单, 落盘 `docs/topics`(tbat/tcopy) | `cards/TG-THINK.md` |
| `/cw-spec <scope>` | 新建需求设计文档（默认新 BS） | `cards/TG-SPEC.md` |
| `/cw-change <scope> "<诉求>"` | 改已有需求（清晰时）→ 一条 delta | `cards/TG-CHANGE.md` |
| `/cw-experiment <scope>` | 实证发现/验证→受控量化对比"测出最优"(同口径 dataset+先定指标)；发现态(spec 前测方向)+验证态(改后验指标，作 Empirical oracle) | `cards/TG-EXPERIMENT.md` |
| `/cw-design-review <scope>` | 设计完整性评审（结构性·Human 主动·非阻断）：审 SSOT/状态归属/不变量/耦合,抓"1 根因→N 症状";trivial 不碰共享态则跳过 | `cards/TG-DESIGN-REVIEW.md` |
| `/cw-experience-explore-full <scope>` | 第一面墙·旅程设计+撞墙+自动修复loop，多次可调对话富化 | `cards/TG-EXPERIENCE-EXPLORE-FULL.md` |
| `/cw-experience-troubleshoot <scope> "<现象>"` | 第一面墙·先复现已报问题 | `cards/TG-EXPERIENCE-TROUBLESHOOT.md` |
| `/cw-experience-verify <scope>` | 第一面墙·验收某次改动+对账 | `cards/TG-EXPERIENCE-VERIFY.md` |
| `/cw-experience-distill-baseline <scope>` | 蒸馏脚本基线→便宜回归 | `cards/TG-EXPERIENCE-DISTILL-BASELINE.md` |

实现（写码）不单设命令：`/cw-spec`/`/cw-change` 产出清晰需求后由 agent 直接实现（或委派 codex，契约随任务传递）——**实现须产偏差日志 `implementation-notes.md`**（GUARDRAILS §8；G0 trivial 豁免），由 verify/explore-full 对账消费。

**横切命令（无 card、自包含，任意环节可叠加调用）**：`/cw-caveman`（极简表达模式，省 token 不损实质/证据）· `/cw-handoff`（结构化跨 session 交接，固定块产出契约防丢信息）。设计文档同在 `design/`；它们不是管线环节，故无 step card。
**生命周期命令（有 card）**：`/cw-init`（新工程接入：自适应填 CONFIG + 查工具 + 验加载链）· `/cw-retro`（元教训蒸馏入 `WF-TG-META-LESSONS.md`，下次对账/authoring 自动浮现、防重犯——教训飞轮的捕获腿）。

## 2.1 三档澄清/碰撞（同一件事的三种深度 — 先判 D1）
> **三档共同起点 = 先理解真意图/背景、不跑偏**（AI 易顺字面 pattern-match 一个貌似合理的解释就流畅地跑——三档都先确认"抓对了在解什么"再动手，只是确认深度递进）。差别只在**深度**与**是否强制深碰**：clarify(轻确认) < brainstorm(框对决策空间) < think(意图链回溯找真问题)。
- **`/cw-clarify`（D0 收敛）**：解表达模糊（"心里有数没说清"）。单轮 ≤3 问结构化放大，产出含 7 要素的清晰可验诉求。**一轮没清 = 升档，不多问一轮**。＝挖**未知的已知**（你以为不言自明、从没写下的东西）。
- **`/cw-brainstorm`（D1 方向收敛）**：解"方向没定/不知选哪条路"。**自适应逼问**（默认一次一问/每问带真立场推荐/按依赖排序）逐个**拍定方向+关键决策**（非丢选项让你挑）。不强制深碰，需要时可轻量碰第一性。**think 的高频轻量替身**。＝清**已知的未知**（知道自己没想清的决策）。
- **`/cw-think`（D3 深碰）**：解深度认知模糊（真问题没锁定/核心信念可能错/极复杂新域）。**先锚定真问题(意图链+切面四问)→问题空间vs解空间分开→撞第一面墙→三域**，贯穿 AI-native 自检 + grill-me 共创。**低频重型，能 brainstorm 解决就别动它**。＝撞**未知的未知**（压根没考虑过的盲区）。

## 2.2 命令×能力矩阵（SSOT — 防"总纲声明能力 / 逐命令手工实现"语义漂移；可 diff 核查）

> 历史病（TGL-02/09 复发到第 8 次）："哪些命令载 META / 读 CONFIG / 落 run_root / 带 method_effect" 是散文散落总纲+各命令，**§Lint grep 扫关键词、扫不到语义 → 必漂**。本矩阵 = 这些能力归属的**唯一真相**；命令文件的 🔒加载链 + 卡产出须与本表一致；**§Lint L10 机械核查的仅是"载 META"布尔列（命令文件载 META 与否 == 本表¹列）——其余列（CONFIG/run_root/method_effect）目前靠人审对照本表，尚非机械门**（别误以为全矩阵已自动核查）。

| 命令 | 载 META¹ | 读 CONFIG² | 落 run_root³ | method_effect⁴ | 典型档 |
|------|:--:|:--:|:--:|:--:|------|
| clarify | – | ✓ | ✓(诉求；G0 快修按卡豁免→impl-notes；深碰产物→docs/topics⁵) | – | G2 |
| brainstorm | – | – | offer；深碰产物→docs/topics⁵ | – | G2 |
| think | – | – | docs/topics⁵ | – | G2 |
| spec | ✓ | ✓ | ✓(request＋实现期impl-notes) | – | G2 |
| change | ✓ | ✓ | ✓(request/delta＋实现期impl-notes) | – | G1 |
| experiment | ✓ | ✓ | ✓(实验记录) | ✓ | G2 |
| design-review | ✓ | ✓ | ✓(报告) | ✓ | G0–G3 |
| exp-explore-full | ✓ | ✓ | ✓(run.json) | ✓ | G1/G2 |
| exp-troubleshoot | ✓ | ✓ | ✓(run.json) | ✓ | — |
| exp-verify | ✓ | ✓ | 关run.json+status.yaml | ✓ | G0/G1 |
| exp-distill-baseline | – | ✓ | ✓(baselines)⁶ | – | — |
| init | – | ✓(写) | –(产出=CONFIG) | – | 一次性 |
| retro | ✓ | ✓⁷ | ✓(retro-scan) | ✓ | 横切 |
| caveman / handoff | – | – | handoff→active run⁵ | – | 横切 |
| goal-draft | – | 按需⁸ | 按需(plan)⁸ | – | 横切 |

**列判据（rule，非逐命令拍脑袋）**：
- ¹**载 META**：凡 **authoring 框架/规格制品 或 对账(A–E)/产 finding** → 载；纯需求澄清(clarify/brainstorm/think)、一次性(init)、机械蒸馏(distill) → 不载（避噪音）。**B1 修正**：ORCHESTRATOR §4 row2.5 + SKILL 的"总是读 META"措辞，改为"按本判据/矩阵¹列"。
- ²**读 CONFIG**：凡需**项目实例**（持久化根/UX 工具/dataset/LSP/代码位置）→ 读。
- ⁸goal-draft 的读 CONFIG / 落 run_root 均**条件性**：① 给了 scope 且该 scope 已有 `spec.md` → 经 CONFIG 读它取验收清单/非目标当 grounding；② 目标**非 trivial / 多 checkpoint** → 把完整计划（CP + 各 oracle + 约束 + 非目标）写入 `<run_root>/<thread-id>/goal-plan.md`（经 CONFIG 解析 run_root，有 active run-dir 用它、无则新建），condition 只留瘦身指针（指针 + 终态 + 择要）——**用文件传细节、压 condition 长度、避 4000 硬限与粘贴膨胀（类 handoff）**。单 CP 小目标零依赖、直接内联 condition。
- ³**落 run_root**：凡**产出被下游消费**（诉求/delta/实现期偏差日志/实验记录/报告/findings/扫描结果）→ 必落 `<run_root>/<thread-id>/`（机器可解析、可 resume）。例外：brainstorm 纯过程(offer 不默认落)、think 固定位(`docs/topics/`，见⁵)、init 产出即 CONFIG。
- ⁴**自度量（口径随域，统称记于此列）**：凡**产 finding/verdict/A–E 分类**的命令必带自效果指标，**形态按域**——Witness/对账类（verify/explore-full/design-review）用 `{raised, accepted, deferred, rejected_误报, human_escape_漏报}`（`deferred` 适用非阻断命令如 design-review；阻断式可省）；troubleshoot 用 `{reproduced, not_reproduced, dismissed_误报}`；experiment 用 result schema `{hypothesis,metric,threshold,n,result,flip}`（非四元组）；retro 用 `{recurring_found, recorded, deduped, gate_rejected, promoted}`。纯生成/澄清（clarify/brainstorm/think/spec/change/init/distill）→ 无。
- ⁵think 落 `docs/topics/`（i-think 跨工程固定位，非 run_root，见 CONVENTIONS §2）；caveman/handoff 落当前 active run-dir（无则 mktemp，见 handoff 命令）。
- ⁶distill **幂等**（重跑安全），产出落 `<持久化根>/<scope>/baselines/`（非 run_root），**无 run.json 恢复需求**；写基线用原子（全部写完再登记 status 指针，避免半成品被当基线）。
- ⁷retro 读 CONFIG 仅为**解析 run_root**（放 retro-scan）；框架自审（claude_remote 无项目 CONFIG）→ run_root 默认 `docs/.tg/work/`（CONVENTIONS §2 默认值）。

---

## 3. 投入档位（G0–G3）是"涌现"的，不是隐藏路由

你调用了哪些环节命令，就涌现出投入档（无全局路由器替你猜）：

| 档 | 含义 | 典型命令序列 |
|----|------|-------------|
| **G0 Fix** | 已接受意图未实现（缺陷） | 改码 → `/cw-experience-verify` |
| **G1 Change** | 意图清晰地变了 | `/cw-change` → 实现(产偏差日志, §8) → `/cw-experience-verify`/`explore-full` |
| **G2 Discover** | 意图不清 | **默认先判 D1**：`/cw-brainstorm`(不知选哪条路) ｜ `/cw-clarify`(只是没说清) ｜ `/cw-think`(核心信念存疑才深碰) → [研究/实验型先 `/cw-experiment` 测方向] → `/cw-spec` → 实现(产偏差日志, §8) → `/cw-experience-explore-full`(量化指标加 `/cw-experiment` 验证态) |
| **G3 Guarded** | 硬风险（schema破坏/契约不兼容/迁移/安全/不可逆/**扩大网络可达面**——tunnel·端口暴露·反代·分享链接：先核目标服务门控现状，无门控即 G3 停） | **先停、标高风险、提炼判断点交 Human 定**（tg **不主动推荐**改用别的管线；Human 主动要重型流程才走，否则不提醒）；若 Human 选择继续在 tg 内做，强制 experience 加 migration/contract 验证器 + Human-gate（`--guarded`） |

> **`/cw-design-review` 不占档位**——它是 G0–G3 里"实现前后"由 Human **按变更重大程度**(碰身份/状态/契约/生命周期时)主动调的**非阻断**结构性评审;**G3 硬风险(schema/契约/迁移)强烈建议调**;trivial 改跳过(不改档位涌现)。兜底:`/cw-experience-verify` 的根因透镜在 ≥2 症状疑同根时回指它。

---

## 4. 启动加载链（Coordinator 按需 Read，不可跳过）

| # | 文件 | 何时读 |
|---|------|--------|
| 1 | 本命令的 `cards/TG-*.md` | 总是 |
| 2 | `~/.cliworkflow/workflow_tg/WF-TG-GUARDRAILS.md` | 总是（三事实/对账/护栏） |
| 2.5 | `~/.cliworkflow/workflow_tg/WF-TG-META-LESSONS.md`（**仅索引表，~1屏**）| **按 §2.2 矩阵¹列**（authoring 框架/规格制品 或 对账 A–E/产 finding 的命令载；纯澄清/一次性/机械蒸馏不载）；命中时**按 `trigger` 列自动浮现匹配条目**注入自检（正文命中才读）|
| 3 | `~/.cliworkflow/workflow_tg/WF-TG-CONVENTIONS.md` | 涉及读写规格/状态时 |
| 4 | 经 CONFIG 解析的 `<long_term_root>/<scope>/spec.md`(+status.yaml)（long_term_root=基目录，默认 docs/product/）| 已有 scope 时 |
| 5 | `{项目}/docs/product/CONFIG.md` | **凡需项目实例的命令**（experience 系 / design-review / clarify / change / spec / experiment / init；**goal-draft 按需**——读 spec 作 grounding、或写 goal-plan 文件解析 run_root 时）——取**项目**专属配置：持久化根 / UX 工具 / URL / build / 端口 / dataset / LSP 可用性 / 代码位置 / gotcha；在**项目内**，非全局框架内 |

---

## 5. 关键纪律（详见 GUARDRAILS）
- **Human-accepted intent is truth; implementation is evidence**（意图来源优先级见 GUARDRAILS §2）。
- **Creator≠Verifier**：实现者不做最终体验验证；Witness 强制无知保独立。
- **穿墙非绕墙**：修复正面解决根因，不退化为补丁（源自 workflow_ng 的"不退化"铁律）。
- **auto-fix 边界**：explore-full 只自动修 A 类（实现缺陷）；B 规格空白/C 意图变/E 品味 → 提炼白话判断点上 Human，不自动改意图。
- **注意力预算**：呈现 Human 的判断点 ≤9；卡住即停、提炼判断点上 Human，不无限 loop。

---

## 6. 与 workflow_ng / experience 引擎 的关系
- **不动 workflow_ng**：它是 G3 Epic 档资产 + 方法论来源（证据分级 / 角色防编造 / 漂移分级 / Human 参与协议 / 反模式登记册）。
- **experience 系命令** = `experience 引擎` 的**产品无关通用化**：**方法权威在 `experience/ENGINE.md` + 通用 `ACTOR.md`**；各项目（含 你的项目）只在 `{项目}/docs/product/CONFIG.md` 填**实例绑定**（持久化根、UX 工具命令、System Evidence 探针、gotcha）。**不把任何项目的 actor/playbook/实现当方法权威**（历史 playbook 仅可选人读）。你的项目 的实例值映射到其现有 `docs/experience/` 持久化、禁双写。
- **持久化解析铁律**：所有读写规格/状态/证据的路径**一律经 CONFIG 解析**，不得硬编码 `docs/product/`。legacy 项目（如 你的项目）写回其现有结构（`docs/experience/<portal>/`），**绝不双写或新建第二份意图源**。
