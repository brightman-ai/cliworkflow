# WF-TG-META-LESSONS — 反模式登记册（设计/实施元教训）

> workflow_tg 的"教训飞轮"持久层。同构自家 **browser-skills**（"下个 Agent 会踩同坑吗?YES→写最简处方；不写日记"）。落实 `WF-TG-GUARDRAILS.md §6` 反模式登记册护栏。
>
> **两级存储**：**本文件 = 框架通用教训**（任何工程通用，如下 8 类）；**项目专属教训**（某工程实例特有）存该工程 `docs/.tg/lessons/<YYYYMMDD>-<slug>.md`（**每条一文件**，并发安全 + 可读可排序；随 docs 软链共享）——复发于多工程 / 证明通用时由 `/cw-retro` **晋升**到本文件（本文件=低频/人审/单写的策展索引，故单文件可接受）。
>
> **多机互不冲突更新（multi-machine merge-safe）**：① **ID 防撞键**——新框架条目 `id = TGL-<YYYYMMDD>-<slug>`（日期+描述，可排序可读，遵"禁顺序号当主标识"铁律、对齐项目层）；**生成前 `grep` 现有 id 去重，同日同 slug → 追加 `-2`/`-3`**（单文件无原子创建，靠 grep+tie-breaker 保唯一，**不赌"天然不撞"**）；**`TGL-01..09` = 遗留短号 grandfather 保留**（卡/design 概念引用，勿重编号）。② **写前 rebase 操作序列**——`git status --porcelain` 须净 → 确认 branch/upstream 存在 → `git pull --rebase` → 编辑+grep 唯一性 → push；**push 被拒 → 再 `pull --rebase` 后重跑 §Lint L9 唯一性检查再 push**。③ **冲突非静默**——两机同时晋升:两条 append 都落索引表尾+EOF 正文 = 相邻区 → git **冲突浮现**（非静默），人手保留两条；若撞同 id → 补 `-N`（索引行无序可重排，正文各段独立）→ 不丢条目。④ **§Lint L9 机器复核** id 唯一+格式合法（见下 Lint 块；rebase 后必跑）。项目层（一条一文件）天然零冲突。
>
> **怎么用（关键，否则又变没人读的死文档——ng 的登记册正因此沉睡 4 个月）**：
> 1. **载入时索引表必读**（在矩阵¹命令的加载链中即必读、~1 屏；**非每命令载**——载哪些命令见 ORCHESTRATOR §2.2 矩阵¹）；命中某条才读其正文。
> 2. **自动浮现（复制 browser-skill 的 `skill_hint`，最关键）**：authoring 卡/命令/design、`/cw-experience-verify` 对账 A–E、`/cw-change`·`/cw-spec` 开场时，**按 `trigger` 列自动捞匹配条目注入自检**——**不靠人记得查**。
> 3. **评判挂外部证据**：`guard.test` 必须**机器可核查(grep/lint)** 或 **独立验证(Witness/codex 对抗 diff/测试/冷 agent)**——**禁纯自评**（自评"做了"≠真做到 = fake-done 本身，TGL-01）。
> 4. **入库门**：只"曾发生 + 会复发 + 能绑可自动核查的防御"才登记（经 `/cw-retro` 写回门）。
> 5. **防膨胀**：`status` active → mature（连续 N 次自检不触发→只留结构检查）→ retired。

