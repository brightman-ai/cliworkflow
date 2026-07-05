# cliworkflow — 轻量自适应变更管线（cw 命令 · Claude Code + Codex CLI）

面向**探索型 UX 产品**的开发管线命令，同支持 **Claude Code CLI** 与 **OpenAI Codex CLI**。

> **BREAKING（2026-07-05）**：命令前缀 `tg-*` 已改名 `cw-*`（如 `/tg-brainstorm` → `/cw-brainstorm`）。旧版安装者请重跑 `install.sh` 并手动清理 `~/.claude/commands/tg-*`、`~/.codex/skills/tg-*`。

核心 = **三事实对账闭环**：Human 意图=SSOT，由代码运行 + 用户体验持续挑战校准，绝不被现实直接替代。

> ⚠️ 本仓为**生成产物**（私有 SSOT 经 `publish.sh` 单向生成）。**勿手改**——下次发布会覆盖。

## 安装
```bash
git clone https://github.com/brightman-ai/cliworkflow.git ~/.cliworkflow && ~/.cliworkflow/install.sh
```

## 两个 runtime 的调用（机制不同，务必知悉）
| runtime | 调用 | 补全 |
|---------|------|------|
| **Claude Code** | `/cw-clarify …` | ✅ 原生 `/` 补全（每 `.md` = 一个 slash 命令）|
| **Codex CLI** | **`@cw-clarify …`**（`@` 提及菜单）｜ `/skills` 选 ｜ 裸词 `cw-clarify …` | ✅ 打 `@cw-` 过滤出命令列表（右侧标 `Skill`）选中 |

> **为什么 Codex 是 `@cw-*` 而非 `/cw-*`**：Codex 的 `/` popup 只认内置命令与 custom prompts，而 custom prompts 自 0.117 起弃用不再加载（openai/codex#15941）；skill **不进 `/` popup**——它们进 **`@` 提及菜单**。故 Codex 侧的"命令补全"= 打 `@` 再输 `cw-`，即得可浏览的命令列表。裸词 `cw-clarify`（无 `@`）也能由 skill 描述隐式触发。

## 命令（9，环节固定·范围作参数）
| 命令 | 环节 |
|------|------|
| `clarify <scope> "<人话>"`   | 表达模糊→单轮≤3问结构化放大（7 要素）|
| `brainstorm <scope> "<想法>"`| 方向没定→自适应逼问逐个拍定方向+关键决策 |
| `think <scope>`              | 深碰：锚定真问题+撞第一面墙+三域，落 `docs/topics` |
| `spec <scope>`               | 新建活规格（SSOT）|
| `change <scope> "<诉求>"`    | 改已有需求（写 delta，验收后合并）|
| `retro` / `init`             | 元教训入库 / 新工程接入 |
| `caveman` / `handoff`        | 极简表达 / 跨 session 交接 |

> 本版为**自包含核心子集**；experience 验收系与实验/评审命令依赖项目实例，未随本版发布。

## LICENSE
见 `LICENSE`（MIT）。
