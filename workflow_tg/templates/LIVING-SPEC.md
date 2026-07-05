<!-- 活规格模板 → 落 CONFIG 解析的 <long_term_root>/<scope>/spec.md（long_term_root=基目录不含 scope，默认 docs/product/；legacy 经 CONFIG 映射、禁双写）。唯一人手维护的"规范意图"，干净可读。
     只写"要达到什么+怎样算达到"，不复述代码/运行时已表达的事实（零重叠=零漂移面）。 -->
# <scope> 活规格

> intent_state: exploring | accepted    （详细两轴状态见同目录 status.yaml）

## 1. 产品意图（为什么做，不是做什么）
<1-2 句：用户真正要解决的问题 / 想达到的终态。Human-accepted intent is truth。>

## 2. 主要使用者 & 情境
- 谁：<最终用户 / 内部运营或业务用户 / 开发或集成用户 中哪种，具体角色>
- 何时何地：<常见触发情境，含设备/移动端约束（若有）>

## 3. 范围锚定 & 集成点
- 聚焦：<改哪个模块/组件 — 砍关联面>
- 在现有什么基础上：<SSOT 锚，避免造第二份>
- 集成到：<已有的哪个入口/面板/流程>

## 4. 非目标（显式不做）
- 不做 <X>（理由 / 翻转触发）
- 忽略 <Y>（如协同冲突 / 历史兼容 / 后端依赖）

## 5. 验收清单（每条标 oracle；第一面墙可判定）
- [ ] <REQ-id> <可观测终态> · oracle: experience | empirical | unit | system | migration
- [ ] <REQ-id> <边界/冲突情形如何表现> · oracle: …
- [ ] <REQ-id> <恢复/回退路径> · oracle: …
> oracle 含义见 ~/.cliworkflow/workflow_tg/WF-TG-GUARDRAILS.md §4。requirement-id 跨 delta 稳定。

## 6. 视觉对标项（仅 UX 类 — 不接受"按 X 范式"，逐项列）
- 参照物：<codex / gemini web / v6.html / iterm …>
- 逐项：<间距 / 配色 token / 状态态 / 空态 / 加载态 …>

## 7. 已知约束 & 证据级
- <技术约束 / 性能 / 兼容>   证据：■硬 / △软 / ○类比

## 8. 变更日志（delta 接受后合并进上文，这里只留摘要 + 归档指针）
- <日期> <REQ-id> ADDED/MODIFIED/REMOVED <一句话>（详见归档 <run_root>/<thread-id>/delta.md，经 CONFIG 解析）
