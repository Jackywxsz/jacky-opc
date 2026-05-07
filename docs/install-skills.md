# 安装 Jacky-OPC

这个仓库只发布当前 `jacky-opc` 主 skill。上一版误加入的辅助 skill 已移除。

## 安装方式

把 `skills/jacky-opc/` 复制到你的 AI 工具 skill 目录。

```bash
cp -R skills/jacky-opc ~/.codex/skills/
```

## 配置 OPC_ROOT

复制 `opc-system-template/` 到你的内容工作区后，设置：

```bash
export OPC_ROOT="/Documents/OPC System"
```

如果你的工具不支持环境变量，就在对话里告诉 AI：

```text
我的 OPC_ROOT 是 /你的/OPC System/路径。请先读取 CLAUDE.md 和 skills/jacky-opc/references/路径指南.md。
```
