# 财经演播室卡片风 (finance-studio-cards)

适用：财经、商业、公司分析、宏观政策、产业结构、知识博主专业信息屏。
气质：演播室信息大屏。观众能清晰看到关系、数据和传导路径。

## 视觉硬规则

1. 核心卡片必须有"背发光"：卡片外缘柔和光晕 + 边缘线高亮 + 背景倒影，像高端财经演播室屏幕。
2. 发光服务层级：主卡片最亮，次级节点弱发光，非当前路径压暗。不能所有卡片同样亮。
3. 一屏最多 7 个活跃节点，只解释一组关系。
4. 首屏必须是专业信息大屏：强标题 + 主数字 + 顶部栏条 + 可信标签。
5. 卡片像演播室图层：直角或小圆角、硬边线、栏条、数据标签、轻微玻璃层次。

## 组件库

**全局**：`.top-bar` / `.top-bar-label` / `.top-bar-accent`（顶部演播室栏条）
**卡片**：`.card` / `.card.main` / `.card.large` / `.card-title` / `.card-body` / `.glow-edge`
**节点**：`.node` / `.node.lit` / `.node.main`
**文字**：`.kicker`（绿色标签）/ `.headline` / `.headline-sm` / `.sub-text` / `.accent-word`
**数据**：`.kpi-number` / `.kpi-label` / `.bar-item` / `.bar-label` / `.bar-track` / `.bar-fill` / `.bar-fill.lead` / `.bar-value`
**流程**：`.transmission-stage` / `.transmission-stage.main` / `.stage-title` / `.stage-desc` / `.flow-node` / `.flow-node.main` / `.flow-label` / `.flow-amount` / `.flow-connector`
**辅助**：`.vs-divider` / `.relation-line` / `.flow-arrow`

## 运动个性

1. 强节拍必须有版面级运动：截图收进侧屏、数字 punch-in、关系路径逐段点亮、卡片组归位。
2. 卡片入场时带外缘背发光，落位后保持克制亮边。
3. 节点/卡片必须分批出现，不能所有节点同时运动。

## 风格禁忌

1. 过度圆角 SaaS 卡片。
2. 扁平深色卡片没有背发光（必须有光效层次）。
3. 所有节点同时运动（必须分批）。