## 索引表（矩阵¹命令的加载链含此表 · 载入必读这张 · 命中才翻正文）
| id | 反模式（一句话） | trigger（何时自动浮现） | guard.test（机器/独立核查） | status |
|----|---------------|----------------------|--------------------------|--------|
| TGL-01 | **fake-done**：看似做了实际没做到（指针假深 / 术语假定义 / 蒸馏丢门控 / 自评说做了）| 任何 card·design authoring · /cw-retro | 独立验证(冷 agent/codex/测试)非自评 + 自检"零上下文 AI 只凭此卡能做到位吗?" | active |
| TGL-02 | **不完整传播**（fix-one-place-not-all-N）：改原则只改一处，同类违规活在另几层 | 改任何 card/command/design/template 后 | grep 旧 pattern 扫**全四层**，应 0 残留 | active |
| TGL-03 | **自包含被指针破坏**：卡指向外部"方法论/重型框架"获取深度→零上下文不读→能力落空 | card authoring | §Lint L3（cards 无"去读方法论"指针）= 0 | active |
| TGL-04 | **未定义术语**：裸用框架本体缩写 | card/template authoring | §Lint L4（cards/templates 无裸术语）= 0 | active |
| TGL-05 | **per-project 泄漏/特殊处理**：通用层指向工程专属制品 / 把项目实现当方法权威 | 改 ENGINE/CONFIG-TEMPLATE/experience 卡命令 | §Lint L5（操作层无 playbook 权威/witness_actor 指针）= 0 | active |
| TGL-06 | **持久化硬编码**：路径没经 CONFIG 解析 | 任何写路径的卡/命令/模板 | §Lint L6（路径命中须在"经CONFIG/默认/示例"语境）| active |
| TGL-07 | **死规则代替判断**：用"禁止 X"而非"不强制 X + 何时升级" | card 纪律 authoring | 人审 + 自检"这是该用判断的地方吗?" | active |
| TGL-08 | **设计内容泄漏进产出**：出处/研究/分析路径/质量下限写进卡 | card authoring | §Lint L8（cards/commands 无 design 指针/出处）= 0 | active |
| TGL-09 | **authoring 绕过自动浮现**：直接改框架文件(非走 tg 命令)→ META 不浮现 → 已知教训不被应用 → 复发（含 fix 漂回）| 改 `workflow_tg/` · `commands/cw-*` 后 | 改完跑 §Lint 全部条目 + 对账上一轮已修 pattern 未回退 | active |
| TGL-20260620-llm-toggle-live-proof | **LLM 行为开关靠 prompt 声明 ≠ 生效**：尤其"关态/否定约束"会被模型无视(temp>0 概率性) | 改/加 LLM provider 的行为开关/约束 prompt · `/cw-experiment` 验证态 | 该开关有 live 测试且多跑(≥3)验稳定 + 关态加显式反例 + temp0；自评不算(挂测试) | active |
| TGL-20260620-async-finalize-on-signal | **异步收尾处理由用户动作触发→丢末段**：收尾(整理/汇总/保存)绑 stop/点击，但末段异步事件晚于动作落地 → 处理残态丢数据 | 实现"录完/发完/算完后做 X" · `/cw-experience-verify` 完整性对账 | 收尾绑底层终态信号(.idle/done event)非用户动作 + 对抗复测末段完整性断言 | active |
| TGL-20260621-design-overrotate-to-complex | **设计偏置：默认往自动/强制/复杂漂 + 被否后过度摆到对立极端**（不先收敛最简可行，违 §A.4）| tg authoring / 提方案·选机制时 · `/cw-design-review` · `/cw-retro` | 独立 review(冷 agent/codex/人/大厂证据)非自评 + 自检"有更简的 Human 主动/手动版吗?"；被否后对照原意图+≥2 源再定，别单源甩到另一极端 | active |
| TGL-20260621-diagnostic-visibility-first | **不透明集成静默失败时盲修——没先"让失败开口"**(返成功但无产出/静默 no-op → 反复猜修而非取错误可见性);"2次失败"退化成"宣布硬墙 defer 给人"| 第3方/native/不透明边界"返成功但无预期产出" · `/cw-experience-troubleshoot` · 连续2次 edit→rebuild 同边界 observable 未变 | 行为/外部 guard(非静态 lint):同一不透明边界连续修 observable 未变 **≥2 → 必做可见性动作**(verbose build/全功能工具带 stderr/最小 repro/符号依赖检查),**非第3次盲修、非 defer**;复用资产=潜在缺陷 hypothesis#1 | active |
| TGL-20260621-design-code-divergence | **设计/规格声明的修法只活在文字,代码背离**(doc-only 不变量:声明"已实现"但代码做反/没建);self-mark ✅ 在结构上不可能交付的代码 | 声明"已实现设计修法"前 · `/cw-design-review` 前置 · spec 有 load-bearing 不变量时 | 每条 load-bearing 不变量 → **机械 grep 证代码强制/不违反**(如"扩展禁调 RimeStartMaintenance"→ `rg` 在扩展 target 应空);完成前必跑,早于 LLM review | active |
| TGL-20260621-task-state-oracle-binding | **任务状态机被过早标 `completed`(未绑 oracle)→ 污染下一 agent 继承的状态 → 成下轮 over-claim 源头**(比报告 fake-done 更隐:状态会持久+跨 agent 传)| `TaskUpdate completed` / 自标 ✅ / handoff 状态清单 / 实现型任务收尾 | `completed` **必须能指向该条目的 oracle 证据**(runtime/test/Witness);否则只能记 `implemented`/`build-green`/`pending-verification` —— 状态≠验过 | active |
| TGL-20260711-network-exposure-gate | **扩大网络可达面未核门控**：tunnel/端口/反代/分享链接把无鉴权服务暴露公网 | 变更含 tunnel·端口暴露·反代·分享链接·EnableNetwork 类开关 · spec/change 涉网络面 | 该变更输出必含"目标服务门控现状"一行(有/无 auth + 依据)；无门控 → G3 停等 Human；缺此行=未过门 | active |
| TGL-20260711-defensive-attribution | **防御性归因**：用户报 bug 先辩"非我改的"，读证据在后，被打脸 | 用户报"是不是你改出了bug/又坏了" · 新报障归因时 | 归因结论必须与证据(用户复现/git diff/实测)**同条消息**；无证据只能答"先查"——transcript 抽查"非我"句均带证据 | active |
| TGL-20260711-tool-capability-misjudge | **工具能力误判**：grep 截断的 help 没命中就断言"不支持"，转身走更脏绕行 | 宣称某工具缺能力 / 据此降级绕行前 | "不支持"断言必附 help/README 证据行；无证据按 ○ 且先疑用法(§A.7②) | active |
| TGL-20260711-ssot-search-exhaustion | **SSOT 检索止步第一命中**：已有实现被判"不存在"→另起炉灶/建新仓/让用户拍已成立的决策 | 下"不存在/需新建/建新仓"结论前 · 决策拍定前 | 结论须列已扫同义词族(中英+缩写)+目录 ls 证据；每个待拍决策先答"现状是否已满足" | active |

