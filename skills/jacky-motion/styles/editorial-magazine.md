# 杂志信息图风 (editorial-magazine)

适用：深度知识、文化、商业洞察、方法论、研究解读、人物故事。
气质：高级编辑版面。屏幕像一本正在翻开的杂志特稿，不是 PPT 模板。

## 视觉硬规则

1. 强网格、大留白、单焦点、克制字体层级。留白是风格的一部分，不能用小字填满。
2. 首屏必须有"跨页感"：强图或强短句占据版面，标题进入网格——不做普通封面卡片。
3. 图片裁切必须服务论证。没有真实图片时，用排版/编号/引用构成主视觉。
4. 衬线/无衬线对比仅在增强层级时使用。
5. 每屏只保留一个主图或一个主观点。

## 组件库

**容器**：`.os-visual` / `.os-visual.dark` / `.os-visual.tinted`（跨版视觉区）/ `.crop-frame`
**文字**：`.kicker`（红色标签）/ `.headline`（衬线大标题）/ `.headline-sans` / `.sub-text` / `.body-text` / `.accent-word` / `.teal-word` / `.contrast-mark`
**引用**：`.pq-text` / `.pq-bar`（左侧竖线）/ `.pq-source`
**编号**：`.ne-item` / `.ne-num` / `.ne-text` / `.ne-sub`
**侧栏**：`.se-side` / `.se-side.teal` / `.se-side-title` / `.se-side-body` / `.se-side-note`
**数据**：`.stat-block` / `.stat-num` / `.stat-num.bright` / `.stat-label` / `.bar-group` / `.bar-row` / `.bar-label` / `.bar-track` / `.bar-fill` / `.bar-value` / `.big-num`
**流程**：`.flow-row` / `.flow-step` / `.flow-step.active` / `.flow-arrow` / `.tag` / `.tag.red` / `.tag.teal` / `.tag.outline`
**辅助**：`.rule-line` / `.cl-rule` / `.cl-text` / `.cl-sub`

## 运动个性

1. 动态感来自版面平移、图片裁切、标题分层、编号推进，不来自大量卡片入场。
2. 强节拍必须有编辑版面变化：大图/标题入场 → 网格重构 → 引用/编号落位 → 停在可读构图。
3. 文字按编辑层级出现：栏目 → 标题 → 引用 → 注释，不是所有文字用同一种 fade。

## 风格禁忌

1. 卡片堆叠泛滥。
2. 科技渐变、随机氛围图做背景。
3. 长段正文、全居中排版、PPT 式 bullet 列表。
4. 没有裁切/版面重构的静态图片展示。
