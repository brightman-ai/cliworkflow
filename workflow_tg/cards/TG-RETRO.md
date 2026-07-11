# TG-RETRO — 元教训蒸馏入库（教训飞轮的"捕获腿"）

> 环节：`/cw-retro <scope>`。把本 session 被**独立视角**（对抗 diff / 冷 agent 实测 / 人挑战 / lint）抓到的**复发设计/实施错**，蒸馏成结构化条目入 `WF-TG-META-LESSONS.md`，让下次**自动浮现、不再重犯**。
> 先读 `WF-TG-META-LESSONS.md`（看现有条目去重）+ `WF-TG-GUARDRAILS.md §6`。

## 何时用
- session/里程碑末、或 `/cw-handoff` 顺带触发；或发现"这个错好像犯过 ≥2 次"。
- **地图审计触发**：**模型升级** 或 **惊讶输出**（AI 做了"合理但错"的事=给它的上下文有缺口）→ 顺带审计相关卡/skill/CLAUDE.md：缺口回写；脚手架二分——`补模型短板型`（模型升级后=死重，候选删）vs `任务本质型`（永留），别凭感觉删。
- **不是日常提醒**（日常靠 META-LESSONS 在矩阵¹命令载入时按 `trigger` 自动浮现的"默认腿"）；retro 只做**捕获入库**。

## 批量审计模式（跨 session 使用质量审计 — 路 B 的多 session 版）
- 触发：Human 明说"审计最近 N 周使用/复盘命令使用质量"；或地图审计触发（模型升级/惊讶输出）需要跨期证据时。
- 流程：① `bin/tg-transcript-slice` 把近 N 周含 cw-* 调用的主会话切成调用窗口摘要（Human 原话保真、助手文本截断、工具调用留标记）→ ② 按项目/体量分给 N 个**干净 context 子 agent**（切片/预筛可低档模型，审计判读用高档），每个对照 step card 逐会话核纪律 + **逐字摘 Human 纠偏原话** + TOP 改进候选（频次×严重度 + 证据锚）→ ③ 合并去重，照常走写回门（流程 2–6）入库，卡片修订建议提炼成判断点交 Human 拍 → ④ 产物落 `<run_root>/<thread-id>/`。
- 附带度量：**本期零触发的护栏清单**（模型升级后的"补短板型脚手架"候选删项——凭跨期数据定删留，不凭感觉；见"何时用"的脚手架二分）。
- DONE-WHEN 适配：批量模式以 `<run_root>/<thread-id>/` 下的**切片摘要目录 + 各批审计报告 + 合并结论**替代单 session 的 `retro-scan.json`（等价路 B 证据，其余门照常）。

## 输入（多路外部证据，禁纯自评）
**双路合并**为核心：**① 本 context 综合**（AI 当前对教训的理解=原则/为什么；但有自述偏差 + 压缩丢失）+ **② 本 session transcript**（客观记录=用户挑战 / codex 发现 / 反复犯的错 + 复发计数，抓 context 漏掉的盲区）。再叠 **③ 客观产物（`git diff` + test/lint artifacts）** / 冷 agent 实测 / 现有 codex review 文档。**禁纯自评**——self-critique 说"有问题"不算（fake-done 同源，TGL-01），必须有 ②③ 这类外部信号佐证。

