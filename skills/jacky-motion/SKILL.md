---
name: jacky-motion
description: 把中文口播稿变成可录屏的 16:9 信息动画 HTML。6阶段流水线：审稿→分镜→锁风格→生成HTML→验收→配音录制。
---

# 科普动画导演

把口播稿变成可录屏的 16:9 信息动画 HTML。信息表达驱动一切——布局服务于信息层次，动画服务于信息节奏。

## 流水线（6 阶段，3 确认门）

```text
口播稿 → [审稿] →⏸→ [分镜] →⏸→ [锁风格] →⏸→ [生成HTML] → [验收] → [配音录制] → 交付
```

### Phase 1：审稿

按 [script-audit.md](references/script-audit.md) 的 6 条标准检查 → 输出：通过 / 轻改 / 重写。
**停止**，等用户确认。

### Phase 2：分镜

按口播自然段落拆节拍，数量由内容决定，不设上限。每个节拍填表：

```
节拍 | 口播摘要 | 核心信息(1句) | 信息结构 | 视觉动词 | 屏幕文字
```

**停止**，等用户确认。
硬约束：每个节拍必须有视觉动词；核心信息只能一句话；屏幕文字必须短于口播。

### Phase 3：锁风格 + 构图

推荐风格 → 读 [styles/{ID}.md](styles/) → 为每个节拍描述构图方案。输出：

```
风格：[ID]
Beat 1 → 构图：[描述] → 核心元素：[列表] → 4段编排简述
Beat 2 → ...
```

**停止**，等用户确认。全片单一风格，不可混搭。

### Phase 4：生成 HTML

1. 读风格模板 [assets/templates/{ID}.html](assets/templates/) 获取 CSS 变量和组件类
2. 为每个 beat 编写独立 CSS 类（如 b1-left, b2-grid）和独立 GSAP 动画
3. 每个 beat 按 4 段式设计镜头编排
4. 输出单文件 .html
5. HTML 中预留音频钩子：`advance()` 和 `showBeat()` 函数结构支持后续注入 `playStepAudio()`，无需重写导航逻辑

### Phase 5：验收

按 [quality-check.md](references/quality-check.md) 检查 → 不通过自动修复。

### Phase 6：配音录制

验收通过后询问用户选择配音方式：

- **选项 A：自行配音** → 用户用 OBS/QuickTime 全屏录制 HTML，自己配音，流程结束。
- **选项 B：TTS 配音** → 进入 TTS 合成流程（见下文），输出带音频的自动播放 HTML，用户录屏即可。

---

## TTS 合成流程（Phase 6B）

轻量级 TTS 流水线，无 npm，单文件 HTML + 外部 mp3 文件夹。

### 前置检查

检查 `mmx` CLI 是否可用：

```bash
mmx auth status
```

如果未安装，提示用户三选一：
1. 安装 MiniMax CLI：`npm install -g mmx-cli && mmx auth login --api-key <KEY>`（推荐，中文效果好）
2. 改用其他 TTS（OpenAI TTS / Edge TTS 等）——AI 修改合成脚本适配
3. 跳过 TTS，回退到选项 A 自行配音

### Step 1：提取口播文本

从分镜表提取每个步骤（step）的口播文本，生成 `audio-segments.json`：

```json
[
  {"beat": 1, "step": 0, "text": "口播文本…", "file": "audio/b1-s0.mp3"},
  {"beat": 1, "step": 1, "text": "口播文本…", "file": "audio/b1-s1.mp3"},
  {"beat": 2, "step": 0, "text": "口播文本…", "file": "audio/b2-s0.mp3"}
]
```

规则：
- 多步节拍（data-steps）拆成多条，每步一段音频
- 空文本跳过，不生成音频
- 文件放在 HTML 同目录的 `audio/` 文件夹

### Step 2：合成音频

逐条调用 TTS，**串行执行**避免限频：

```bash
mkdir -p audio
for each segment in audio-segments.json:
  mmx speech synthesize --text "$text" --out "$file"
```

已存在的 mp3 自动跳过（安全重跑）。加 `--force` 强制重新合成。

### Step 3：注入音频到 HTML

在已生成的 HTML 中做两处修改：

**1) 给每个 step 标注音频路径：**

在每个 `.beat` 上添加 `data-audio-map` 属性，值为 JSON：

```html
<section class="beat" data-steps="2" data-audio-map='["audio/b4-s0.mp3","audio/b4-s1.mp3"]'>
```

单步节拍（无 data-steps）：

```html
<section class="beat" data-audio-map='["audio/b1-s0.mp3"]'>
```

**2) 添加播放模式切换 + 音频控制器脚本：**

