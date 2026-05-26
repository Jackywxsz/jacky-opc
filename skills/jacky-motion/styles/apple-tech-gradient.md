# 苹果科技渐变演示风 (apple-tech-gradient)

适用：AI 工具、产品概念、抽象机制、未来科技、keynote 式能力展示。
气质：克制的 keynote。一个概念在干净的空间场中展开。

## 视觉硬规则

1. 每屏最多 1 个主视觉 + 1 个辅助标签，不堆叠多元素。
2. 渐变只做空间氛围，不能当信息载体。
3. 首屏必须像 keynote 概念揭示：一个强概念、清晰空间层次——不是深色卡片面板。
4. 模块像空间图层不像仪表盘卡片，超过 4 个必须拆节拍。
5. 纯黑空间底、磨砂玻璃面板、极简纯白文字。推荐强调色热力橙 (#e85d36)，仅在极少数关键词和导航高亮使用。

## 组件库

**容器**：`.glass-panel`（磨砂玻璃大面板）/ `.module`（空间浮动小模块）
**文字**：`.concept`（超大概念词 7vw）/ `.kicker`（蓝色标签）/ `.headline` / `.sub-text` / `.keyword` / `.accent-word`
**空间**：`.glow-accent`（模糊氛围光球）/ `.module-label` / `.module-desc` / `.layer-item` / `.layer-label` / `.layer-desc` / `.layer-connector`
**对比**：`.ba-side` / `.ba-side.before` / `.ba-side.after` / `.ba-label` / `.ba-title` / `.ba-desc` / `.ba-divider`
**环绕**：`.orbit-center` / `.orbit-ring` / `.orbit-item` / `.orbit-label`
**结果**：`.result-text` / `.result-desc`

## 运动个性

1. 动态感来自空间层级、慢推、mask reveal、模块错层，不来自密集卡片和霓虹闪烁。
2. 强节拍必须有概念展开序列：核心居中 → 层级浮出 → 主概念让位 → 结果放大。
3. 文字强调必须慢且精确：短语 mask reveal、结果词轻微放大、标签延迟落位。

## 毛玻璃质感

所有卡片类元素（.module, .glass-panel, .ba-side, .layer-item, .src-tag 等）必须统一使用苹果毛玻璃风格：
- `backdrop-filter: blur(24px)`
- `background: rgba(255,255,255,.07)`
- `border: 1px solid rgba(255,255,255,.12)`
- 微弱背发光：`box-shadow: inset 0 1px 0 rgba(255,255,255,.06), 0 8px 32px rgba(0,0,0,.25), 0 0 80px rgba(255,255,255,.018)`

背发光强度要微弱（.018 左右），给卡片"从黑暗中微微浮起"的感觉，不可过亮。

## 反 AI 视觉指纹

以下是 AI 生成内容常见的低质量视觉模式，在本风格中**绝对禁止**：

- 紫粉渐变背景（用纯黑 + 单色微弱氛围光替代）
- 彩色左边框卡片（用毛玻璃卡片 + rgba 白色边框替代）
- Emoji 作为图标（用纯文字标签替代）
- 居中大标题 + 3 列等宽卡片的万能布局（信息结构驱动布局选择）
- 彩虹色或多强调色（仅用单一热力橙 #e85d36）

## 风格禁忌

1. 密集图表、多卡片堆叠、仪表盘式排列。
2. 随机粒子、强弹跳、赛博朋克杂乱、过度霓虹。
3. 多个强强调色同时出现。
4. 渐变背景上只放静态大字（没有空间运动）。
5. 截图/配图作为 opacity<0.5 的暗淡背景——必须在 glass-panel 或 src-shot 容器中清晰展示。信息截图禁止 `object-fit:cover`，用 `max-width:100%;max-height:100%` 自然缩放 + 卡片包裹。
6. 信息元素用绝对定位随机散布——必须有网格/行列对齐结构，保持发布会高级感。
7. 元素重叠遮挡——大数字和文字描述不可堆在同一个 absolute 中心位置。
8. 多项内容同时 stagger 涌入——列表/标签必须逐项渐进揭示。