## Lint（可复制直接跑，cwd = `~/code/claude_remote`；`grep -rn` 才能扫目录）
```bash
# L3 自包含被指针破坏 (应空)
grep -rnE '可选读|去读.*方法论|见 workflow_ng' workflow_tg/cards/
# L4 未定义术语 (应空)
grep -rnE 'EU/IU|IU/TU|\bDDC\b|\bBRR\b|\bTDN\b|Ontolog' workflow_tg/cards/ workflow_tg/templates/
# L5 per-project 泄漏 (应空; 操作层 = cards + experience 卡 + tg 命令, 排除 design/)
grep -rniE '权威 playbook|复用其.*成熟机器|witness_actor:' workflow_tg/cards/ workflow_tg/experience/ commands/cw-*.md
# L6 持久化硬编码 (命中须在 经CONFIG/默认/示例 语境, 否则违规)
grep -rn 'docs/product\|docs/\.tg' workflow_tg/cards/ commands/cw-*.md
# L8 设计内容泄漏进产出 (应空)
grep -rnE 'docs/analysis|ARTICLE|design/TG-' workflow_tg/cards/ commands/cw-*.md
# L9 id 唯一性+格式 (多机防撞; grandfather TGL-01..09 | 新 TGL-<8位日期>-<slug>[-N]; 禁新顺序号)
ids=$(grep -oE '^\| TGL-[0-9a-z-]+' workflow_tg/WF-TG-META-LESSONS.md | sed 's/^| //')
echo "$ids" | sort | uniq -d                                   # 重复 id (应空)
echo "$ids" | grep -vE '^TGL-(0[1-9]|[0-9]{8}-[a-z0-9-]+)$'    # 非法格式/新顺序号 (应空)
diff <(echo "$ids" | sort) <(grep -oE '^### TGL-[0-9a-z-]+' workflow_tg/WF-TG-META-LESSONS.md | sed 's/^### //' | sort)  # 索引↔正文对齐 (应无差异)
# L10 命令载 META 与 ORCHESTRATOR §2.2 矩阵¹列对齐 (机器核查"语义传播",治 B1/TGL-09 根因;矩阵改→同步本表)
for c in spec change experiment design-review experience-explore-full experience-troubleshoot experience-verify retro; do grep -q META-LESSONS commands/cw-$c.md || echo "缺 META(矩阵¹=✓却没载): cw-$c"; done   # 应空
for c in clarify brainstorm think experience-distill-baseline init; do grep -q META-LESSONS commands/cw-$c.md && echo "多余 META(矩阵¹=–却载了): cw-$c"; done   # 应空
# L11 偏差日志契约传播齐 (GUARDRAILS §8 单源; 产出方 spec/change 卡+命令 + 消费方 verify/explore-full 卡+命令 + 总纲 + 产物表; 应空)
for f in workflow_tg/WF-TG-GUARDRAILS.md workflow_tg/WF-TG-CONVENTIONS.md workflow_tg/WF-TG-00-ORCHESTRATOR.md workflow_tg/cards/TG-SPEC.md workflow_tg/cards/TG-CHANGE.md workflow_tg/cards/TG-EXPERIENCE-VERIFY.md workflow_tg/cards/TG-EXPERIENCE-EXPLORE-FULL.md commands/cw-spec.md commands/cw-change.md commands/cw-experience-verify.md commands/cw-experience-explore-full.md; do grep -q "implementation-notes" "$f" || echo "缺偏差日志契约: $f"; done
for f in workflow_tg/cards/TG-EXPERIENCE-VERIFY.md workflow_tg/cards/TG-EXPERIENCE-EXPLORE-FULL.md; do grep -qE '(终判|消费)' "$f" || echo "消费方缺终判语义: $f"; done   # 消费方角色核查(布尔 tripwire 非语义证明,同 L10 口径)
# L12 caveman 已删负优化规则防漂回 (20260705 修正: 自造缩写/箭头省字推荐已删; 应空)
grep -nE '缩写常见词|因果用箭头|用箭头表因果|箭头表因果' commands/cw-caveman.md workflow_tg/design/TG-CAVEMAN.design.md
# L13 命令入口文件存在性 (防改名遗留死链, 20260711 router 曾指 tg-*.md 不存在文件; 应空)
for c in think clarify brainstorm spec change experiment design-review experience-explore-full experience-troubleshoot experience-verify experience-distill-baseline init retro caveman handoff goal-draft; do [ -f commands/cw-$c.md ] || echo "缺命令文件: cw-$c"; done
```
（TGL-01/02/07 靠独立验证/人审，无机械 grep；TGL-02 = 改完跑全部 Lint 条目扫全四层；**L9 = 多机 id 唯一性,rebase 后必跑；L10 = 仅核查"载 META"布尔列(矩阵¹)对齐 —— CONFIG/run_root/method_effect 列目前靠人审对照矩阵、未机械门(别当全矩阵已机械核查),加/改命令必跑；L11 = 偏差日志契约六文件传播(GUARDRAILS §8 单源)；L12 = caveman 负优化规则勿写回**。）

