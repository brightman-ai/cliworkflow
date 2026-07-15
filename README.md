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
| **Codex CLI** | **`$cw-clarify …`**（`$` 显式触发，官方唯一 skill 触发符）｜ `/skills` 选择器 ｜ 裸词 `cw-clarify …` | 打 `$` 后输 `cw-` 过滤出命令列表选中；或 `/skills` 浏览 |

> **为什么 Codex 是 `$cw-*` 而非 `/cw-*`**：Codex 的 `/` popup 只认内置命令与 custom prompts，而 custom prompts 自 0.117 起弃用不再加载（openai/codex#15941）；skill **不进 `/` popup**——官方触发符是 **`$`**（`$skill-name`），另有通用 `/skills` 唤出选择器。二者都不对等 Claude Code 的"每文件一命令 `/` 补全"。裸词 `cw-clarify`（无 `$`）也能由 skill 描述隐式触发，除非该 skill 的 `agents/openai.yaml` 设了 `policy.allow_implicit_invocation: false`（如 `grill-me`——`$` 显式调用仍有效，只是不会被自动猜中触发）。

## 6 个高频命令（按常用顺序）
新手从这 6 个开始就够用；其余命令见下方「其余命令」。

| 命令 | 价值 | Claude Code | Codex CLI |
|------|------|-------------|-----------|
| **caveman** | 省 token、不吐废话——技术实质/证据/警告照留，只改"怎么说"。长对话开局就开它 | `/cw-caveman` | `$cw-caveman`（或裸词 `cw-caveman`）|
| **clarify** | 需求模糊时 ≤3 问结构化问清楚，不用来回猜 | `/cw-clarify <scope> "<人话诉求>"` | `$cw-clarify <scope> "<人话诉求>"` |
| **brainstorm** | 方向没定时，逐项逼问拍定方向 + 关键决策（比 clarify 深、比 think 轻）| `/cw-brainstorm <scope> "<模糊想法>"` | `$cw-brainstorm <scope> "<模糊想法>"` |
| **think** | 核心概念/信念存疑时，深度想清楚 + 场景枚举，落盘 discovery 文档 | `/cw-think <scope>` | `$cw-think <scope>` |
| **grill-me** | 方案已经成型时，逐分支逼问压测——一次一问+带推荐，不隐式触发只显式调用 | `/cw-grill-me` | `$cw-grill-me` |
| **handoff** | 长对话要换新 session 接续时，把上下文蒸馏成结构化交接文档，防信息丢失 | `/cw-handoff` | `$cw-handoff` |

## 其余命令
| 命令 | 环节 |
|------|------|
| `spec <scope>`               | 新建活规格（SSOT）|
| `change <scope> "<诉求>"`    | 改已有需求（写 delta，验收后合并）|
| `retro`                      | 元教训入库，防重犯 |
| `init`                       | 新工程接入 |

> 本版为**自包含核心子集**；experience 验收系与实验/评审命令依赖项目实例，未随本版发布。

## LICENSE
见 `LICENSE`（MIT）。