## 流程
1. **觉察（双路合并 — 别只靠 context 自述）**：
   > ⛔ **硬门：路 B 必实跑，跳过 = fake-retro（TGL-01），不算做了 retro**。路 A 只是线索、路 C 只是佐证；**复发计数 + "context 没察觉的盲区" 只能由路 B（派干净子 agent 扫 raw transcript）客观产出**——这正是 retro 的核心价值，省了它整条命令空转。
   > **防跳过自检（入库前必答）**：我是不是"凭 context 就把教训总结完、没派子 agent 扫 transcript"？是 → 停，那是 fake-done（把"我已知的外部证据片段(live测试/Witness)"误当"独立扫描"）；回去补跑路 B。路 C 的 test/Witness artifacts ≠ 路 B 的独立 transcript 扫描。
   - **路 A · context 综合**：从当前上下文提炼"学到了什么"（原则 / 为什么）。快，但**易自述偏差、压缩丢失**（context-only = 易 fake-done）；**路 A 单独 ≠ retro**。
   - **路 B · transcript 扫描（客观外部证据，核心 · 必跑）**：
     - **定位**：优先用 **harness 给的 transcript 路径**；否则 `harness 提供的 transcript 路径（claude: ~/.claude/projects/… · codex: ~/.codex/sessions/…）` 取**当前 session id**（或最近修改的 .jsonl）；**不确定向 Human 确认，别扫错 session**。
     - **先预筛再喂子 agent**（别直灌整个大 JSONL）：先 `rg`/`grep` 抽命中段（用户挑战 / `BLOCKER|MAJOR` / 反复 pattern / `error|fail|又犯`）→ 派**干净 context 子 agent** 处理命中段（避 overflow + 绕主 AI 偏差），返回**结构化 `{错误类, 复发计数, 证据锚(行号/时刻)}`**。
   - **路 C · 客观产物（佐证）**：本 session `git diff`（实际改了啥）+ test/lint artifacts + **run-dir 偏差日志**（`implementation-notes.md`，GUARDRAILS §8——**同类 Deviation 跨 run 重复 = 客观复发信号**）——佐证某教训是否真落地 / 真复发。
   - **合并交叉**：**两路都中**（AI 察觉 ∧ transcript 复发）= 高置信，录；**仅 transcript 中、context 没察觉** = **最该录的盲区**（如本 session 反复犯 TGL-02 自己不自知、靠 codex 才抓）；**仅 context 自评、transcript 无据** = 疑自述/fake，降级不录（TGL-01）。
   - 再叠 lint（各 `guard.test` grep）+ 现有 codex/review 文档；数 recurring（同类 ≥2 次）。
2. **去重**：对照 META-LESSONS 现有条目——已有则只更新证据锚/status，别新增重复。
3. **写回门**（同 browser-skill）：逐个问"**下一个设计者/agent 会踩同坑吗?**" YES **且能绑可自动核查的防御** → 写；NO 或防御无法核查 → 不写（不注水、不写操作日记）。
4. **蒸馏**成条目：`id ｜ 一句话 pattern ｜ trigger(何时浮现) ｜ guard.test ｜ status:active` + 正文(症状/最简处方/边界/证据锚)。**`guard.test` 必须机器可核查(grep/lint) 或挂外部验证(Witness/codex/测试)**。
5. **保存（两级）**：**框架通用教训**（适用任何工程/任何 tg 用法）→ 全局 `~/.cliworkflow/workflow_tg/WF-TG-META-LESSONS.md`（**新 id=`TGL-<YYYYMMDD>-<slug>`、禁顺序号、遗留 `TGL-01..09` 保留**；**多机 merge-safe 完整协议**——生成前 grep 去重 + 写前 `git pull --rebase` + push 被拒重跑 §Lint L9——**见 META 头"多机互不冲突更新"单源,勿在此复述**）；**项目专属教训**（某工程实例特有，如某工具 gotcha）→ 该工程 `docs/.tg/lessons/<YYYYMMDD>-<slug>.md`（**每条一文件**，并发安全：多会话写不同文件不互相覆盖；名=日期+描述 slug 可读可排序；**同日同 slug → 原子创建失败自动追加 `-2`/`-3`**；随软链跨 project 共享）。拿不准属哪级 → 先存项目级；**复发于多工程 / 证明通用 → 晋升到全局**。
6. **应用/传播**：把新 `guard.test` 的 grep 加进 lint；若教训能固化成结构约束，**顺手改受影响的卡/模板/命令**（防 TGL-02 不完整传播——别只录不修）。

## DONE-WHEN
- ■ **路 B 已实跑（硬门，否则 fake-retro）**：prefilter 命中文件存在 + 干净子 agent 返回结构化 `{错误类, 复发计数, 证据锚}`，**结果落 `<run_root>/<thread-id>/retro-scan.json`**（机器可解析、可 resume，不只粘对话）。**纯路 A/C + 自评 = 不算完成，回去补跑路 B**。
- 复发错已成结构化条目入库（带可自动核查 `guard.test`）；已跑 §Lint 全部条目（含 L9 id 唯一性 + L10 载 META 列对齐）扫全四层确认当前无残留；新 grep 进 lint。
- **本轮自度量**（矩阵⁴，度量 retro 产真教训还是注水）：产出 `{recurring_found, recorded, deduped, gate_rejected, promoted}`。

## 纪律
- **只录外部证据抓到的**（对抗/实测/人挑战/lint），不录纯自评臆想。
- **写回门把关防注水**：只写"会复发 + 有可核查防御"的；不写一次性琐事。
- 条目 ≤1 屏；`status` active→mature→retired 防膨胀。
