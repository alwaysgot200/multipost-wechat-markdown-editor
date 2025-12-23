<div align="center">

[![multipost-md](./apps/web/public/mpmd/icon-256.png)](https://github.com/leaper-one/multipost-wechat-markdown-editor)

# MultiPost - Markdown 编辑器

> 一款高度简洁的微信 Markdown 编辑器

[![License](https://img.shields.io/github/license/leaper-one/multipost-wechat-markdown-editor)](LICENSE)
[![Node](https://img.shields.io/badge/node-%3E%3D22.16.0-brightgreen)](https://nodejs.org)
[![PNPM](https://img.shields.io/badge/pnpm-%3E%3D10-blue)](https://pnpm.io)

[在线使用](https://md.multipost.app) · [功能特性](#功能特性) · [快速开始](#快速开始) · [部署指南](#部署指南)

</div>

---

## 📖 项目介绍

MultiPost Markdown 编辑器是一款专为微信公众号内容创作打造的 Markdown 编辑器，让你不再为微信内容排版而发愁！只要你会基本的 Markdown 语法，就能做出一篇样式简洁而又美观大方的微信图文。

结合 [MultiPost 浏览器扩展](https://github.com/leaper-one/MultiPost-Extension)，你可以将编辑好的文章一键同步发布到知乎、微博、小红书、抖音等多个主流内容平台，极大提升内容创作效率。

**本项目基于 [doocs/md](https://github.com/doocs/md) 进行改造，特此感谢！**

### 在线编辑器

- 🌐 **Web 版**：[https://md.multipost.app](https://md.multipost.app)
- 🔌 **浏览器扩展**：支持 Chrome、Edge、Firefox
- 💻 **VSCode 插件**：正在开发中
- 🛠️ **uTools 插件**：支持离线使用

> 推荐使用 Chrome 或 Edge 浏览器，效果最佳。

---

## ✨ 功能特性

### 核心编辑功能

- ✅ **完整 Markdown 语法支持**：支持所有标准 Markdown 语法
- ✅ **数学公式渲染**：基于 KaTeX 的数学公式支持
- ✅ **代码高亮**：丰富的代码块高亮主题（基于 highlight.js）
- ✅ **图表渲染**：支持 Mermaid 图表和 PlantUML
- ✅ **GFM 警告块**：支持 GitHub 风格的警告块
- ✅ **Ruby 文本标注**：支持注音符号（日文假名等）
- ✅ **实时预览**：所见即所得的编辑体验

### AI 智能助手

- 🤖 **AI 文本生成**：智能创作、优化、翻译文本
- 🎨 **AI 图片生成**：AI 文生图功能
- ⚡ **快捷指令**：自定义 AI 快捷指令，提升效率
- 📝 **全文引用**：AI 可直接引用整篇文档上下文
- 🔧 **文本优化**：智能纠错、润色、总结

### 样式与主题

- 🎨 **多主题支持**：内置多种预设主题
- 🌈 **自定义主题色**：灵活定制主题颜色
- 📝 **自定义 CSS**：完全的样式控制能力
- 🎭 **代码块主题**：多种代码高亮主题可选
- 💻 **Mac 风格代码块**：仿 macOS 窗口样式
- 📱 **响应式设计**：完美适配移动端

### 媒体资源管理

- 📷 **多图床支持**：支持阿里云、腾讯云、七牛云、又拍云、GitHub、Cloudinary、Telegram 等
- 🗜️ **图片压缩**：上传时自动压缩图片
- 📊 **上传进度条**：实时显示上传进度
- 🔧 **自定义上传**：支持自定义图床配置

### 内容管理

- 💾 **草稿自动保存**：防止内容丢失
- 📂 **模板管理**：保存和复用文章模板
- 📋 **内容管理**：本地内容列表管理
- 📥 **导入/导出**：支持 Markdown、HTML 导出
- ⚙️ **配置同步**：导出/导入配置，跨设备同步

### 多平台集成

- 🌐 **Web 应用**：在线编辑器
- 🔌 **浏览器扩展**：Chrome/Firefox/Edge 扩展（支持 SidePanel）
- 💻 **VSCode 插件**：编辑器内预览（开发中）
- 🛠️ **uTools 插件**：离线桌面应用
- 🚀 **MultiPost 集成**：一键发布到多个平台

### 其他特性

- 🔢 **字数统计**：实时显示字数和阅读时间
- 🔗 **外链脚注**：微信外链自动转为底部引用
- 📑 **公众号名片**：支持插入公众号名片
- ⌨️ **丰富快捷键**：提升编辑效率
- 🌓 **深色模式**：护眼的深色主题

---

## 🚀 快速开始

### 环境要求

- **Node.js** >= 22.16.0
- **pnpm** >= 10.0.0

### 安装依赖

```bash
# 安装 pnpm（如果尚未安装）
npm install -g pnpm

# 安装项目依赖
pnpm install
```

### 启动开发服务器

```bash
# 启动 Web 应用开发服务器
pnpm start

# 访问 http://localhost:5173/md/
```

### 构建项目

```bash
# 构建 Web 应用（部署到根目录）
pnpm --filter @md/web run build:h5-netlify

# 构建浏览器扩展（Chrome）
pnpm --filter @md/web run ext:zip

# 构建浏览器扩展（Firefox）
pnpm --filter @md/web run firefox:zip

# 构建 VSCode 插件
pnpm --prefix ./apps/vscode run package

# 打包 uTools 插件
pnpm run utools:package
```

### 其他开发命令

```bash
# 类型检查
pnpm run type-check

# 代码检查和修复
pnpm run lint

# 浏览器扩展开发模式
pnpm --filter @md/web run ext:dev        # Chrome
pnpm --filter @md/web run firefox:dev    # Firefox

# 分析构建产物
pnpm --filter @md/web run build:analyze
```

---

## 📁 项目结构

本项目采用 **pnpm monorepo** 架构，使用 pnpm workspace 管理多个包：

```
multipost-wechat-markdown-editor/
├── apps/
│   ├── web/                    # Web 应用 & 浏览器扩展
│   │   ├── src/
│   │   │   ├── components/     # Vue 组件
│   │   │   ├── stores/         # Pinia 状态管理
│   │   │   ├── entrypoints/    # 浏览器扩展入口
│   │   │   ├── utils/          # 工具函数
│   │   │   └── views/          # 视图组件
│   │   ├── vite.config.ts      # Vite 配置
│   │   ├── wxt.config.ts       # WXT 扩展配置
│   │   └── package.json
│   ├── vscode/                 # VSCode 插件
│   │   ├── src/
│   │   ├── webpack.config.mjs
│   │   └── package.json
│   └── utools/                 # uTools 插件
│       ├── plugin.json
│       └── preload.js
├── packages/
│   ├── core/                   # 核心 Markdown 渲染器
│   │   ├── src/
│   │   │   ├── renderer/       # 渲染引擎
│   │   │   ├── extensions/     # Markdown 扩展
│   │   │   ├── theme/          # 主题系统
│   │   │   └── utils/          # 工具函数
│   │   └── package.json
│   ├── shared/                 # 共享代码
│   │   ├── src/
│   │   │   ├── configs/        # 配置
│   │   │   ├── constants/      # 常量
│   │   │   ├── types/          # 类型定义
│   │   │   ├── utils/          # 工具函数
│   │   │   └── editor/         # 编辑器配置
│   │   └── package.json
│   ├── config/                 # 项目级配置
│   ├── md-cli/                 # 命令行工具
│   └── example/                # Cloudflare Workers 示例
├── docker/                     # Docker 配置
│   ├── Dockerfile
│   ├── docker-compose-build.yml
│   └── nginx.conf
├── scripts/                    # 构建脚本
├── .github/workflows/          # GitHub Actions
├── pnpm-workspace.yaml         # pnpm workspace 配置
└── package.json                # 根 package.json
```

### 核心包说明

- **@md/core**：Markdown 渲染引擎，包含主题系统和扩展机制
- **@md/shared**：共享的配置、类型定义、工具函数和编辑器配置
- **@md/config**：项目级 TypeScript 和构建配置
- **@md/web**：Web 应用和浏览器扩展的主应用

---

## 🐳 部署指南

### 方式 1：使用 Docker（推荐）

#### 使用预构建镜像

```bash
# 拉取并运行镜像
docker run -d -p 8080:80 registry.cn-guangzhou.aliyuncs.com/leaperone/multipost-markdown-editor:latest

# 访问 http://localhost:8080
```

#### 本地构建镜像

```bash
# 使用 docker-compose 构建
docker compose -f ./docker/docker-compose-build.yml build

# 运行容器
docker run -d -p 8080:80 registry.cn-guangzhou.aliyuncs.com/leaperone/multipost-markdown-editor:latest
```

#### Docker 部署要点

- **Node 版本**：镜像使用 Node 22.18.0（与项目要求一致）
- **多阶段构建**：先构建应用，再打包到 nginx 镜像
- **静态资源缓存**：`/static` 目录资源缓存 7 天
- **Gzip 压缩**：启用 gzip 压缩，提升加载速度
- **时区设置**：默认使用 Asia/Shanghai 时区

### 方式 2：静态部署（Netlify/Vercel/Cloudflare Pages）

```bash
# 构建静态文件
pnpm --filter @md/web run build:h5-netlify

# 部署 apps/web/dist 目录到静态托管平台
```

**部署配置示例（netlify.toml）：**

```toml
[build]
command = "pnpm install && pnpm --filter @md/web run build:h5-netlify"
publish = "apps/web/dist"

[[redirects]]
from = "/*"
to = "/index.html"
status = 200
```

### 方式 3：Cloudflare Workers

```bash
# 部署到 Cloudflare Workers
cd apps/web
pnpm run wrangler:deploy
```

### 方式 4：使用 CLI 工具

```bash
# 安装 CLI 工具
pnpm run build:cli
cd packages/md-cli
npm install -g .

# 启动服务
md-cli

# 指定端口
md-cli port=8899

# 访问 http://127.0.0.1:8800/md/
```

### 部署要点总结

1. **环境变量**：根据部署环境设置 `SERVER_ENV`（可选值：NETLIFY、UTOOLS 等）
2. **路径配置**：Web 版默认部署到根目录 `/`，扩展版使用 `/md/`
3. **静态资源**：确保 `/static` 目录正确配置缓存策略
4. **HTTPS**：生产环境建议启用 HTTPS
5. **依赖版本**：严格使用 Node >= 22.16.0 和 pnpm >= 10

---

## 🛠️ 技术栈

### 前端框架

- **Vue 3**：渐进式 JavaScript 框架
- **Vite 7**：下一代前端构建工具
- **TypeScript**：类型安全的 JavaScript
- **Pinia**：Vue 3 状态管理
- **Tailwind CSS 4**：实用优先的 CSS 框架

### 编辑器

- **CodeMirror 6**：强大的代码编辑器
- **Marked**：Markdown 解析器
- **highlight.js**：代码语法高亮
- **KaTeX**：数学公式渲染
- **Mermaid**：图表渲染

### 工具库

- **Radix Vue / Reka UI**：无障碍 UI 组件
- **VueUse**：Vue 组合式 API 工具集
- **es-toolkit**：现代工具函数库
- **DOMPurify**：XSS 防护

### 构建与部署

- **pnpm**：快速、节省磁盘空间的包管理器
- **WXT**：浏览器扩展开发框架
- **Docker**：容器化部署
- **Cloudflare Workers**：边缘计算平台

---

## 📝 开发说明

### Monorepo 工作流

```bash
# 在特定包中运行命令
pnpm --filter @md/web <command>        # Web 应用
pnpm --filter @md/core <command>       # 核心包
pnpm --filter @md/shared <command>     # 共享包

# 简写方式
pnpm web <command>                     # Web 应用
pnpm vscode <command>                  # VSCode 插件
pnpm cli <command>                     # CLI 工具
```

### 代码规范

本项目使用 ESLint + Prettier 进行代码规范检查：

```bash
# 自动修复代码风格问题
pnpm run lint

# Git 提交前会自动运行 lint-staged
```

### 依赖管理

```bash
# 添加依赖到特定包
pnpm --filter @md/web add <package>

# 添加开发依赖
pnpm --filter @md/web add -D <package>

# 添加到根 workspace
pnpm add -w <package>
```

### 补丁管理

项目使用 pnpm patch 功能对某些依赖进行了补丁：

- `@codemirror/view@6.38.8`：自定义补丁在 `patches/` 目录

---

## 🤝 贡献指南

欢迎任何形式的贡献！请查看 [CONTRIBUTING.md](./CONTRIBUTING.md) 了解详细的贡献指南。

### 开发流程

1. Fork 本仓库
2. 创建功能分支：`git checkout -b feature/amazing-feature`
3. 提交更改：`git commit -m 'Add amazing feature'`
4. 推送到分支：`git push origin feature/amazing-feature`
5. 提交 Pull Request

---

## 📄 License

MIT License - 详见 [LICENSE](./LICENSE) 文件

---

## 🙏 致谢

- 感谢 [doocs/md](https://github.com/doocs/md) 提供的优秀基础
- 感谢所有贡献者的辛勤付出

---

<div align="center">

**如果这个项目对你有帮助，请给一个 ⭐️ Star 支持一下！**

</div>