```javascript
// 三种模式：manual / audio / auto
// manual: 原始手动翻页，无音频
// audio: 播放音频，但手动翻页
// auto: 播放音频 + 音频结束自动翻页
//
// 切换方式：按 M 键循环，或 URL 参数 ?auto=1 / ?audio=1
// 浏览器自动播放限制：auto 模式首次需要用户点击一次启动
```

音频控制器核心逻辑：

```javascript
let mode = 'manual'; // manual | audio | auto
let audioEl = null;

function playStepAudio(beat, step) {
  if (mode === 'manual') return;
  const map = JSON.parse(beat.dataset.audioMap || '[]');
  const src = map[step];
  if (!src) return;
  if (audioEl) { audioEl.pause(); audioEl = null; }
  audioEl = new Audio(src);
  audioEl.play().catch(() => {});
  if (mode === 'auto') {
    audioEl.onended = () => setTimeout(advance, 200);
  }
}
```

- `advance()` 后调用 `playStepAudio(currentBeat, currentStep)`
- 手动翻页时如果有音频在播，立即停止
- 200ms 尾部缓冲，避免切换太突兀

### Step 4：录制

1. 用浏览器打开 HTML（建议 Chrome 全屏）
2. 加 `?auto=1` 启用自动播放模式
3. 启动录屏（QuickTime / OBS / Cmd+Shift+5）
4. 点击一次启动，全片自动播完
5. 停止录屏，裁头尾即可

### TTS 备选方案

如果不用 MiniMax，替换合成命令即可，接口约定：

- 输入：文本（≤5000 字）+ 输出文件路径
- 输出：mp3 文件
- 示例（OpenAI TTS）：

```bash
curl -s https://api.openai.com/v1/audio/speech \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"tts-1","input":"文本","voice":"alloy"}' \
  --output "$file"
```

---

## 视觉动词 × 信息结构

| 视觉动词 | 含义 | 信息结构适配 |
|---|---|---|
| 高亮 | 看这里 | 证据、引用、对比 |
| 连接 | 有关联 | 关系、层级、流程 |
| 增长 | 数量增加 | 数据、对比 |
| 对比 | A和B不同 | 对比、数据 |
| 推近 | 细节重要 | 证据、概念、引用 |
| 展开 | 背后有逻辑 | 概念、层级、流程、结论 |
| 流动 | 在系统中传递 | 流程、关系、时间线 |
| 堆叠 | 证据/层级累积 | 证据、时间线 |
| 计数 | 数字重要 | 数据 |
| 灰化聚焦 | 先忽略其他 | 概念、关系、对比、结论 |

## 4 段式镜头编排

每个节拍的动画分 4 个阶段，点击后自动完成，然后停在 hero frame：

1. **主视觉入场** — 建立画面主体
2. **画面重构** — 布局变化或新元素加入
3. **关键词强调** — 重点信息视觉突出
4. **标注落位** — 辅助信息就位，画面定格

这是编排思路，AI 用 GSAP timeline 自由实现。总时长 2-4 秒，各阶段留出呼吸感。

## 4 种风格

| 风格 | 适用 | 气质 |
|---|---|---|
| [newspaper-evidence](styles/newspaper-evidence.md) | 新闻、历史、政策、社会议题 | 证据、档案、纪录片 |
| [apple-tech-gradient](styles/apple-tech-gradient.md) | AI工具、产品概念、抽象机制 | 克制keynote、概念展开 |
| [finance-studio-cards](styles/finance-studio-cards.md) | 财经、商业、公司分析 | 演播室信息大屏 |
| [editorial-magazine](styles/editorial-magazine.md) | 深度知识、文化、商业洞察 | 高级编辑版面 |

## 生成规则

1. 画面比例默认 16:9（1920×1080），可选 4:3（1440×1080）。手动翻页（click / Space / ←→）。比例在 Phase 3 锁风格时确认
2. 单文件 HTML，GSAP 3 via CDN，无 npm
3. 读风格模板获取 CSS 变量和组件类，以此为视觉基础
4. 每个 beat 编写独立 CSS 类（如 b1-left, b2-grid）和独立 GSAP 动画
5. 每个 beat 的 4 段式编排总时长 2-4 秒，各阶段有呼吸感
6. 每个 beat 必须撑满画面——字号下限（16:9）：标题 ≥ 96px，正文 ≥ 25px，标签/辅助 ≥ 18px；4:3 时：标题 ≥ 72px，正文 ≥ 22px，标签 ≥ 16px
7. .beat 用 `position:absolute;inset:0` 撑满画布，不加 padding；只有内部容器有 padding。beat 内部容器加 `overflow:hidden`，子元素禁止超出 stage 边界
8. 节拍数量由内容决定，宁多不丢信息
9. 截图/配图必须作为可见的主视觉展示，**不可**作为暗淡背景图（opacity<0.5 的 background-image）
10. 截图/配图的 CSS 实现——区分两类图片：
    - **信息截图**（UI 界面、代码截图、表格、对话截图等需要完整阅读的图片）：**禁止** `object-fit:cover`。容器用 `display:flex;align-items:center;justify-content:center` + padding 居中，img 用 `max-width:100%;max-height:100%;display:block` 自然缩放，配合 `border-radius + box-shadow` 做卡片包裹。容器**不设 background-color**，避免灰色背景框
    - **装饰配图**（氛围图、纹理、人物特写等不需要完整阅读的图片）：可用 `.crop-frame` + `object-fit:cover`
