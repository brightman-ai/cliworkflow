# TG-INIT — 新工程初始化（采用 workflow_tg）

> 环节：`/cw-init [<工程路径>]`。一次性把新工程接入 workflow_tg：**自适应访谈填 CONFIG → 查工具 → 验加载链**。
> 先读 `experience/CONFIG-TEMPLATE.md`（要填的模板）。

## 何时用
新工程首次采用 tg（尤其要用 `/cw-experience-*`）；或既有工程缺 `docs/product/CONFIG.md`。一次性，之后不再跑。

## 流程（吃自己狗粮：用 brainstorm 式自适应访谈填 CONFIG，别甩空模板让人填）
1. **探测 repo**（能查的先自己查，别问）：嗅 build 命令、server 入口、UX 工具是否在 PATH（`command -v 你的-UX-探针工具`）、有无既有持久化体系（`docs/experience/` 等）、端口。
2. **自适应访谈填 `CONFIG-TEMPLATE` 7 段**（一次一问、**每问带从探测推出的推荐默认**让用户 react，别一次抛全表）：UX driver 动词→命令映射 + gotcha / base_url + entry_urls / build + server_start / **持久化根**（新工程默认 `docs/product/` 基目录；有既有体系则**映射、禁双写**）/ System Evidence 探针 / must_read（**研究/实验型工程再填 `empirical_measurement` 段：dataset/指标/跑测命令**）。
3. **preflight**：`command -v <tool>` 缺 → **提醒用户安装并给安装命令，绝不自动装**（如 你的-UX-探针工具：你的浏览器工具仓 仓 `go build -o ~/.local/bin/你的-UX-探针工具 ./cmd/你的-UX-探针工具`）；缺则先降级为只读 review。
4. **写/更新** `{工程}/docs/product/CONFIG.md`（填好的实例，非空模板）——**幂等**：已存在（多模块软链共享同一份）→ 读现有、只补缺字段、**禁盲覆盖**；不存在才新建。多模块差异走 per-scope 段，**不另起第二份 CONFIG**。
5. **验加载链**：`ENGINE.md` + `WF-TG-GUARDRAILS.md` + 本 CONFIG 可达、变量解析无歧义（long_term_root = 基目录、路径 `<根>/<scope>/`）；可选 smoke（server 起、UX 工具开一页）。
6. 产出：填好的 CONFIG 路径 + "就绪，下一步 `/cw-clarify`（富化/改）或 `/cw-spec`（新建）或 `/cw-experience-*`（验收）"。

## DONE-WHEN
- `docs/product/CONFIG.md` 就位且 7 段填全（缺项标 `[假设]`/`[待装]`；**研究/实验型再填 `empirical_measurement`**）；UX 工具在 PATH 或已给安装提醒；加载链验通。

## 纪律
- **skill 不自动装二进制**——只提醒给命令（职责分离/安全，见 ENGINE §4）。
- **CONFIG 幂等、禁并发 init**：多模块（terminal/pro/browser）软链同一 docs/ 共享一份 CONFIG → 已存在则读+补缺不盲覆盖；init 是一次性、别多模块并发跑（见 CONVENTIONS 并发分类表）。
- **持久化根**：新工程默认 `docs/product/` 基目录（路径 `<根>/<scope>/`，别重复 scope）；有既有体系（如 `docs/experience/`）则映射、**禁双写第二份意图源**。
- `docs/topics`（think 用）+ TOPIC-BOARD **懒创建**（首次 `/cw-think` 时建），init 不必预建。
