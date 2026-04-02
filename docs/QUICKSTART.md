# 一键使用 Claude Code Status Bar

复制以下内容，直接粘贴给 Claude Code：

---

```
帮我安装 Claude Code 状态栏。执行以下命令：

```bash
curl -fsSL https://raw.githubusercontent.com/rockelbel/claudecode-status/main/install.sh | bash
```

安装过程中会交互式询问：
1. 主题颜色（blue, green, rose, gold 等 10 种可选）
2. 要启用的功能模块（Git信息、时间、系统资源、云环境等）

默认启用：项目类型检测 + CLAUDE.md 指示 + Token 使用量
```

---

## 功能说明

安装完成后，状态栏将显示：

| 图标 | 含义 |
|------|------|
| 📦 | 项目类型（Node/Python/Rust/Go/Java等） |
| 📋 | 当前目录或父目录存在 CLAUDE.md |
| 🔀 | Git 分支名 |
| ✅ | 无未提交文件 |
| 📝N | N 个未提交文件 |
| ⬆️N | N 个提交待推送 |
| ⬇️N | N 个更新待拉取 |
| 🕐 | 当前时间 |
| 💾N% | 内存使用率 |
| ☁️ | 云环境（阿里云等） |
| █░░░░░░░░░ | Token 使用量进度条 |

## 示例效果

```
# 基础配置
kimi-k2.5 | 📦 Node | 📁my-project | 📋CLAUDE | █░░░░░░░░░ 10% of 200k

# 完整配置
kimi-k2.5 | 📦 Node | 📁my-project | 🔀main ⬆️3 | 📋CLAUDE | 🕐14:32 | 💾45% | ☁️阿里云 | ████░░░░░░ 45% of 200k
```

## 重新配置

如需修改配置，再次运行：
```bash
curl -fsSL https://raw.githubusercontent.com/rockelbel/claudecode-status/main/install.sh | bash
```

## 卸载

删除 `~/.claude/settings.json` 中的 `statusLine` 配置项即可。
