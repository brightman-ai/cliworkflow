---
description: "[TG·横切] 元教训蒸馏入库 — 把对抗/实测/人挑战抓到的复发错固化进登记册，下次自动浮现防重犯。触发: /cw-retro、'复盘入库'、'这错犯过几次了'"
---

# /cw-retro — 元教训蒸馏入库（教训飞轮捕获腿）

**角色**: Coordinator。**环节**: session/里程碑末，把被**独立视角**（对抗 diff/冷 agent/人挑战/lint）抓到的复发设计错蒸馏入 `WF-TG-META-LESSONS.md`。**不是日常提醒**（那是默认腿：矩阵¹命令载入时对账自动浮现），只做**捕获入库**。
用户输入（`<scope>`）: `$ARGUMENTS`

## 🔒 启动加载链（按顺序 Read，不可跳过）
| # | 文件 | 目的 |
|---|------|------|
| 1 | `~/.cliworkflow/workflow_tg/cards/TG-RETRO.md` | 本环节 step card |
| 2 | `~/.cliworkflow/workflow_tg/WF-TG-META-LESSONS.md` | 现有登记册（去重 + 格式） |
| 3 | `~/.cliworkflow/workflow_tg/WF-TG-GUARDRAILS.md` | §6 登记册护栏 + §4 外部证据来源 |
| 4 | `~/.cliworkflow/workflow_tg/WF-TG-CONVENTIONS.md` | lessons 落点/命名（每条一文件 + 同日同 slug tie-breaker）|
| 5 | `{项目}/docs/product/CONFIG.md`（如有）| 解析 run_root（放 retro-scan）；框架自审无项目 CONFIG → 默认 `docs/.tg/work/`（矩阵⁷）|

## 执行
按 step card：**觉察（多路合并：A context 综合 ∥ B transcript 客观复发[定位用 harness 路径/当前 session id，先 `rg` 预筛命中段再喂干净子 agent，出 `{错误类,复发计数,证据锚}`] ∥ C `git diff`+test/lint+run-dir 偏差日志佐证(同类 Deviation 跨 run 重复=客观复发信号，GUARDRAILS §8)；交叉——仅 transcript 中而 context 没察觉的=盲区最该录）+ recurring 计数**→ **去重**（对照现有条目）→ **写回门**"下个 agent 会踩同坑吗? YES 且防御可核查才写" → **蒸馏**结构化条目（`guard.test` 机器可核查或挂外部验证）→ **入库** `WF-TG-META-LESSONS.md`（新 id=`TGL-<日期>-<slug>` 禁顺序号、生成前 grep 去重 + 同日同 slug `-2`；写前 `git pull --rebase`、push 被拒 rebase 后重跑 §Lint L9 再 push——多机 merge-safe）→ **传播**（grep 加进 lint + 顺手改受影响卡，防只录不修）。**只录外部证据抓到的，禁纯自评（self-critique≠真问题=fake-done）。**
