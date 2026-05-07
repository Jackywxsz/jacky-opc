# Jacky-OPC

> Skill 不是护城河，生产体系才是。

Jacky-OPC 是一套面向内容创作者、超级个体和一人公司的 AI 内容生产系统。它不是一个“自动写稿 prompt”，而是把定位、对标、选题、写作、发布、复盘和沉淀放进同一套可迭代的文件夹体系里。

核心目标很简单：让写作变轻，让体系变重。每一条内容都不只是一次发布，而是在给下一次选题、下一次表达、下一次复盘积累资产。

## 适合谁

- 想用 AI 提升内容生产效率的创作者
- 正在搭建个人 IP、一人公司、知识产品的人
- 经常写内容，但选题、对标、复盘和沉淀不成体系的人
- 想把自己的方法论做成可复用 skill 的 AI 用户

## 不适合谁

- 只想要一键生成爆款标题和万能模板的人
- 不愿意沉淀用户画像、对标样本、数据反馈的人
- 希望直接复制别人私有内容资产的人

## 核心理念

Jacky-OPC 的核心判断是：

1. Skill 本身很容易复制，真正难复制的是长期积累出来的生产体系。
2. 写作只是内容生产链路中的一个环节，选题和复盘才决定复利。
3. 好选题来自目标用户、对标样本、100 个非共识和 100 个谜题。
4. AI 应该读取你的方法论和历史反馈，而不是每次从零开始。

## 仓库内容

```text
jacky-opc/
├── README.md
├── docs/                         # 方法论文档
├── opc-system-template/           # 可复制到 Obsidian 的脱敏模板
├── skills/                        # 主 skill + 辅助 skill
├── scripts/                       # 可配置路径的辅助脚本
├── examples/                      # 虚构示例闭环
├── .env.example
├── LICENSE                        # 代码 MIT
└── LICENSE-DOCS.md                # 文档 CC BY 4.0
```

## 快速开始

### 1. 准备一个内容工作区

复制 `opc-system-template/` 到你的 Obsidian、普通文件夹或任何 Markdown 工作区。

```bash
cp -R opc-system-template ~/Documents/OPC-System
```

### 2. 设置路径

复制 `.env.example` 为 `.env`，把 `OPC_ROOT` 改成你的实际路径。

```bash
cp .env.example .env
```

如果你不想用 `.env`，也可以在命令前直接传环境变量：

```bash
OPC_ROOT="$HOME/Documents/OPC-System" ./scripts/init-content-item.sh short-video "我的第一个选题"
```

### 3. 初始化一条内容

```bash
OPC_ROOT="$HOME/Documents/OPC-System" ./scripts/init-content-item.sh short-video "AI 时代为什么选题比写作更重要"
```

支持类型：

- `short-video`：短视频逐字稿
- `longform`：公众号 / 小红书长文
- `xiaohongshu`：小红书图文
- `post`：短帖 / 推文
- `research`：选题研究笔记

### 4. 安装 skill

把 `skills/` 下需要的目录复制到你的 AI 工具 skill 目录。不同工具的 skill 目录不一样，常见形式是：

```bash
cp -R skills/jacky-opc ~/.codex/skills/
```

安装后，让 AI 先阅读 `skills/jacky-opc/SKILL.md`，再对你的 `OPC_ROOT` 工作区进行创作。

## 五个 skill

- `jacky-opc`：主引擎，负责用户画像、对标、选题、写作、发布、复盘闭环。
- `jacky-hook`：开头优化，基于谜题和 WOW 诊断内容开头。
- `jacky-illustration`：配图提示词和生成流程，使用环境变量读取 API Key。
- `jacky-de-ai`：去 AI 味改写，保留信息，只改表达。
- `jacky-xhs-check`：小红书发布前风险词检查。

## 许可

- 脚本和代码：MIT License，见 `LICENSE`。
- 文档、模板、方法论：Creative Commons Attribution 4.0 International，见 `LICENSE-DOCS.md`。

使用、改造和商用都可以，但请保留署名来源。

## 安全提醒

这个仓库不包含任何真实 API Key、token、私有账号数据或完整历史稿件。你在自己的项目中使用时，也不要把密钥、登录凭证、未公开商业数据提交到 GitHub。