## 正文（命中某 id 才读 · 每条：症状 / 最简处方 / 边界 / 证据锚）

### TGL-01 fake-done（根类——多数其它条是它的具体形态）
- 症状：声称完成但未真达。深度靠指针(看似深)、术语裸用(看似定义)、蒸馏成 checklist(看似忠实却丢硬门控)、self-critique 说"做了"。
- 处方：**评判挂外部证据**（独立 Witness / codex 对抗 diff / 测试 / 冷 agent 实测），**禁纯自评**；自检"给一个零上下文、没读过任何设计文档的 AI，只凭此卡能做到位吗?"过不了=fake-done。
  - **子形态:完成声明绑弱 oracle**(20260621 voicemore 复发3次)——"🏁完成"绑 BUILD 绿/单测过,而非 **DONE-WHEN 当初设定的用户场景 oracle**。处方:`完成/达成/通过` 声明**必须复述用户原话场景 + 同条消息引一个跑通该场景的 runtime 证据**(如"五笔打字出候选+上屏"→引 UITest/自检 artifact),否则不许出"完成"词。本例 3 次过早🏁全靠 **Stop-hook**(外部)抓、非 §A.5 自检 → 框架须把它焊进默认门(见 GUARDRAILS §5"完成=场景 oracle")。
- 边界：聪明 agent 单次会自补，但下限不保证——护栏为的是普通/不同 agent 的可靠下限。
- 证据锚：本 session think 指针假深；7 步蒸馏丢框架 ~70%；brainstorm 静态菜单看似脑暴不收敛。**20260620 voicemore /cw-retro**：只做路 A(context)+路 C(产物/test/Witness)，**跳过路 B 独立 transcript 扫描**，把"已知的 live测试/Witness 片段"误当"独立扫描"就宣称 retro 完成——**用户挑战才抓**(非自查)；根因=TG-RETRO 卡无路 B 硬门，已修(路 B 升 DONE-WHEN 硬门 + 防跳过自检)。**元盲区：自查系统性漏"流程本身缺了一步"**(路 B 子 agent 提示)。