11. 信息元素布局必须对齐、有结构（网格/行列），**不可**随机散布（如绝对定位到随机百分比坐标）
12. 渐进揭示与多步动画：口播内容有明确推进的节拍，用 `data-steps="N"` 标记，点击依次推进步骤，全部步骤完成后才进入下一个节拍。列表/标签/要点等多项内容必须逐项出现（1 项 = 1 步），不可同时 stagger 全部涌入
13. 同一区域的元素不可重叠遮挡——大数字、标题、描述文字等必须分层排列，不允许 absolute 定位导致的文字重叠
14. 分段式导航栏：必须放在 `#stage` 内部，用 `position:absolute;bottom:28px;left:50%;transform:translateX(-50%)`，**禁止 `position:fixed`**。显示 past / active / future 状态，支持点击跳转任意节拍
15. body 背景色必须与 `#stage` 主背景色相同。body 用 `display:grid;place-items:center;min-height:100vh` 居中 stage。stage 用固定像素尺寸（16:9 为 1920×1080，4:3 为 1440×1080）+ JS `transform:scale(Math.min(innerWidth/W, innerHeight/H))` 缩放 + `transform-origin:center center`
16. 4:3 布局适配：stage 宽 1440px，信息源 beat 的左图右文改为上图下文或 6:4 比例（图占 40%），单行文字 max-width 不超过 1200px
17. 视觉重心：每个 beat 必须有一个主导元素（dominant element），禁止所有元素大小均匀平铺。具体要求：
    - **图文 beat**：截图与文字必须有主次。截图作主视觉时 ≥ 画面面积 40%、边缘清晰；文字作主视觉时标题字号 ≥ 正文 3 倍。两者不可都是中等大小
    - **纯文字 beat**：用超大标题或数字（16:9 ≥ 120px / 4:3 ≥ 88px）作视觉锚点，辅助文字明显缩小形成层级
    - **检验**：标题与正文字号差距 < 2 倍 → 层级不够；截图缩到一半就看不清 → 截图太小

## 动画决策树

从口播内容推导动画，不要凭空添加装饰：

```
口播内容 → 提取内容动作（对比？递增？展开？）→ 匹配视觉动词 → 选择信息结构
```

如果内容没有明确动作，退回到最基础的：居中概念 → 辅助信息浮出。绝不添加内容中不存在的运动。

## 反 AI 视觉指纹

以下是 AI 生成内容常见的低质量视觉模式，**必须避免**：

| 禁止模式 | 替代方案 |
|---|---|
| 紫粉渐变背景 | 使用对应风格的背景色体系 |
| 彩色左边框卡片 | 使用对应风格模板定义的卡片组件 |
| Emoji 作为图标 | 纯文字标签或极简线性图标 |
| 所有节拍同一动画 | 每个节拍独立编排 |
| 居中大标题 + 3 列卡片 | 信息结构驱动布局（对比用左右、层级用上下、展开用中心外扩）|
| 深色卡片面板铺满屏幕 | 空间层次感，概念在空间中展开 |
| 彩虹色多强调色 | 使用对应风格的强调色，克制使用 |

## 禁止

1. 捏造数据、来源、引用
2. 屏幕文字 = 完整口播（屏幕文字必须短于口播）
3. 混用风格
4. 装饰性动画（不帮助理解的运动）
5. 全部节拍用同一种动画
6. 整页同时出现（每个 beat 至少 2 个动画阶段）
7. 节拍内所有内容自动播放无停顿——有内容推进的节拍应拆为多步
8. 紫粉渐变、彩色左边框、Emoji 图标——参见「反 AI 视觉指纹」
9. 多项内容同时 stagger 涌入——必须逐项渐进揭示
10. 所有元素同等大小的平铺布局——每个 beat 必须有明确的大 > 中 > 小视觉层级，至少一个主导元素显著大于其余

## 长内容处理

| 长度 | 处理 |
|---|---|
| 1-3 分钟 | 单一 storyboard，一个 HTML |
| 3-8 分钟 | 拆章节，先做第 1 章确认视觉锚点 |
| 8 分钟以上 | 拆成多集或多文件 |
