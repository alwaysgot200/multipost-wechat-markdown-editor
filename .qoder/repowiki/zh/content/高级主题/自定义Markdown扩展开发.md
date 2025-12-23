# 自定义Markdown扩展开发

<cite>
**本文档引用的文件**  
- [alert.ts](file://packages/core/src/extensions/alert.ts)
- [katex.ts](file://packages/core/src/extensions/katex.ts)
- [plantuml.ts](file://packages/core/src/extensions/plantuml.ts)
- [renderer-impl.ts](file://packages/core/src/renderer/renderer-impl.ts)
- [footnotes.ts](file://packages/core/src/extensions/footnotes.ts)
- [toc.ts](file://packages/core/src/extensions/toc.ts)
- [slider.ts](file://packages/core/src/extensions/slider.ts)
- [markup.ts](file://packages/core/src/extensions/markup.ts)
- [ruby.ts](file://packages/core/src/extensions/ruby.ts)
- [index.ts](file://packages/core/src/extensions/index.ts)
- [renderer-types.ts](file://packages/shared/src/types/renderer-types.ts)
- [common.ts](file://packages/shared/src/types/common.ts)
</cite>

## 目录
1. [引言](#引言)
2. [扩展系统架构](#扩展系统架构)
3. [核心扩展模块分析](#核心扩展模块分析)
4. [扩展开发实践](#扩展开发实践)
5. [扩展集成与执行流程](#扩展集成与执行流程)
6. [扩展兼容性与执行顺序](#扩展兼容性与执行顺序)
7. [复杂内容结构构建](#复杂内容结构构建)
8. [结论](#结论)

## 引言

本技术文档深入探讨了在`multipost-wechat-markdown-editor`项目中开发自定义Markdown扩展的完整流程。文档以`alert.ts`、`katex.ts`和`plantuml.ts`等实际扩展模块为例，详细阐述了如何定义新的语法解析规则，并将其注册到`marked`解析器中。我们将解析每个扩展模块的导出结构（如`markedAlert`、`MDKatex`）及其在`renderer-impl.ts`中的集成方式，为开发者提供一个全面的扩展开发指南。

## 扩展系统架构

该项目的Markdown扩展系统基于`marked`库构建，通过其扩展API实现自定义语法的解析和渲染。所有扩展模块位于`packages/core/src/extensions/`目录下，通过`index.ts`文件统一导出，形成了一个模块化的扩展体系。

```mermaid
graph TB
subgraph "扩展模块"
A[alert.ts]
B[katex.ts]
C[plantuml.ts]
D[footnotes.ts]
E[toc.ts]
F[slider.ts]
G[markup.ts]
H[ruby.ts]
end
subgraph "核心集成"
I[renderer-impl.ts]
end
subgraph "类型定义"
J[common.ts]
K[renderer-types.ts]
end
A --> I
B --> I
C --> I
D --> I
E --> I
F --> I
G --> I
H --> I
J --> A
J --> B
J --> C
K --> I
```

**图源**  
- [alert.ts](file://packages/core/src/extensions/alert.ts)
- [katex.ts](file://packages/core/src/extensions/katex.ts)
- [plantuml.ts](file://packages/core/src/extensions/plantuml.ts)
- [renderer-impl.ts](file://packages/core/src/renderer/renderer-impl.ts)
- [common.ts](file://packages/shared/src/types/common.ts)
- [renderer-types.ts](file://packages/shared/src/types/renderer-types.ts)

**本节来源**  
- [index.ts](file://packages/core/src/extensions/index.ts)

## 核心扩展模块分析

### 警报扩展 (alert.ts)

`markedAlert`扩展实现了GitHub Flavored Markdown (GFM) 风格的警报块功能，支持`[!note]`、`[!tip]`、`[!warning]`等多种变体。

```mermaid
sequenceDiagram
participant Parser as Markdown解析器
participant WalkTokens as walkTokens
participant Tokenizer as tokenizer
participant Renderer as renderer
Parser->>WalkTokens : 处理blockquote类型token
WalkTokens->>WalkTokens : 检查是否匹配警报语法
alt 匹配成功
WalkTokens->>Token : 修改token.type为"alert"
WalkTokens->>Token : 添加meta元数据
WalkTokens->>Token : 清理原始文本中的标记
end
Parser->>Tokenizer : 处理 : : : 容器语法
Tokenizer->>Tokenizer : 匹配 : : : variant\ncontent\n : : :
Tokenizer->>Token : 创建alert类型token
Tokenizer->>Token : 添加meta元数据
Parser->>Renderer : 渲染alert token
Renderer->>Renderer : 解析内部tokens
Renderer->>Renderer : 生成带图标的HTML块引用
```

**图源**  
- [alert.ts](file://packages/core/src/extensions/alert.ts#L10-L121)

**本节来源**  
- [alert.ts](file://packages/core/src/extensions/alert.ts)
- [common.ts](file://packages/shared/src/types/common.ts#L22-L56)

### 数学公式扩展 (katex.ts)

`MDKatex`扩展支持使用`$...$`和`$$...$$`语法渲染数学公式，同时兼容LaTeX风格的`\(...\)`和`\[...\]`语法。

```mermaid
classDiagram
class MDKatexOptions {
+nonStandard? : boolean
}
class KatexExtension {
-inlineRule : RegExp
-blockRule : RegExp
-inlineLatexRule : RegExp
-blockLatexRule : RegExp
+createRenderer(display : boolean, withStyle : boolean) : Function
+inlineKatex(options : MarkedKatexOptions, renderer : any) : Extension
+blockKatex(options : MarkedKatexOptions, renderer : any) : Extension
+inlineLatexKatex(options : MarkedKatexOptions, renderer : any) : Extension
+blockLatexKatex(options : MarkedKatexOptions, renderer : any) : Extension
+MDKatex(options : MarkedKatexOptions, withStyle : boolean) : MarkedExtension
}
class Renderer {
+texReset() : void
+tex2svg(text : string, options : object) : HTMLElement
}
MDKatexOptions <|-- KatexExtension
KatexExtension --> Renderer : "使用"
```

**图源**  
- [katex.ts](file://packages/core/src/extensions/katex.ts#L3-L162)

**本节来源**  
- [katex.ts](file://packages/core/src/extensions/katex.ts)

### 流程图扩展 (plantuml.ts)

`markedPlantUML`扩展允许用户通过代码块语法嵌入PlantUML图表，支持SVG和PNG两种渲染格式。

```mermaid
flowchart TD
Start([开始]) --> CheckSyntax["检查
```plantuml代码块语法"]
    CheckSyntax --> Match{"匹配成功?"}
    Match -->|是| ExtractCode["提取PlantUML代码"]
    Match -->|否| ProcessExisting["处理现有代码块"]
    ExtractCode --> ValidateCode["验证代码是否包含@startuml"]
    ValidateCode --> AddMarkers["添加@startuml/@enduml标记"]
    AddMarkers --> Compress["使用Deflate压缩代码"]
    Compress --> Encode["使用PlantUML Base64编码"]
    Encode --> GenerateURL["生成PlantUML服务器URL"]
    GenerateURL --> CheckInline{"是否启用内联SVG?"}
    CheckInline -->|是| FetchSVG["异步获取SVG内容"]
    CheckInline -->|否| CreateImg["创建图片标签"]
    FetchSVG --> ModifySVG["移除SVG固定尺寸"]
    ModifySVG --> EmbedSVG["内嵌SVG内容"]
    CreateImg --> ReturnHTML["返回HTML"]
    EmbedSVG --> ReturnHTML
    ProcessExisting --> ReturnHTML
    ReturnHTML --> End([结束])
```

**图源**  
- [plantuml.ts](file://packages/core/src/extensions/plantuml.ts#L239-L289)

**本节来源**  
- [plantuml.ts](file://packages/core/src/extensions/plantuml.ts)

## 扩展开发实践

### 定义新的语法解析规则

在`marked`扩展中，定义新的语法解析规则主要通过`extensions`数组中的`tokenizer`函数实现。每个`tokenizer`需要定义`name`、`level`（`block`或`inline`）、`start`和`tokenizer`方法。

```mermaid
flowchart TD
DefineRule["定义扩展规则"] --> DefineName["指定扩展名称"]
DefineName --> DefineLevel["指定解析级别"]
DefineLevel --> DefineStart["实现start函数"]
DefineStart --> DefineTokenizer["实现tokenizer函数"]
DefineTokenizer --> MatchRegex["使用正则表达式匹配"]
MatchRegex --> CreateToken["创建token对象"]
CreateToken --> SetType["设置token.type"]
SetType --> SetRaw["设置token.raw"]
SetType --> SetText["设置token.text"]
SetType --> SetMeta["设置自定义元数据"]
CreateToken --> ReturnToken["返回token对象"]
ReturnToken --> Integrate["集成到marked解析器"]
```

**本节来源**  
- [markup.ts](file://packages/core/src/extensions/markup.ts)
- [ruby.ts](file://packages/core/src/extensions/ruby.ts)

### 实现全新的数学公式扩展

以下是一个实现全新数学公式扩展的步骤示例：

1. **定义扩展选项接口**：
```typescript
export interface MathFormulaOptions {
  className?: string;
  displayMode?: boolean;
}
```

2. **创建正则表达式匹配规则**：
```typescript
const inlineMathRule = /^\$(.*?)\$/;
const blockMathRule = /^\$\$(.*?)\$\$/;
```

3. **实现tokenizer函数**：
```typescript
{
  name: 'mathFormula',
  level: 'inline',
  start(src: string) {
    return src.match(/\$/)?.index;
  },
  tokenizer(src: string) {
    const match = inlineMathRule.exec(src);
    if (match) {
      return {
        type: 'mathFormula',
        raw: match[0],
        text: match[1],
        displayMode: false
      };
    }
  },
  renderer(token: any) {
    // 渲染逻辑
  }
}
```

4. **实现渲染器**：
```typescript
renderer(token: any) {
  const { text, displayMode } = token;
  const formula = katex.renderToString(text, { displayMode });
  const className = displayMode ? 'math-block' : 'math-inline';
  return `<span class="${className}">${formula}</span>`;
}
```

**本节来源**  
- [katex.ts](file://packages/core/src/extensions/katex.ts)
- [common.ts](file://packages/shared/src/types/common.ts)

## 扩展集成与执行流程

### 扩展注册与注入

所有扩展通过`marked.use()`方法在`initRenderer`流程中注入。`renderer-impl.ts`文件负责初始化渲染器并注册所有扩展。

```mermaid
sequenceDiagram
participant Init as initRenderer
participant Marked as marked.use()
participant Alert as markedAlert()
participant KaTeX as MDKaTeX()
participant PlantUML as markedPlantUML()
Init->>Marked : marked.use(markedSlider())
Init->>Alert : markedAlert()
Init->>Marked : marked.use(返回的扩展)
Init->>KaTeX : MDKaTeX({ nonStandard : true }, true)
Init->>Marked : marked.use(返回的扩展)
Init->>PlantUML : markedPlantUML({ inlineSvg : true })
Init->>Marked : marked.use(返回的扩展)
Init->>Marked : marked.use(自定义扩展)
```

**图源**  
- [renderer-impl.ts](file://packages/core/src/renderer/renderer-impl.ts#L20-L372)

**本节来源**  
- [renderer-impl.ts](file://packages/core/src/renderer/renderer-impl.ts)

### 渲染器处理流程

当Markdown文本被解析时，`marked`解析器会按照预定义的顺序处理各种token类型，每个注册的扩展都有机会处理匹配的token。

```mermaid
flowchart TD
StartParse["开始解析Markdown"] --> ParseTokens["解析为tokens"]
ParseTokens --> ProcessTokens["处理tokens"]
ProcessTokens --> WalkTokens["执行walkTokens钩子"]
WalkTokens --> ModifyToken["修改token类型和元数据"]
ProcessTokens --> RenderTokens["渲染tokens"]
RenderTokens --> CheckType{"检查token.type"}
CheckType --> |alert| RenderAlert["使用alert渲染器"]
CheckType --> |inlineKatex| RenderInlineKatex["使用inlineKatex渲染器"]
CheckType --> |blockKatex| RenderBlockKatex["使用blockKatex渲染器"]
CheckType --> |plantuml| RenderPlantUML["使用plantuml渲染器"]
CheckType --> |其他| RenderDefault["使用默认渲染器"]
RenderAlert --> GenerateHTML["生成HTML"]
RenderInlineKatex --> GenerateHTML
RenderBlockKatex --> GenerateHTML
RenderPlantUML --> GenerateHTML
RenderDefault --> GenerateHTML
GenerateHTML --> ReturnHTML["返回最终HTML"]
```

**本节来源**  
- [renderer-impl.ts](file://packages/core/src/renderer/renderer-impl.ts)
- [alert.ts](file://packages/core/src/extensions/alert.ts)
- [katex.ts](file://packages/core/src/extensions/katex.ts)
- [plantuml.ts](file://packages/core/src/extensions/plantuml.ts)

## 扩展兼容性与执行顺序

### 扩展之间的依赖关系

扩展的执行顺序至关重要，某些扩展需要在其他扩展之前执行才能正确工作。例如，`markedSlider`需要在`markedAlert`之前执行，以确保滑动图片语法不会被误识别为警报块。

```mermaid
graph LR
A[markedSlider] --> B[markedAlert]
B --> C[MDKaTeX]
C --> D[markedFootnotes]
D --> E[markedToc]
E --> F[markedPlantUML]
style A fill:#f9f,stroke:#333
style B fill:#f9f,stroke:#333
style C fill:#f9f,stroke:#333
style D fill:#f9f,stroke:#333
style E fill:#f9f,stroke:#333
style F fill:#f9f,stroke:#333
```

**本节来源**  
- [renderer-impl.ts](file://packages/core/src/renderer/renderer-impl.ts#L20-L372)

### 执行顺序依赖

在`renderer-impl.ts`中，扩展的注册顺序决定了它们的执行优先级。`walkTokens`钩子按照注册顺序执行，而`extensions`中的`tokenizer`则根据`start`函数返回的索引值决定优先级。

```mermaid
sequenceDiagram
participant Parser as Markdown解析器
participant Ext1 as 扩展1 (walkTokens)
participant Ext2 as 扩展2 (walkTokens)
participant Ext3 as 扩展3 (tokenizer)
Parser->>Ext1 : 执行walkTokens
Ext1->>Ext1 : 修改token
Parser->>Ext2 : 执行walkTokens
Ext2->>Ext2 : 修改token
Parser->>Ext3 : 调用tokenizer.start()
Ext3->>Parser : 返回匹配索引
Parser->>Ext3 : 调用tokenizer()
Ext3->>Parser : 返回token
```

**本节来源**  
- [renderer-impl.ts](file://packages/core/src/renderer/renderer-impl.ts)
- [alert.ts](file://packages/core/src/extensions/alert.ts#L49-L86)
- [plantuml.ts](file://packages/core/src/extensions/plantuml.ts#L282-L287)

## 复杂内容结构构建

### Front-matter机制

`front-matter`扩展允许在Markdown文档开头使用YAML格式的元数据，这些元数据可以用于文章配置、SEO信息等。

```mermaid
flowchart TD
Start["---\ntitle: 文章标题\ndate: 2023-01-01\n---\n"] --> Parse["解析front-matter"]
Parse --> Extract["提取YAML数据"]
Extract --> Store["存储到yamlData对象"]
Store --> Process["处理剩余Markdown内容"]
Process --> Render["渲染正文"]
Render --> Combine["组合元数据和正文"]
Combine --> Output["输出最终结果"]
```

**本节来源**  
- [renderer-impl.ts](file://packages/core/src/renderer/renderer-impl.ts#L88-L109)

### 脚注机制

`markedFootnotes`扩展实现了脚注功能，允许在文档中添加引用标记并在文末生成脚注列表。

```mermaid
classDiagram
class FootnoteMap {
-fnMap : Map<string, MapContent>
}
class FootnoteDef {
+name : "footnoteDef"
+level : "block"
+start(src : string) : number | undefined
+tokenizer(src : string) : Token | undefined
+renderer(token : Tokens.Generic) : string
}
class FootnoteRef {
+name : "footnoteRef"
+level : "inline"
+start(src : string) : number | undefined
+tokenizer(src : string) : Token | undefined
+renderer(token : Tokens.Generic) : string
}
class RendererAPI {
+buildFootnotes() : string
}
FootnoteMap --> FootnoteDef : "使用"
FootnoteMap --> FootnoteRef : "使用"
FootnoteDef --> RendererAPI : "生成"
FootnoteRef --> RendererAPI : "生成"
```

**图源**  
- [footnotes.ts](file://packages/core/src/extensions/footnotes.ts#L17-L89)

**本节来源**  
- [footnotes.ts](file://packages/core/src/extensions/footnotes.ts)
- [renderer-impl.ts](file://packages/core/src/renderer/renderer-impl.ts#L136-L185)

### 滑块机制

`markedSlider`扩展实现了水平滑动图片容器，特别适用于微信公众号等移动端场景。

```mermaid
flowchart TD
Input["<![alt1](url1),![alt2](url2),![alt3](url3)>"] --> Parse["解析滑动语法"]
Parse --> Extract["提取图片信息"]
Extract --> Validate["验证图片数量"]
Validate --> Generate["生成滑动容器HTML"]
Generate --> Style["应用微信兼容样式"]
Style --> Output["输出最终HTML"]
```

**本节来源**  
- [slider.ts](file://packages/core/src/extensions/slider.ts)

## 结论

通过分析`multipost-wechat-markdown-editor`项目的扩展系统，我们深入了解了如何开发自定义Markdown扩展。关键要点包括：

1. **扩展结构**：每个扩展模块导出一个函数，该函数返回符合`MarkedExtension`接口的对象。
2. **语法解析**：使用正则表达式定义语法匹配规则，并通过`tokenizer`函数生成token。
3. **渲染处理**：通过`renderer`函数将token转换为HTML输出。
4. **集成方式**：在`initRenderer`流程中使用`marked.use()`方法注入扩展。
5. **执行顺序**：扩展的注册顺序影响其执行优先级，需要注意依赖关系。

开发者可以基于这些模式创建新的扩展，如支持Mermaid图表、流程图、甘特图等，从而极大地丰富Markdown的表达能力。