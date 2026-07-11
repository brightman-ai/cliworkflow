# WF-TG-GUARDRAILS — 三事实 · 对账 · 常驻护栏

> 始终生效。是"护栏"不是"步骤"——零额外仪式，但每个 `/cw-*` 命令都受其约束。

## 1. 三事实（再述，因为它是根）
- ① 规范真相 = Human 接受的意图（SSOT，落 `spec.md`）。② 实现事实（代码/运行时）。③ 用户事实（真实使用经历）。
- ②③ 挑战/校准 ①，**绝不直接变成 ①**。

## 2. 意图来源优先级（Human-accepted intent is truth）
1. **Human 当前 Prompt + 已接受的设计决策** = 产品该是什么（最高）。
2. **设计文档/活规格** = 规范性证据；**与当前 Prompt 冲突时以 Prompt 为准**。
3. **代码 / git diff / 运行页面** = 只说明当前实现、风险范围、诊断事实，**不自动定义意图**。
4. **AI 推断** = 必须标 `assumption`，不得静默写入正式意图。

## 3. 对账分类（Experience 后，比对三事实）
| 类 | 含义 | 处置 |
|----|------|------|
| **A implementation-defect** | 意图明确，实现没达到 | 只修代码 + 最便宜回归；**不改规格** |
| **B emergent-spec-gap** | 现实揭示了此前未声明、但应被接受的要求 | **Human 接受后**改规格（spec/delta） |
| **C intentional-change** | Human 主动改了意图 | **Human 决定后**改规格 |
| **D environment-or-tool** | 环境/Witness/工具问题 | 修工具，不改规格不改产品 |
| **E taste-hypothesis** | 有体验风险但证据不足 | 上 Human 判断 |
- **只有 B、C 改正式规格**；A 只动代码。
- **auto-fix（explore-full）只自动修 A**；B/C/E 提炼白话判断点上 Human → **SSOT 不被 auto-fix 偷改**。
- "是 A 还是 B" 拿不准 → **从严当 B 上 Human**（宁可多问一次，不可把规格空白当缺陷悄悄修掉）。

## 4. 验证包（Verification Pack）：多预言机，按影响选
| 预言机 | 验什么 | 形态 |
|--------|--------|------|
| **Experience Witness** | 用户实际经历（③）：可理解性/反馈/状态/可用性/连续性/视觉 | 干净上下文 actor，禁读规格/代码，截图判定 |
| **Deterministic Checks** | ②：单测/集成/状态机/契约 | 代码级 |
| **System Evidence** | ②：网络/日志/DB/出站 model/会话 | 运行时探针（grader lens：截图+console/network/visible_errors）|
| **Empirical Measurement** | 量化"哪个更优/是否达标"（②延伸）：准确率/延迟/信噪/召回/资源，同口径 dataset 对比 | 受控实验 `/cw-experiment`：先定指标+达标线，冒烟→严谨，结论可证伪 |
| **Migration Check** | 数据迁移/兼容 | 仅 G3 |
| **Human Decision** | 意图/品味/取舍 | 仅 Human-gate |
- **Witness 不是万能**：数据一致性/权限/路由/迁移/安全/性能/隐藏错误它单独验不了 → 必须配对应预言机。
- **量化最优 ≠ 体验好**：`Empirical Measurement`（`/cw-experiment`）给数字（哪个模型/参数更准更快），但"数字好"不等于"用着好" → 量化与主观体验各配 oracle（experiment + experience）；实验结果同样走 §3 对账 A–E（达标线没命中且意图明确=A，揭示新要求=B，意图变=C）。
- 验收清单每条**标 oracle**（见 templates/LIVING-SPEC.md）。
- **图可机读（通用 — 所有命令）**：用户给的截图/图片**路径或附件 → 用当前 runtime 的图片读取能力读图**（Claude Code = `Read` 工具；Codex/其它 runtime = 其等价图片工具如 `view_image`），从图里取证据/做视觉对标；**绝不要求人转述、绝不因"看不到"降级假装**。仅当 **runtime 无图片读取能力，或确无可读图**（只说"如图"无路径/文件不存在）才标 ○ + 由 UX 体验命令交 Witness 在第一面墙截图读取（机器读，非人读）。

## 5. 六条常驻护栏
1. **断言绑定证据**：关键结论标 ■硬/△软/○类比；证据不足必须标记并停下核查，**禁编造凑"通过"**。
   - **完成=场景 oracle(非弱化绿)**：出 `完成/达成/通过/🏁` 必**复述用户原话场景 + 同条消息引一个跑通该场景的 runtime 证据**(BUILD绿/单测过≠达成用户场景)。**空/缺输出=未知,绝不读成通过**(验证 preflight:工具存在?查的是发布产物还是 stub?log query 含你写的级别?)。[[TGL-01]] 子形态。
   - **诊断域证据纪律**：未在**用户所见环境**复现的定性一律标 ○ + 附"什么观察能推翻我"；"我这边 vs 你那边"先显式核对同实例/网络/宿主/版本(构建时间 vs 改动时间)；同一问题 **≥2 个假设被证伪 → 停止逐猜**，列判别矩阵(每嫌疑 × 一个零歧义测试)一次交 Human，并 offer 挂起先推进其余。宣称"工具不支持 X"须附 help/README 证据行，否则按 ○ 且先疑用法。
