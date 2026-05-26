# 安装 Jacky 的创作者 AI Skill 仓库

## 推荐方式

```bash
npx skills add Jackywxsz/jacky-opc
```

如果你的工具不支持 `npx skills add`，就手动复制需要的 skill。

## 手动复制

```bash
cp -R skills/jacky-opc ~/.codex/skills/
cp -R skills/jacky-hook ~/.codex/skills/
cp -R skills/jacky-wiki ~/.codex/skills/
cp -R skills/jacky-de-ai ~/.codex/skills/
cp -R skills/jacky-xhs-check ~/.codex/skills/
cp -R skills/jacky-illustration ~/.codex/skills/
cp -R skills/jacky-motion ~/.codex/skills/
```

## 环境变量

```bash
export OPC_ROOT="$HOME/Documents/OPC System"
export WIKI_ROOT="$HOME/Documents/知识库"
export GOOGLE_API_KEY="your-key"
```

`GOOGLE_API_KEY` 只给 `jacky-illustration` 使用。不要把真实 key 写进 `SKILL.md`、脚本、README 或截图。

## 最小安装

只想体验主流程：

```bash
cp -R skills/jacky-opc ~/.codex/skills/
```

只想优化开头：

```bash
cp -R skills/jacky-hook ~/.codex/skills/
```

只想做知识库沉淀：

```bash
cp -R skills/jacky-wiki ~/.codex/skills/
```
