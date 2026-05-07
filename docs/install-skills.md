# 安装 Skill

本仓库提供五个 skill。你可以全部安装，也可以只安装 `jacky-opc` 主引擎。

## 安装方式

把需要的 skill 目录复制到你的 AI 工具 skill 目录。

示例：

```bash
cp -R skills/jacky-opc ~/.codex/skills/
cp -R skills/jacky-hook ~/.codex/skills/
cp -R skills/jacky-de-ai ~/.codex/skills/
cp -R skills/jacky-xhs-check ~/.codex/skills/
```

`jacky-illustration` 如果要调用图片模型，需要设置环境变量：

```bash
export GOOGLE_API_KEY="your-key"
```

不要把真实 key 写进 `SKILL.md`、脚本或仓库文件。

## 推荐使用顺序

1. `jacky-opc`：跑完整内容流程。
2. `jacky-hook`：优化开头。
3. `jacky-de-ai`：做风格层打磨。
4. `jacky-xhs-check`：发小红书前检查风险表达。
5. `jacky-illustration`：为文章或图文规划配图。

## 路径配置

主 skill 默认读取 `OPC_ROOT`。如果你的工具不支持自动读取环境变量，就在对话里明确告诉 AI：

```text
我的 OPC_ROOT 是 /你的/OPC-System/路径。请先读取这个目录里的 CLAUDE.md 和 01-09 文件夹。
```