2. **产出者≠验证者**：实现者不做最终体验验证；Witness 强制无知（不读码/规格/已知 finding/上轮结论）保独立；客观像素事实可主 Agent 自查，主观体验必独立 Witness 复跑。
3. **Human 注意力预算**：呈现判断点 ≤9；长报告**禁直转 Human**，先提炼白话判断点（人话在前，证据在后；只抛需 Human 定的事）。
4. **可恢复**：原始 Prompt（一字不改）/ delta / 决策 / 证据落 `<run_root>/<thread-id>/`（经 CONFIG 解析，默认 `docs/.tg/work/`；run-dir 唯一），跨会话可 resume。（clarify **快修分支**可豁免 request.md——须开工显式声明 + 收尾 delta 一行回写，见 TG-CLARIFY 路由。）
5. **决策附反例**：每个重要决策输出 `当前结论 / 最大反例 / 未确认假设 / 什么证据会翻转`。（"连续同意=迎合"仅作软信号，不作硬规则。）
6. **反模式登记册（高门槛）**：仅"曾发生 + 有复发风险 + 能绑具体防御 + 防御可低成本自动核查"才登记，否则只是 Finding。格式 `{id, pattern, guard:{test, experience}, trigger:[…]}`（`id` 须防撞键：框架层 `TGL-<日期>-<slug>`（生成前 grep 去重、同日同 slug 追加 `-N`）、项目层一条一文件，**禁顺序计数**，多机并发安全）。
   - **实体 = `WF-TG-META-LESSONS.md`**（索引在**矩阵¹命令**的加载链、载入必读、正文按需；**非每命令载**——见 ORCHESTRATOR §2.2）。**自动浮现**：authoring / 对账 A–E / spec·change 开场时按 `trigger` 捞匹配条目注入自检（复制 browser-skill 的 `skill_hint`，**不靠人记得查**——否则又是死文档）。
   - 新条目经 `/cw-retro` 写回门入库；**`guard.test` 必须机器可核查(grep/lint) 或挂外部验证(Witness/codex/测试)——禁纯自评**（自评"做了"≠真做到 = fake-done）。

## 6. 穿墙非绕墙（源自 workflow_ng 的"不退化"铁律）
修复必须正面解决根因。三种逃避自检：(1) 补丁模式（旧接口打补丁而非实现设计的新接口）(2) 逃避模式（把"废弃功能"包装为终局解）(3) 降级模式（用简单不优雅方案且不说清代价）。碰到阻力先问：**我在解决问题还是逃避问题？**
- **穿墙含"先开灯"(诊断可见性优先, [[TGL-20260621-diagnostic-visibility-first]])**：不透明/第3方/native 边界**返成功但无产出 / 静默 no-op** 时,**同边界连续 2 次盲修 observable 未变 → 第3动作必须是可见性动作**(verbose/debug build、搬到有 stderr 的全功能工具/平台、最小 repro、符号/依赖检查),**不是第3次猜修,更不是"宣布硬墙 defer 给人"**。"2次失败→改向"=取可见性,不是放弃。复用带已知缺陷工程的资产 → 那缺陷是 hypothesis#1 先证伪。
- **设计声明≠代码实现([[TGL-20260621-design-code-divergence]])**：声明"已实现设计的修法"前,设计里每条 load-bearing 不变量 → 一句 `rg`/断言证代码强制或不违反(早于 LLM review 的廉价门)。

## 7. 环境 vs 产品（分开判，别二选一）
Trigger（环境：runtime 没装/没认证·限流·CDP=浏览器调试连接失败·数据坏·逻辑错）属环境**不删** Product Response 层缺陷（是否明确告知·假 loading·给原因·给恢复·错标完成·丢输入/上下文）。例：CLI 没认证（环境）但 45s 只显"准备中"无报错 = 产品 UX bug。

## 8. 偏差日志（实现期未知数捕获 — 对账的第三输入源；契约单源在此，卡片只指针）
spec/change 交付实现（含委派 codex，契约随任务传递）必产 `<run_root>/<thread-id>/implementation-notes.md`（经 CONFIG 解析；**G0 trivial 修码豁免**）：
- **撞上迫使偏离计划/规格的边缘情况 → 选保守路径 + 记一条 + 继续干，不停下问**：`[D-n] 撞到什么｜保守选择｜为什么｜疑似类(A–E?)`。
- **零偏差也必写一行 `no deviations`**——空态是信息（计划没弯），缺态是盲区（verify 把"缺文件"当发现上报，不当通过）。
- 实现者只标"疑似"分类，**终判在 verify 对账**（§3 A–E 规则原样适用；产者可猜、不可判）。
- 消费：verify / explore-full 的对账逐条终判（Deviation 天然是 B 规格空白/C 意图变/E 品味的候选）；retro 把"同类 Deviation 跨 run 重复"作复发信号。
