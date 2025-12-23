# API与配置参考

<cite>
**本文档中引用的文件**  
- [store.ts](file://packages/shared/src/configs/store.ts)
- [api.ts](file://packages/shared/src/configs/api.ts)
- [shortcut-key.ts](file://packages/shared/src/configs/shortcut-key.ts)
- [vite.config.ts](file://apps/web/vite.config.ts)
- [index.js](file://packages/md-cli/index.js)
- [util.js](file://packages/md-cli/util.js)
- [index.ts](file://packages/shared/src/configs/index.ts)
- [style.ts](file://packages/shared/src/configs/style.ts)
- [theme.ts](file://packages/shared/src/configs/theme.ts)
- [common.ts](file://packages/shared/src/types/common.ts)
- [ai-services-types.ts](file://packages/shared/src/types/ai-services-types.ts)
- [Dockerfile](file://docker/Dockerfile)
- [Dockerfile.standalone](file://docker/latest/Dockerfile.standalone)
</cite>

## 目录
1. [简介](#简介)
2. [配置系统概述](#配置系统概述)
3. [核心配置模块](#核心配置模块)
4. [Vite构建配置](#vite构建配置)
5. [md-cli命令行工具](#md-cli命令行工具)
6. [Docker部署配置](#docker部署配置)
7. [类型定义与接口](#类型定义与接口)
8. [配置优先级与加载机制](#配置优先级与加载机制)
9. [实际配置示例](#实际配置示例)

## 简介
本文档为多平台微信Markdown编辑器项目提供权威的API与配置参考。系统整理了所有可配置项，包括环境变量、Vite构建参数、CLI工具选项以及核心配置模块。文档详细说明了配置的优先级规则、加载时机，并提供完整的类型定义和实际使用示例。

## 配置系统概述
项目采用分层配置系统，通过多个配置文件和模块协同工作。配置系统主要分为以下几个部分：
- **持久化配置**：存储用户界面状态和偏好设置
- **服务端点配置**：定义第三方API的访问信息
- **快捷键映射**：处理平台特定的键盘快捷键
- **样式选项**：提供字体、颜色、主题等视觉配置
- **构建配置**：控制Vite构建过程和开发服务器行为

**配置优先级规则**：环境变量 > 配置文件 > 默认值

**配置加载时机**：
- 应用启动时加载基础配置
- 用户登录后加载个性化配置
- 运行时根据环境动态调整配置

**Section sources**
- [store.ts](file://packages/shared/src/configs/store.ts#L1-L36)
- [style.ts](file://packages/shared/src/configs/style.ts#L232-L244)
- [api.ts](file://packages/shared/src/configs/api.ts#L1-L47)

## 核心配置模块

### 持久化配置 (store.ts)
定义了应用中所有可持久化的状态和用户偏好设置，包括界面布局、主题、字体等。

```typescript
export const storeLabels: Record<string, string> = {
  isDark: `深色模式`,
  isEditOnLeft: `左侧编辑`,
  isMacCodeBlock: `Mac 代码块`,
  isShowLineNumber: `代码块行号`,
  isCiteStatus: `微信外链接底部引用状态`,
  isCountStatus: `字数统计状态`,
  isUseIndent: `使用缩进`,
  isUseJustify: `使用两端对齐`,
  isOpenRightSlider: `开启右侧滑块`,
  isOpenPostSlider: `开启右侧发布滑块`,
  showAIToolbox: `AI 工具箱状态`,
  theme: `主题`,
  fontFamily: `字体`,
  fontSize: `字体大小`,
  primaryColor: `自定义主题色`,
  codeBlockTheme: `代码块主题`,
  legend: `图注格式`,
  currentPostId: `当前文章 ID`,
  currentPostIndex: `当前文章索引`,
  posts: `内容列表`,
  cssContentConfig: `自定义 CSS`,
  titleList: `文章标题列表`,
  readingTime: `阅读时间`,
  isShowCssEditor: `显示 CSS 编辑器`,
  isShowInsertFormDialog: `显示插入表单对话框`,
  isShowInsertMpCardDialog: `显示插入公众号名片对话框`,
  isShowUploadImgDialog: `显示上传图片对话框`,
  aiDialogVisible: `AI 对话框可见`,
  aiImageDialogVisible: `AI 图片生成对话框可见`
}
```

**Section sources**
- [store.ts](file://packages/shared/src/configs/store.ts#L1-L36)

### 服务端点配置 (api.ts)
定义了与第三方服务通信的配置信息，包括GitHub和Gitee的访问凭证。

```typescript
export const githubConfig = {
  username: `bucketio`,
  repoList: Array.from({ length: 20 }, (_, i) => `img${i}`),
  branch: `main`,
  accessTokenList: [
    `ghp_sqQg5y7XC7Fy8XdoocsmdVEYRiRiTZPvbwzTL4MRjQc`,
    // ... 其他访问令牌
  ]
}

export const giteeConfig = {
  username: `filesss`,
  repoList: Array.from({ length: 20 }, (_, i) => `img${i}`),
  branch: `main`,
  accessTokenList: [
    `ed5fc9866bd6c2fdoocsmddd433f806fd2f399c`,
    // ... 其他访问令牌
  ]
}
```

**Section sources**
- [api.ts](file://packages/shared/src/configs/api.ts#L1-L47)

### 快捷键映射 (shortcut-key.ts)
处理平台特定的键盘快捷键映射，自动识别操作系统并提供相应的快捷键符号。

```typescript
const isMac = /Mac/i.test(navigator.userAgent)

export const ctrlKey = `Mod`
export const altKey = `Alt`
export const shiftKey = `Shift`

export const ctrlSign = isMac ? `⌘` : `Ctrl`
export const altSign = isMac ? `⌥` : `Alt`
export const shiftSign = isMac ? `⇧` : `Shift`
```

**Section sources**
- [shortcut-key.ts](file://packages/shared/src/configs/shortcut-key.ts#L1-L10)

### 样式与主题配置
整合了所有与视觉呈现相关的配置选项。

#### 字体与字号选项
提供多种字体和字号选择，满足不同用户的阅读偏好。

```typescript
export const fontFamilyOptions: IConfigOption[] = [
  {
    label: `无衬线`,
    value: `-apple-system-font,BlinkMacSystemFont, Helvetica Neue, PingFang SC, Hiragino Sans GB , Microsoft YaHei UI , Microsoft YaHei ,Arial,sans-serif`,
    desc: `字体123Abc`
  },
  {
    label: `衬线`,
    value: `Optima-Regular, Optima, PingFangSC-light, PingFangTC-light, 'PingFang SC', Cambria, Cochin, Georgia, Times, 'Times New Roman', serif`,
    desc: `字体123Abc`
  },
  {
    label: `等宽`,
    value: `Menlo, Monaco, 'Courier New', monospace`,
    desc: `字体123Abc`
  }
]

export const fontSizeOptions: IConfigOption[] = [
  { label: `14px`, value: `14px`, desc: `更小` },
  { label: `15px`, value: `15px`, desc: `稍小` },
  { label: `16px`, value: `16px`, desc: `推荐` },
  { label: `17px`, value: `17px`, desc: `稍大` },
  { label: `18px`, value: `18px`, desc: `更大` }
]
```

#### 主题配置
定义了可用的主题选项及其元数据。

```typescript
export const themeOptions: IConfigOption<ThemeName>[] = [
  { label: `经典`, value: `default`, desc: `` },
  { label: `优雅`, value: `grace`, desc: `@brzhang` },
  { label: `简洁`, value: `simple`, desc: `@okooo5km` }
]
```

#### 默认样式配置
定义了应用的默认样式设置。

```typescript
export const defaultStyleConfig = {
  isCiteStatus: false,
  isMacCodeBlock: true,
  isShowLineNumber: false,
  isCountStatus: false,
  theme: themeOptions[0].value,
  fontFamily: fontFamilyOptions[0].value,
  fontSize: fontSizeOptions[2].value,
  primaryColor: colorOptions[0].value,
  codeBlockTheme: codeBlockThemeOptions[23].value,
  legend: legendOptions[3].value
}
```

**Section sources**
- [style.ts](file://packages/shared/src/configs/style.ts#L4-L244)
- [theme.ts](file://packages/shared/src/configs/theme.ts#L1-L42)

## Vite构建配置
Vite构建系统通过`vite.config.ts`文件进行配置，支持多种部署环境和构建选项。

### 基础配置
```typescript
export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd())

  return {
    base,
    define: { process },
    envPrefix: [`VITE_`, `CF_`],
    // ... 其他配置
  }
})
```

### 插件配置
- `vue()`: Vue.js框架支持
- `tailwindcss()`: Tailwind CSS支持
- `vueDevTools()`: Vue开发者工具集成
- `nodePolyfills()`: Node.js API浏览器兼容
- `VitePluginRadar`: 分析工具集成
- `visualizer`: 构建产物分析

### 构建优化
- 代码分割策略：按依赖包进行分割
- 输出文件命名：包含哈希值以支持缓存
- 外部依赖：`mermaid`库作为外部依赖处理

### 环境变量
- `SERVER_ENV`: 服务器环境 (`NETLIFY`, `UTOOLS`)
- `CF_WORKERS`: Cloudflare Workers标识
- `CF_PAGES`: Cloudflare Pages标识
- `VITE_LAUNCH_EDITOR`: 指定代码编辑器

**Section sources**
- [vite.config.ts](file://apps/web/vite.config.ts#L1-L92)

## md-cli命令行工具
`md-cli`是一个独立的命令行工具，用于本地运行Markdown编辑器服务。

### 命令行接口
```bash
# 基本用法
npx @md/md-cli [options]

# 或全局安装后使用
npm install -g @md/md-cli
md-cli [options]
```

### 支持的参数
| 参数 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `--port` | number | 8800 | 服务监听端口 |
| `--spaceId` | string | - | 云存储空间ID |
| `--clientSecret` | string | - | 云存储客户端密钥 |

### 参数解析逻辑
- 布尔值：`true`/`false`字符串自动转换
- 数字值：可解析的数字字符串转换为数字类型
- 无值参数：视为`true`

### 服务启动流程
1. 解析命令行参数
2. 检测端口可用性
3. 启动HTTP服务器
4. 监听SIGINT和SIGTERM信号进行优雅关闭

**Section sources**
- [index.js](file://packages/md-cli/index.js#L1-L58)
- [util.js](file://packages/md-cli/util.js#L42-L59)

## Docker部署配置
项目提供多种Docker部署方案，适应不同的使用场景。

### 基础Docker镜像 (Dockerfile)
基于Alpine Linux构建，包含Node.js环境和构建工具。

```dockerfile
FROM node:20.18.1-alpine3.20 AS base
RUN apk update --no-cache && apk add --no-cache \
    tzdata \
    make \
    g++ \
    pixman-dev \
    cairo-dev \
    pango-dev \
    pkgconfig \
    curl

# 安装pnpm
RUN npm install -g pnpm@latest

# 构建阶段
FROM base AS builder
ENV NODE_OPTIONS="--max-old-space-size=8192"
RUN pnpm install --frozen-lockfile
RUN pnpm --filter @md/web run build:h5-netlify:only

# 最终阶段
FROM nginx:alpine AS final
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/apps/web/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### 独立运行Docker镜像 (Dockerfile.standalone)
包含Go编写的服务器二进制文件，实现最小化部署。

```dockerfile
ARG VER_GOLANG=1.25.2-alpine
ARG VER_ALPINE=3.20

FROM --platform=$BUILDPLATFORM "doocs/md:latest-assets" AS assets
FROM --platform=$BUILDPLATFORM "golang:$VER_GOLANG" AS gobuilder
# ... Go构建过程
FROM --platform=$TARGETPLATFORM "alpine:$VER_ALPINE"
COPY --from=gobuilder /app/md.minify /bin/md
EXPOSE 80
CMD ["md"]
```

### 环境变量
- `TZ`: 时区设置 (`Asia/Shanghai`)
- `NODE_OPTIONS`: Node.js运行时选项

**Section sources**
- [Dockerfile](file://docker/Dockerfile#L1-L39)
- [Dockerfile.standalone](file://docker/latest/Dockerfile.standalone#L1-L23)

## 类型定义与接口

### 通用配置选项接口
```typescript
export interface IConfigOption<VT = string> {
  label: string
  value: VT
  desc: string
}
```

### 渲染器选项接口
```typescript
export interface IOpts {
  legend?: string
  citeStatus?: boolean
  countStatus?: boolean
  isMacCodeBlock?: boolean
  isShowLineNumber?: boolean
}
```

### 账号与文章接口
```typescript
export interface PostAccount {
  avatar: string
  displayName: string
  home: string
  icon: string
  supportTypes: string[]
  title: string
  type: string
  uid: string
  checked: boolean
  status?: string
  error?: string
}

export interface Post {
  title: string
  desc: string
  thumb: string
  content: string
  markdown: string
  accounts: PostAccount[]
}
```

### AI服务接口
```typescript
export interface ServiceOption {
  value: string
  label: string
  endpoint: string
  models: string[]
}

export interface ImageServiceOption {
  value: string
  label: string
  endpoint: string
  models: string[]
}
```

**Section sources**
- [common.ts](file://packages/shared/src/types/common.ts#L1-L80)
- [ai-services-types.ts](file://packages/shared/src/types/ai-services-types.ts#L1-L14)

## 配置优先级与加载机制

### 配置优先级规则
配置系统遵循以下优先级顺序（从高到低）：
1. **环境变量**：通过`process.env`或`import.meta.env`注入
2. **配置文件**：项目根目录下的`.env`文件或特定配置文件
3. **默认值**：代码中定义的默认配置

### 配置加载时机
- **构建时配置**：在Vite构建过程中确定，影响打包结果
- **启动时配置**：应用启动时加载，影响运行时行为
- **运行时配置**：用户交互过程中动态调整

### 配置模块导出
`packages/shared/src/configs/index.ts`统一导出所有配置模块：

```typescript
export * from './ai-service-options'
export * from './api'
export * from './prefix'
export * from './shortcut-key'
export * from './store'
export * from './style'
export * from './theme'
```

**Section sources**
- [index.ts](file://packages/shared/src/configs/index.ts#L1-L8)
- [vite.config.ts](file://apps/web/vite.config.ts#L24-L92)

## 实际配置示例

### 开发环境配置 (.env.development)
```env
VITE_LAUNCH_EDITOR=code
SERVER_ENV=UTOOLS
ANALYZE=true
```

### 生产环境配置 (.env.production)
```env
SERVER_ENV=NETLIFY
CF_PAGES=1
```

### md-cli使用示例
```bash
# 启动服务在8080端口
npx @md/md-cli --port=8080

# 配置云存储
npx @md/md-cli --port=8800 --spaceId=your-space-id --clientSecret=your-client-secret

# 组合使用
md-cli --port=3000 --spaceId=abc123 --clientSecret=secret456
```

### Docker部署示例
```bash
# 构建镜像
docker build -t md-editor .

# 运行容器
docker run -d -p 80:80 md-editor

# 指定环境变量运行
docker run -d -p 80:80 -e TZ=Asia/Shanghai md-editor
```

### 自定义主题配置
```typescript
// 自定义主题配置示例
const customTheme = {
  ...defaultStyleConfig,
  theme: 'grace',
  fontFamily: fontFamilyOptions[1].value,
  fontSize: '17px',
  primaryColor: '#009874',
  isMacCodeBlock: false
}
```

**Section sources**
- [vite.config.ts](file://apps/web/vite.config.ts#L17-L22)
- [index.js](file://packages/md-cli/index.js#L17-L18)
- [style.ts](file://packages/shared/src/configs/style.ts#L232-L244)