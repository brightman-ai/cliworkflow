# WF-TG-CONVENTIONS — 持久化 / 成熟度 / 范围 / 陈旧

## 1. 范围(scope) = 参数，不是命令
- `<scope>` = 能力域（chat/design/workspace/某 BS）或跨域旅程（continue）或子域。
- **新增全新 BS = 新参数值**，命令集不变（无 `/tg-new`、无动态注册）。

## 2. 持久化（按生命周期分离；严格限制人手维护面）
> 下方为**新项目默认布局示例**；**实际路径一律经 CONFIG 解析**（见本节末"持久化根解析铁律"），legacy 项目映射到其现有结构。
```
{项目}/docs/product/<scope>/
  spec.md       # ★唯一人手维护的"规范意图"，干净可读（见 templates/LIVING-SPEC.md）
  status.yaml   # 机器生成：intent_state + verification_state + last-verified + 证据指针
  decisions.md  # 追加日志：Human 正式取舍（accept/reject/by-design/defer）
  baselines/    # 自动：黄金截图 + 可脚本回放断言（distill 产物）
{项目}/docs/product/journeys/<journey>/   # 跨域旅程（一等对象，懒创建；见 templates/JOURNEY-SPEC.md）
  spec.md  status.yaml  baselines/

{项目}/docs/.tg/   # tg 工作区（在 docs/ 下，随 docs 软链跨 project 目录共享）
  work/<thread-id>/        # 临时工作包，完成即归档（.gitignore）。每会话独立目录 → 并发安全
    request.md(人话原文一字不改) / route.yaml(涌现档位) / delta.md(ADDED/MODIFIED/REMOVED) / implementation-notes.md(实现期偏差日志,契约见 GUARDRAILS §8) / run.json(恢复点,见§6；记 source_cwd) / evidence/(②③证据) / reconcile.md(对账 A–E)
  lessons/<lesson-id>.md   # 项目级元教训：**每条一文件**（并发安全；不用单一 lessons.md）。通用的晋升到全局 ~/.cliworkflow/workflow_tg/WF-TG-META-LESSONS.md（全局 id/多机 merge-safe 协议见其文件头"多机互不冲突更新"）
```
**唯一性铁律**：experience 体系与 workflow_tg **共用同一持久化根**，绝不另立第二份意图源。
**多软链 + 并发写安全铁律**（多个 project 目录如 多个 project 目录 **软链同一 `docs/`**，会**多会话并发写同一 `docs/.tg/`**）：
- **per-run 用唯一目录**：`<thread-id>` = **`<YYYYMMDD-HHMMSS>-<scope>`**（时间前缀 → 自然时序可排序；scope → 可读）；多模块加 `-<source 模块名>`（`-pro`/`-term`/`-brow`）；**同源同秒同 scope 仍可能撞 → 原子 `mkdir` 失败则自动追加 `-2`/`-3` 递增**（见命名易读铁律 tie-breaker）；`run.json` 记 `source_cwd`。
- **"多会话追加的集合" 一律「每条一文件」**（如 `lessons/<YYYYMMDD>-<slug>.md`；同日同 slug → 创建失败自动 `-2` 递增），**禁单一共享文件并发追加**（多会话写同文件会互相覆盖/损坏）。
- **per-scope 单 SSOT**（`spec.md`）：不同 scope 天然隔离；同-scope 并发编辑靠 git/Human 合并（这是单 SSOT 的固有取舍，非路径问题）。

**命名易读铁律**：所有 ID/目录名要**人和 AI 都能读懂 + 可排序**——**时间前缀（`YYYYMMDD-HHMMSS`，自然时序）+ 描述性 slug/scope（语义可读）+ 必要时 source 模块名（可读）**；**禁用不可读随机串当主标识**（随机=乱序 + 难懂 + 不可推断）。
- **防撞 tie-breaker（可读且确定，替代随机）**：目标名已存在（同秒同 scope / 同日同 slug）→ **创建用原子 `mkdir`（或 `set -C` / `O_EXCL`），失败即自动追加 `-2`/`-3`… 递增后缀**（可读、确定、保唯一）；多模块并发先叠 `-<source>` 再递增。**绝不靠"希望不撞"或随机赌唯一。**
- topic_id 沿用 i-think 的 `TH-<日期>-<slug>`（本就可读；同日同 slug 同样走递增）。

