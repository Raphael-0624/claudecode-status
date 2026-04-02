# Claude Code Status Bar

[![GitHub stars](https://img.shields.io/github/stars/rockelbel/claudecode-status?style=flat-square)](https://github.com/rockelbel/claudecode-status/stargazers)
[![License](https://img.shields.io/github/license/rockelbel/claudecode-status?style=flat-square)](LICENSE)

为 [Claude Code](https://claude.ai/code) 定制的底部状态栏，提供丰富的开发环境信息展示。

## ✨ 功能特性

### 默认启用
- **📦 项目类型检测** - 自动识别 Node.js / Python / Rust / Go / Java 等项目
- **📋 CLAUDE.md 指示** - 检测项目根目录是否有 CLAUDE.md 文件
- **📊 Token 使用量** - 可视化进度条显示当前会话 token 使用情况

### 可选模块
- **🔀 Git 信息** - 分支名、未提交文件数、与远程同步状态
- **🕐 时间显示** - 当前时间
- **💾 系统资源** - 内存使用率
- **☁️ 云环境** - 自动识别阿里云等云环境

### 主题颜色
支持 10 种配色主题：`gray`, `orange`, `blue`, `teal`, `green`, `lavender`, `rose`, `gold`, `slate`, `cyan`

## 🚀 快速开始

### 方法一：一键 Prompt（推荐）

复制以下内容，直接粘贴给 Claude Code：

```
帮我安装 Claude Code 状态栏。执行以下命令：

```bash
curl -fsSL https://raw.githubusercontent.com/rockelbel/claudecode-status/main/install.sh | bash
```

安装过程中会交互式询问主题颜色和要启用的功能模块。
```

### 方法二：手动下载安装

```bash
# 下载安装器
curl -fsSL -o install.sh https://raw.githubusercontent.com/rockelbel/claudecode-status/main/install.sh

# 执行安装（交互式配置）
bash install.sh
```

### 方法三：本地克隆

```bash
# 克隆仓库
git clone https://github.com/rockelbel/claudecode-status.git
cd claudecode-status

# 执行安装
bash install.sh
```

## 📸 效果预览

### 基础配置（默认）
```
kimi-k2.5 | 📦 Node | 📁my-project | 📋CLAUDE | █░░░░░░░░░ 10% of 200k
```

### 完整配置
```
kimi-k2.5 | 📦 Node | 📁my-project | 🔀main ⬆️3 | 📋CLAUDE | 🕐14:32 | 💾45% | ☁️阿里云 | ████░░░░░░ 45% of 200k
```

## 🎨 主题展示

| 主题 | 预览 |
|------|------|
| blue | ![blue](examples/blue.png) |
| green | ![green](examples/green.png) |
| rose | ![rose](examples/rose.png) |

## 🔧 重新配置

运行安装器重新选择配置：

```bash
~/.claude/scripts/status-bar.sh --reconfigure
# 或重新运行安装器
bash install.sh
```

## 🗑️ 卸载

编辑 `~/.claude/settings.json`，删除 `statusLine` 配置项：

```bash
# 或使用 jq
jq 'del(.statusLine)' ~/.claude/settings.json > ~/.claude/settings.json.tmp && \
  mv ~/.claude/settings.json.tmp ~/.claude/settings.json
```

## 📁 项目结构

```
claudecode-status/
├── install.sh                    # 交互式安装器
├── README.md                     # 本文档
├── src/
│   └── templates/
│       └── status-bar.template.sh # 状态栏脚本模板
├── examples/                     # 示例截图
└── docs/                         # 文档
```

## 🛠️ 工作原理

1. **安装器** (`install.sh`) 交互式收集用户偏好
2. 根据选择从模板生成定制化的 `status-bar.sh`
3. 配置 `~/.claude/settings.json` 指向生成的脚本
4. Claude Code 每次显示状态栏时调用该脚本

## 📝 自定义开发

如果你想修改生成的脚本：

```bash
# 直接编辑生成的脚本
nano ~/.claude/scripts/status-bar.sh

# 修改后重启 Claude Code 生效
```

## 🤝 贡献

欢迎提交 Issue 和 PR！

1. Fork 本仓库
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add amazing feature'`)
4. 推送分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 🙏 致谢

- 灵感来自 Claude Code 官方状态栏示例
- 项目类型检测逻辑参考多种开源工具

---

**Happy Coding!** 🎉