### TGL-02 不完整传播
- 症状：在一处（卡）修好原则，同类违规仍活在命令包装层 / 模板 / 总纲 / 别的卡。
- 处方：改原则后**必跑关键词 lint 扫全四层**（design/card/command/template），不只改你手上那层。
- 证据锚：CONFIG 解析铁律进卡但 orchestrator/模板还硬编码；actor 零专属进 CONFIG-TEMPLATE 但 experience 卡命令还写"权威 playbook"。**本 session 经 /cw-retro 双路确认：跨 codex review 5 轮复发、transcript 175 次提及——根因见 TGL-09（authoring 绕过自动浮现）**。**20260620 第7次**：加多机 merge-safe 改了 registry/card/command/design/GUARDRAILS 5 处却**漏 `WF-TG-CONVENTIONS.md`**（并发分类表仍"全局低频单写 OK"旧口径）+ §Lint 缺 id 唯一性——codex 对抗审抓出（我 grep 传播只扫手上 5 文件未含 CONVENTIONS）；兼属 TGL-01（声明"天然不撞键"却无 tie-breaker 机制=fake-done）。**教训:传播枚举须含"命令加载链读到的所有文件"(此处 cw-retro 读 CONVENTIONS),非只改你正在编辑的那几个**。**20260621 第8次**：造 `/cw-design-review` 命令时,CONFIG 加载链没传播到 `ORCHESTRATOR §4`(仍写"experience 系命令"漏新命令)——**codex R1 抓**(我 §Lint grep 过了、9 分派点也查了,但 §4 那行是**语义传播、grep 扫不到**)。坐实:**明知 TGL-02 在册仍在新产物重犯;§Lint grep ≠ 语义完整性,新命令/新能力 authoring 必叠 codex 语义审**(见 [[TGL-20260621-design-overrotate-to-complex]] 同源:自评看不见自己的盲区)。**20260705 第9次**：加偏差日志能力,自查含 TGL-02 意识+L11 机械门全绿,codex 仍抓 6 处语义洞(spec/explore-full 命令包装、explore-full 卡 DONE-WHEN、总纲实现句/矩阵 cell/G1G2 序列)——**"必叠 codex 语义审"处方再次自证**(证据:`docs/.tg/work/20260705-014316-tg-unknowns-loop/reconcile.md` §四)。**20260711 环境层同型**：context-mode 规则 6-20 清了 HOME+settings 源头,**漏 5 个工程级部署副本**(stwork/zstock/sembr/automation/你的项目-terminal)继续污染全部工作会话 21 天——传播枚举须含"规则的所有部署副本"(各工程 CLAUDE.md),非只改源头(证据:`docs/.tg/work/20260711-132818-tg-self-evolution/structural-review.md`)。

### TGL-03 自包含被指针破坏（depth-NOT-by-reference）
- 症状：卡说"去读某外部方法论/重型框架获取深度/系统性"。零上下文 AI 不会读 → 能力落空。
- 处方：方法**写死在卡内的具体动作**；外部框架的深用**白话蒸馏进卡**，不留指针。
- 证据锚：cw-think 曾写"如需更系统的深钻可选读 workflow_ng"。

### TGL-04 未定义术语
- 症状：裸用 EU/IU/TU、DDC/BRR、TDN、Ontology 等框架本体名。
- 处方：白话替换或就地定义；design 文档首用须 gloss。
- 证据锚：think/brainstorm/clarify 卡曾裸用，已清。

### TGL-05 per-project 泄漏 / 特殊处理
- 症状：通用层（ENGINE/卡/命令）指向工程专属制品（actor/playbook 文件），或把某项目实现当方法权威。
- 处方：**通用层零专属**；专属只进 CONFIG 数据；方法权威永远在通用 ENGINE/ACTOR。
- 证据锚：CONFIG witness_actor 指 你的项目 actor；experience 卡"你的项目 复用成熟机器"。

### TGL-06 持久化硬编码
- 症状：直接写 docs/product / docs/.tg/work，未经 CONFIG 解析。
- 处方：路径一律 `<long_term_root>/<scope>/...`(基目录经 CONFIG)；默认值须标"示例/经 CONFIG"。
- 证据锚：spec/change/模板曾硬编码；long_term_root 含 scope 致双 scope。

### TGL-07 死规则代替判断
- 症状："禁止 X" 用在本该用判断的地方，挡住自然的好做法。
- 处方：给"不强制 X + 需要时可做 + 何时升级"，而非硬禁（判断优于死规则）。
- 证据锚：brainstorm 曾"禁止深挖第一性"→改"不强制"。

### TGL-08 设计内容泄漏进产出
- 症状：把出处/研究/分析文件路径/"质量下限≥某文档"写进命令卡。
- 处方：出处/rationale 只进 design 文档；卡自包含、可移植。
- 证据锚：clarify 卡曾引 ARTICLE/P4/docs-analysis 路径。

### TGL-09 authoring 绕过自动浮现（为什么明知 TGL-02 仍反复犯 — 本 session /cw-retro 首跑捕获）
- 症状：META 自动浮现焊在 tg **命令**(spec/change/对账)入口；但**直接编辑框架文件(cards/commands/design/templates)= authoring、不走 tg 命令** → META 对 authoring **不浮现** → 明知某教训仍反复犯（含"修别处时把已修的又写回"= fix 漂回）。
- 处方：**改 `workflow_tg/` 或 `commands/cw-*` 后，把"跑 §Lint 全部条目 + 对账上一轮已修 pattern 没回退"当收尾硬步骤**（authoring 无命令级自动浮现，靠这条手动 gate 补）。
- 边界：tg 命令路径已有自动浮现；此条专补 authoring 缺口。
- 证据锚：本 session（/cw-retro 双路扫 transcript 客观确认）TGL-02 跨 codex review **2/3/4/5/6 五轮**复发、transcript **175 次**提及；review5 出现"修别的时把 ng hard-route 写回"(fix 漂回)。**= context-only 反思没 crisp 抓到、路 B/C 客观计数才逼出的盲区（双路合并价值的活样本）**。