**并发分类表（举一反三 — 所有持久化文件按此定形态，不只 lessons）**：
| 文件 | 写者/频率 | 并发风险 | 规范形态 |
|------|----------|---------|---------|
| `lessons/<YYYYMMDD>-<slug>.md` · finding · 任何"多会话追加的集合" | 多会话追加 | **高** | **每条一文件**（不同会话写不同文件，不撞；名=日期+描述 slug 可读可排序）|
| `work/<YYYYMMDD-HHMMSS>-<scope>[-<source>]/` | 每 run | 唯一+可排序 | **per-run 目录**（时间+scope 可读可排序，source 防撞非随机）|
| `baselines/<journey>.*` | distill | per-journey 隔离 | **每旅程一文件** |
| `CONFIG.md` | cw-init，**一次性** | 低（init 罕见）；多模块软链共享**一份** | **单文件**；cw-init **必须幂等**：已存在→读+补缺字段，**禁盲覆盖**；多模块差异走 per-scope 段，不另起第二份 |
| `spec.md`（per-scope）| spec/change，人审 | 同-scope 并发编辑 | **per-scope 单 SSOT**；跨 scope 隔离；同-scope 靠 git/Human 合并 |
| `status.yaml`（per-scope）| verify/change，机器 | 同-scope 并发更新 | per-scope；**可再生机器状态**，last-writer 可接受 |
| `decisions.md`（per-scope）| 人审取舍，append | 同-scope 并发追加 | per-scope；低频可单文件，若高频→拆 per-entry |
| `docs/topics/<topic_id>-<slug>/`（think **真相**）| think，多会话 | 唯一 topic_id 隔离 | **每条一目录**（并发安全；topic_id=`TH-<日期>-<slug>`，同日同 slug 递增）；**status(DISCUSSING/MERGED)+结晶数写在目录内 session 文件头** = 状态真相 |
| `docs/topics/TOPIC-BOARD.md`（think 索引）| think 注册，多会话 | 中（并发 append）| **仅可再生聚合索引、非真相**——**status/结晶数真相在 per-topic session 文件头**；board 由"`ls` topic 目录 + 读各 status"**聚合重建**，并发丢 entry/状态可重建（沿用 i-think 生态不另立）|
| 全局 `WF-TG-META-LESSONS.md` | retro 晋升，罕见/人审 | 低（**但跨机**）| 单文件**策展索引**；**多机 merge-safe**：id=`TGL-<日期>-<slug>`（生成前 grep 去重 + 同日同 slug 追加 `-N`，禁顺序号）+ 写前 `git pull --rebase` + §Lint L9 唯一性复核；冲突浮现（非静默）可手动保留两条（见 `WF-TG-META-LESSONS.md` 头"多机互不冲突更新"）|
> **判据**：会被"多会话并发追加"的 → 每条一文件；read-mostly / 一次性配置 / per-scope 单 SSOT / 人审策展索引 → 单文件（但 per-scope 隔离 + 写者幂等/低频）。新增任何持久化文件先过此表定形态。
**持久化根解析铁律**：实际路径**由 `{项目}/docs/product/CONFIG.md` 解析，禁硬编码 `docs/product/`**。新项目默认 `docs/product/<scope>/`；legacy 项目（你的项目）= 其现有 `docs/experience/<portal>/`，**沿用、禁双写**。
**docs/-rooted 铁律**：`long_term_root`、`run_root` 及一切 tg 工作/证据/findings/过程产出（设计文档、关键过程、actor-report、evidence、run.json…）**一律落 `docs/` 下**（默认 `docs/.tg/work/`；legacy 映射也须在 `docs/` 内，如 `docs/.artifacts/<legacy>/`）——**禁写项目根 `.artifacts/` 或工程根任何位置**（保工程根干净 + 产出随 `docs/` 软链共享 + 可被 `.gitignore` 统一管）。
> 兼容说明：你的项目 现有 `docs/experience/<portal>/`（intent.md/ledger.yaml/log.md/baselines）是本约定的前身，**保留沿用**；新项目用 `docs/product/<scope>/`。映射：intent.md↔spec.md 的意图段、ledger.yaml↔status.yaml+decisions.md。**不强制迁移已跑通的 你的项目 结构**（避免效果倒退）。

## 3. 活规格（spec.md）写法
- 只写**意图 / 使用者 / 情境 / 范围与非目标 / 验收清单(每条标 oracle) / 视觉对标 / 已知约束与证据级**。
- **不复述代码/运行时已表达的事实**（零重叠 = 零漂移面）。
- 变更期用 `delta.md` 表达增删改；接受后**合并进 spec.md 正文**（可重写表达，只要语义不变、requirement-id 稳定、delta 已归档）。**不让 spec.md 沦为 delta 历史堆积（规格考古学）。**

## 4. 成熟度（拆两轴）
```yaml
intent_state:        exploring | accepted
verification_state:  not-implemented | pending | verified | stale
```
符号：`○`意图探索 / `△`意图已接受待验 / `■`已验 / `■+1△`核心稳定但有一条待验 delta。

## 5. 陈旧(stale)：事件触发，不靠时间
- 触发事件：相关代码改 / 共享依赖或状态机改 / 引用旅程变 / 基线失败 / Human 改意图 / provider·runtime·外部契约变 / 生产 telemetry 异常 → `verification_state=stale`。
- 时间只产生 `review-recommended` 软提示，**不自动改意图成熟度**。
- **V1 廉价近似**（无 impact graph 时）：`/cw-change`/`/cw-spec` 改了某 scope 代码 → 该 scope `verification_state=pending`，直到再撞墙。

## 6. 恢复检查点 run.json（**通用恢复点，非工作流引擎**）
- **`status` 链（通用，覆盖三类管线，别扩展状态）**：`planned → actor-complete → findings-frozen → diagnosed → fix-in-progress → verification-pending → human-review → closed`。
  - **各管线映射到同一链**（不另造状态机）：experience=旅程原义；**experiment**=`actor-complete` 含冒烟+严谨两挡、`findings-frozen`=测量完；**change**=`actor-complete`=实现完；**troubleshoot**=复现完即 `findings-frozen`（只复现产 Finding 不实现，`actor-complete` 隐式跳过）。
- **`next_step`（字段定义，本节单源）**：一句话"中断后从哪续"（自由文本、给恢复读，非枚举）；配 `git_before`（恢复时 `git diff` 比它，判有无新变更决定从 next_step 续还是重诊）。
- **run.json ↔ status.yaml 映射（单源，别两处各猜）**：`run.json.status` = **单个 run 的过程断点**；`status.yaml.verification_state` = **per-scope 成熟度真相**。二者正交，由 `/cw-experience-verify` 收尾桥接：run 到 `verification-pending`/`human-review` ⟺ scope `verification_state=pending`；run `closed` 时 verify 写 scope `verified`（或退回 `stale`）。**别在两处各自推断同一状态**。
