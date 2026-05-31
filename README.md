# Jacky 的创作者 AI Skill 仓库

> Skill 不是护城河，生产体系才是。

Jacky 的创作者 AI Skill 仓库，是一套面向内容创作者、个人 IP、超级个体和一人公司的 AI skill 仓库。

它不是“万能写稿提示词合集”，而是一套创作者工作台：从选题、开头、去 AI 味、知识库沉淀，到配图、信息动画、发布前检查，再到 Jacky-OPC 的完整内容生产系统。

可在 Claude Code、Codex、Cursor、Trae Solo 等支持 skill / system prompt 的 Agent 上按需使用。

## 最新更新

当前版本：v0.2.0

v0.2.0 重点：

- 收拢所有 `jacky-*` 系列 skill。
- `jacky-opc` 从单独项目升级为创作者 AI skill 仓库的主系统。
- 补充 `opc-system-template/`，让用户能照着搭建自己的内容生产文件夹。
- 移除本机路径、API Key、输出图片、PDF 和私人内容。

## 如何安装

### 通用安装

如果你的工具支持从 GitHub 安装 skill 仓库：

```bash
npx skills add Jackywxsz/jacky-opc
```

### 手动安装

把需要的 skill 目录复制到你的 skill 目录。

```bash
cp -R skills/jacky-opc ~/.codex/skills/
cp -R skills/jacky-hook ~/.codex/skills/
cp -R skills/jacky-wiki ~/.codex/skills/
cp -R skills/jacky-de-ai ~/.codex/skills/
cp -R skills/jacky-xhs-check ~/.codex/skills/
cp -R skills/jacky-illustration ~/.codex/skills/
cp -R skills/jacky-motion ~/.codex/skills/
```

你也可以只复制其中一个 skill。每个 skill 都是独立目录，根级包含 `SKILL.md`。

### 环境变量

部分 skill 需要你告诉它本地工作区在哪里。

```bash
export OPC_ROOT="$HOME/Documents/OPC System"
export WIKI_ROOT="$HOME/Documents/知识库"
export GOOGLE_API_KEY="your-key"
```

- `OPC_ROOT`：`jacky-opc` 使用，指向你的 OPC System 文件夹。
- `WIKI_ROOT`：`jacky-wiki` 使用，指向你的知识库。
- `GOOGLE_API_KEY`：`jacky-illustration` 使用，禁止写入仓库文件。

## Skills 工具箱

| Skill | 做什么 | 适合什么时候用 |
| --- | --- | --- |
| `jacky-opc` | 一人内容公司全流程系统 | 从选题到发布、复盘、沉淀完整跑一遍 |
| `jacky-hook` | 短视频 / 图文开头优化 | 开头不吸引人、前 5 秒留不住人 |
| `jacky-wiki` | 知识库沉淀与检索 | 把对话沉淀到 Obsidian，或只基于知识库回答 |
| `jacky-de-ai` | 去 AI 味改写 | 文案太像 AI、太书面、太顺滑 |
| `jacky-xhs-check` | 小红书发布前风险检查 | 发笔记前查敏感词、绝对化表达、引流风险 |
| `jacky-illustration` | 文章配图与图片提示词 | 给文章拆图、生成信息图、做社媒配图 |
| `jacky-motion` | 口播稿转信息动画 HTML | 把中文口播稿做成 16:9 可录屏动画 |

## 常见使用路径

### 内容生产主线

```text
jacky-opc（选题 / 结构 / 初稿）
    ↓
jacky-hook（开头诊断）
    ↓
jacky-de-ai（风格打磨）
    ↓
jacky-xhs-check（发布前检查）
    ↓
jacky-wiki（复盘沉淀）
```

### 图文内容路径

```text
jacky-opc（长文 / 小红书图文）
    ↓
jacky-illustration（配图方案）
    ↓
jacky-xhs-check（平台风险检查）
```

### 视频内容路径

```text
jacky-opc（短视频逐字稿）
    ↓
jacky-hook（前 5 秒）
    ↓
jacky-motion（信息动画 HTML）
```

### 知识资产路径

```text
任何一次有价值的对话
    ↓
jacky-wiki（写入知识库）
    ↓
jacky-opc（下次创作读取上下文）
```

## OPC System

`opc-system-template/` 是 Jacky-OPC 的文件夹体系参考。

```text
opc-system-template/
├── 01.用户画像/
├── 02.对标账号/
├── 03.我的上下文/
├── 04.选题决策/
├── 05.文案结构/
├── 06.开篇模板/
├── 07.发布存档/
├── 08.数据反馈/
├── 09.经验沉淀/
└── CLAUDE.md
```

使用方式：

1. 把 `opc-system-template/` 复制到你的 Obsidian 或普通文件夹。
2. 改名为 `OPC System`。
3. 先填 `01.用户画像`、`02.对标账号`、`03.我的上下文`。
4. 再用 `04.选题决策` 的生成模板，逐步建立自己的 100 条谜题和 100 条非共识。
5. 发布后把数据和经验写回 `08.数据反馈`、`09.经验沉淀`。

## 目录结构

```text
jacky-opc/
├── skills/
│   ├── jacky-opc/
│   ├── jacky-hook/
│   ├── jacky-wiki/
│   ├── jacky-de-ai/
│   ├── jacky-xhs-check/
│   ├── jacky-illustration/
│   └── jacky-motion/
├── opc-system-template/
├── docs/
├── LICENSE
└── README.md
```

## 脱敏边界

这个仓库保留：

- 当前 `jacky-*` skill 的主体说明、引用文件、模板和必要脚本。
- Jacky-OPC 的文件夹体系和方法论模板。
- 可复用的选题、开头、复盘和内容生产结构。

这个仓库不包含：

- 本机绝对路径。
- 真实 API Key、token、密钥。
- 输出图片、PDF、`.DS_Store`、生成产物。
- 未发布私稿、私有对标笔记、真实数据报表。

## 维护计划

- 把 `jacky-opc` 继续做成主入口。
- 给每个 skill 补齐 README、示例输入和示例输出。
- 增加 release zip，方便 Trae Solo 等工具导入。
- 给 `opc-system-template` 增加更完整的空文件夹初始化模板。
- 建立 changelog，记录每次方法论和 skill 的更新。

## 许可证

- 脚本和代码：MIT，见 `LICENSE`
- 文档、模板、方法论：CC BY 4.0，见 `LICENSE-DOCS.md`