### TGL-20260620-llm-toggle-live-proof  LLM 行为开关靠 prompt 声明 ≠ 生效
- 症状：给 LLM 加"行为开关/约束"(开/关某种改写)，prompt 里写了规则就当生效；尤其**"关态"=否定约束**("不要改写"/"原样保留")，模型在 temp>0 时会概率性无视、自作主张"帮忙"。
- 处方：① 该开关**配 live 测试且多跑(≥3)验稳定**(单次过≠稳)；② **关态/否定约束加显式反例**("禁止把 A 合并成 B，必须保留为 A")；③ **temp=0** 压随机；④ 评判挂测试**非自评**(self-claim "prompt 写了"=fake-done 同源 TGL-01)。
- 边界：开态(主动做某事)通常 prompt 即生效；难的是关态/约束。
- 证据锚：voicemore 多级精炼 L4 语义校准——关态测 `testSemanticCalibrationOffPreserves` live **首跑失败**(模型仍把"明天,不,后天3点"合并成"后天3点"，违背关态)；加反例+temp0 后 3/3 稳定。= live 测试(外部证据)抓的，非自评。

### TGL-20260620-async-finalize-on-signal  异步收尾处理须由终态信号触发，非用户动作
- 症状：流式/异步管线里，"收尾后处理"(整理/汇总/保存/精炼)绑在**用户动作**(stop 按钮 / `isRecording=false`)上触发；但底层**末段异步事件**(最后一段识别/最后一帧)常**晚于**用户动作落地 → 收尾跑在**残态**上 → **丢末段数据**(且若残稿被锁定为展示源，后到的完整稿被陈旧值盖)。
- 处方：收尾绑**底层终态信号**(引擎 `.idle`/`done` event/流真关闭)，**不绑用户动作**；展示源用"完整稿优先"且后处理产物等终态再算。验：**对抗复测末段完整性断言**(喂含尾段的样本→断言尾段词仍在)。
- 边界：同步管线无此问题；只在"用户动作 ≠ 数据终态"的异步场景。
- 证据锚：voicemore 聊天消息整理后**丢半条**(refine 跑在 `stop()` 后、末段 final 落盘前，refinedText 锁残稿，displayedText 优先陈旧值)——**独立 Witness 截图抓出**(非自查)；改 `.idle` 触发 + UITest 尾段断言修复+复测过。**同根因 session 内复发 5 次**(路 B 独立扫 transcript 客观计数)：recoverInto 丢 pending 音频 / stop 400ms 竞态 / finish 握手竞态 / stop 末段→`.idle` / 聊天丢尾——被按严重度(中/低/debt)打散成 5 个零散 bug，**根因同一**(同步态置位 ≠ 异步资源真收束)；= 路 A(context) 漏看根因复发、路 B 客观计数才逼出的盲区。

### TGL-20260621-design-overrotate-to-complex  设计偏置：默认往复杂/自动漂 + 被否后过度摆到对立极端
- 症状：设计/选机制时默认偏向"更强机制=自动/ambient/强制/重",而非最简 Human 主动/手动版(违 §A.4 最简可行)；且**一旦方案被 review 否掉,过度摆到对立极端**,而非收敛到最简可行点。
- 处方：① 提任何机制前先自问"**有没有更简的 Human 主动/手动版能达到 80%?**"(最简可行优先,复杂度按需加)；② **被否后别过度修正**——回原意图 + 对照 ≥2 独立源再定新方向,别凭单一 reviewer 一句话(如"物理>行为")甩到另一极端；③ 评判挂**独立 review**(冷 agent/codex/人/大厂证据),自评看不见自己的偏置。
- 边界：真需强机制(硬安全/不可逆)该用强机制；此条防"无触发条件就往复杂漂"的默认偏置。
- 证据锚：本 session(/cw-retro 路 B 客观扫 transcript)设计 `/cw-design-review` **三连翻转**：v1"A+C 实现后 auto-spawn"→ opus 抓"重建 [[TGL-09]] 的 ambient 绕过洞"→ **过度修正成"机器 hook 为主"**→ 用户挑战"为何不能 Human 主动调"+ 大厂证据("自动全量=affirmation theater")→ 落回**用户最初的 Human-invoked 简单方向**。三跳**全靠外部纠**(opus/用户/大厂),主 AI 自身从未先收敛最简。= 主 AI context 内最没自觉的盲区,路 B 才逼出(同 [[TGL-01]] 自评盲)。

