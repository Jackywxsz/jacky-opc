# Jacky-OPC

> Skill 不是护城河，生产体系才是。

这个仓库不是重新设计的一套写作 prompt，而是从一套真实运行中的 Jacky-OPC 内容生产系统脱敏导出的公开版。

它包含两部分：

1. `skills/jacky-opc/`：当前 Jacky-OPC skill 的公开版，保留 `SKILL.md`、`references/`、`scripts/`、`templates/` 这些附件结构，只移除了本机路径和私人信息。
2. `opc-system-template/`：OPC System 文件夹参考，保留 01-09 的真实工作流骨架和方法论文件，并把个人经历、私有对标、真实数据、未发布稿件替换成模板说明。

## 核心思路

单个 skill 很容易复制，真正值得沉淀的是生产体系。

Jacky-OPC 的工作流是：

```text
用户画像 -> 对标账号 -> 我的上下文 -> 选题决策 -> 文案结构 -> 开篇模板 -> 发布存档 -> 数据反馈 -> 经验沉淀
```

写作本身要做轻，但定位、对标、拆解、复盘、沉淀要做重。选题是核心，用 100 条谜题和 100 条非共识去持续生成内容方向，再通过数据反馈把经验回流到下一轮选题。

## 目录说明

```text
jacky-opc/
├── skills/
│   └── jacky-opc/
│       ├── SKILL.md
│       ├── references/
│       ├── scripts/
│       └── templates/
├── opc-system-template/
│   ├── 01.用户画像/
│   ├── 02.对标账号/
│   ├── 03.我的上下文/
│   ├── 04.选题决策/
│   ├── 05.文案结构/
│   ├── 06.开篇模板/
│   ├── 07.发布存档/
│   ├── 08.数据反馈/
│   ├── 09.经验沉淀/
│   └── CLAUDE.md
└── docs/
```

## 怎么用

### 1. 复制文件夹体系

把 `opc-system-template/` 复制到你的 Obsidian 或普通文件夹里，并改名为 `OPC System`。

### 2. 安装 skill

把 `skills/jacky-opc/` 复制到你的 AI 工具 skill 目录。

示例：

```bash
cp -R skills/jacky-opc ~/.codex/skills/
```

### 3. 设置 OPC_ROOT

脚本读取 `OPC_ROOT` 环境变量：

```bash
export OPC_ROOT="$HOME/Documents/OPC System"
```

也可以在对话中直接告诉 AI：

```text
我的 OPC_ROOT 是 /你的/OPC System/路径。请先读 CLAUDE.md 和 references/路径指南.md。
```

### 4. 先填三个锚点

开始创作前，先补这三个文件夹：

- `01.用户画像/`：你写给谁。
- `02.对标账号/`：谁值得学，学什么，不学什么。
- `03.我的上下文/`：你的经历、观点、口头禅和真实观察。

### 5. 再跑完整流程

正式写内容时，让 AI 按 `skills/jacky-opc/SKILL.md` 的 1-10 步执行。

## 脱敏边界

公开版保留：

- 当前 skill 主体流程
- 路径指南
- 脚本和模板
- 01-09 文件夹结构
- 选题方法论
- 100 条谜题和 100 条非共识的脱敏版
- 文案结构、开篇、发布、复盘、沉淀方法

公开版移除：

- 本机绝对路径
- 私人经历细节
- 私有对标账号笔记
- 未发布稿件
- 真实发布数据
- 图片、PDF、`.DS_Store`、Obsidian 配置和密钥

## 许可

- 脚本代码：MIT，见 `LICENSE`
- 文档、模板、方法论：CC BY 4.0，见 `LICENSE-DOCS.md`