### TGL-20260621-diagnostic-visibility-first  不透明集成静默失败时,先"让失败开口"再修(别在雾里直冲)
- 症状：第3方/native/不透明边界(librime/C 库/跨进程/构建链)**返成功但无预期产出 / 静默 no-op / 空输出**;AI 反复**猜假设-打补丁**(换参/换调用/换线程/换链接旗标…),每次都赌"这次原因对了",但**没一次去让真错误显形**。复发尾声常退化成"2次失败→宣布硬墙、defer 给人"。
- 处方：① **2次失败硬规则改向**——同一不透明边界连续 2 次 edit→rebuild **observable 未变** → 第3个动作**必须是可见性动作**(verbose/debug build、把操作搬到**有 stderr 的全功能工具/平台**跑、最小 repro、`nm`/依赖/符号检查、降 log level 找真日志),**不是第3次盲修、更不是 defer**。② **复用资产=潜在缺陷**:复用带已知缺陷工程的资产时,"那个缺陷可能就在我复用的东西里"是 **hypothesis #1 先证伪**,别先围着它重构架构。③ §A.7#2 实战版:"是工具不支持还是用法/数据不对"——后者远多,先取可见性才分得清。
- 边界：透明、错误已可见的失败照常修;此条专治"静默 no-op + 盲猜螺旋"。
- 证据锚：本 session(路 B,带时间戳)librime dict 编译静默 no-op → **12 种盲试/34 分钟**(schema_list/ad-hoc签/full-deploy/big-stack-thread/prebuild/deploy_schema/force_load…)全"返 true 无产出";**装 brew librime 跑 macOS `rime_deployer`(有 stderr)→ 2 分钟一击命中真因**(rime-data 缺 `pinyin.yaml`/`symbols.yaml` 依赖致 schema build 永远失败)。真因(数据不全)在**复用的旧 rime-data 里**,旧工程"五笔点不动"同源(17 提及却没当 hypothesis#1)。决定性动作开局即可用。挂外部证据(工具 stderr/Stop-hook 逼持续),非自评。

### TGL-20260621-design-code-divergence  设计声明的修法只活在文字,代码背离(doc-only 不变量)
- 症状：设计/spec 写了某 load-bearing 修法/不变量(如"部署移主App、扩展 load-only"),**代码却没建/做反**;AI 凭"我在设计里写了"就在 task tracker self-mark ✅,而代码结构上根本不可能交付;靠**外部 review/运行**才抓,幻影可活很久(本例 ~43 分钟)。= [[TGL-01]] fake-done 在"设计→实现"方向的具体形态。
- 处方：声明"已实现设计的修法"前(且作 `/cw-design-review` 的**前置廉价门**,而非在 review 内才发现)——把设计里每条 **load-bearing 不变量** → **一句机械 `rg`/断言证代码强制或不违反**(如"扩展禁调 X"→`rg X` 扩展 target 应空;"只有一个真相源"→生成点 grep 计数=1)。秒级脚本就能在声明时抓,把 2×LLM-review 预算留给真结构洞。
- 边界：trivial 改不必;凡设计含"必须/绝不/唯一"类不变量都该有对应 grep 门。
- 证据锚：本 session codex+opus 双审 RC1——design.md 19:14 声明"五笔修法=部署移主App+扩展 load-only",但 19:57 review 发现**扩展仍调 `RimeStartMaintenance`+`RimeJoinMaintenanceThread`、`RimeDeployer` 根本不存在**(doc-only 15×);且 T5 已 self-mark"✅五笔后台切换不冻"于不可能交付的代码。一句 `rg RimeStartMaintenance 扩展target` 在 19:20 就能抓,省 37 分钟。

### TGL-20260621-task-state-oracle-binding  任务状态机过早标 completed → 跨 agent 状态污染
- 症状：把 `TaskUpdate completed` / handoff 状态清单 / self-✅ 当"做完",但该条目的**用户场景 oracle 未验**;状态会**持久 + 被下一个 agent 继承当真**,于是上一轮的乐观状态成下一轮 over-claim 的**污染源**(比单次报告 fake-done 更隐蔽——报告会过去,状态机留着)。与 [[TGL-01]] 同根(声称≠做到),但**新机制=状态跨 agent 传**,故单列。
- 处方：任务/检查项 `completed` **必须能指向该条目的 oracle 证据**(runtime/test/Witness artifact);拿不出 → 只能记中间态 `implemented` / `build-green` / `pending-verification`,**绝不 `completed`**。Handoff 状态清单同理:每个 ✅ 附证据锚或降级标注。**状态机即 SSOT 的一部分,污染它=污染后续所有 agent。**
- 边界：纯机械/无验收语义的子步骤(如"建目录")可直接 completed;凡有"用户能用/验过"语义的条目都要绑 oracle。
- 证据锚：本 session(raw codex 一手扫 transcript)`JSONL:632` 把 spike(自动跳回,真机项)标 completed + T5 in_progress;`JSONL:791` T5/T6 completed;但 `JSONL:1577`(Stop-hook)证明综合输入/任意 app 上屏/语音 sample/页面旅程**当时全未验**。= digest 路漏掉、**raw 一手扫 TaskUpdate 事件才抓**的盲区(坐实"一手 ≠ 预筛 digest")。

### TGL-20260711-network-exposure-gate  扩大网络可达面未核门控
- 症状：实现"分享/隧道/对外访问"类功能时只抄功能半边、不核目标服务鉴权现状——零 auth 服务被公网隧道暴露,任何人拿 URL 可读写全部数据;靠用户人肉发现截停。
- 处方：任何**扩大网络可达面**的变更(tunnel/端口暴露/反代/分享链接/EnableNetwork 开关),动手前先核查并**输出一行"目标服务门控现状"**(有/无 auth + 依据);**无门控 → G3 停**,Human 知情才开(已入 ORCHESTRATOR §3 G3 触发清单,此条是它的自动浮现腿)。
- 边界：本地回环/已鉴权面的常规改动不触发;专治"可达面扩大"这一步。
- 证据锚：20260705 teamworkbench standalone——cloudflare tunnel × 零 auth,用户"没有authcode不应对外暴露"人肉截停,AI 自认"我搞砸了"(audit-M3 TOP-2,`docs/.tg/work/20260711-132818-tg-self-evolution/`)。

### TGL-20260711-defensive-attribution  防御性归因先于证据
- 症状：用户报 bug(常带"是不是你改出了bug"框架)→ 先输出"非我这轮改的"式自辩,读证据在后;被用户截图证伪(正是自己的改动所致),且自辩句反复占输出带宽。
- 处方：**归因(谁改的)服务修复路径**——读完用户证据/复现/git diff 前**禁下归因结论**;归因结论必须与证据同条消息;面对归因指控的正确姿势 = "先查证据,不能凭印象" → 自证或认账,不反射式辩护也不反射式认错。
- 边界：有现成硬证据(git log 明确)时直接给证据+结论无妨;禁的是"无证据先辩护"。
- 证据锚：20260703 UsageChip position:fixed 抢焦点——同 session"非我这轮改的"≥3 次后被用户截图证伪(audit-M1 TOP-4);正例 20260701"你说得对,得先查证据,不能凭印象"→ git diff 自证未碰粘贴链再挖真根因。

### TGL-20260711-tool-capability-misjudge  工具能力误判
- 症状：对工具(CLI/库/API)grep 了截断的 help 没命中关键词,就断言"不支持 X",转身设计更脏的绕行(hack 验证/重造轮子);用户贴出正确用法才纠正。
- 处方：下"工具不支持"断言前**全量读 help(含子命令)或 README**;断言必须**附 help 证据行**,否则按 ○ 处理并**优先怀疑用法而非能力**(§A.7② 工具域实例);要据"不支持"走绕行前——绕行成本 > 再读一遍文档,先读。
- 边界：读全文档仍无 → 断言成立(附"已读全"声明)。
- 证据锚：20260706 你的-UX-探针工具 `--user-agent` 误判不支持 → "临时强制 isInApp+还原"hack 绕行,用户贴 recipe 纠正,AI 自认"我之前 grep 没匹配到就误判不支持"(audit-M3 TOP-6);同族:你的-UX-探针工具 eval 误当 act 用(靠 memory 纠)。

### TGL-20260711-ssot-search-exhaustion  SSOT 检索止步第一命中
- 症状：检索既有实现/组件时第一个命中即收(或没命中即判"不存在")→ 另起炉灶重造(第三份组件/新仓),或让用户拍"现状早已满足"的决策;靠用户跨 session 记忆兜底纠正——用户在替系统当索引。
- 处方：下"不存在/需新建/建新仓"结论前:**穷尽同义词族**(中英+缩写,如 usage/quota/rate-limit/额度)+ 目标目录 `ls` + **先查已有共享库/组件能不能当家**;每个待拍决策先自答"**现状是否已满足**"(满足=报告事实,不上决策台)。
- 边界：确认扫过(列出所扫词族/目录)仍无 → 新建成立。
- 证据锚：rate-limit 已有 claude_quota.go/codex_quota.go,AI 搜到 useUsageReport 即停,靠用户"我咋记得做过"兜底(audit-M1 TOP-6);QR+微信遮罩已有完整实现却另起简化版(audit-M3 会话四"是不是你迁移丢了?");"Enter=换行"现状已满足仍让用户拍(audit-M1)。
