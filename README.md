# 灵境行者 Mod（SpiritualRealmWalker）

以小说《灵境行者》为主题制作的《杀戮尖塔2》角色Mod。当前角色为“元始天尊”，职业为“夜游神”。玩法、数值和卡牌设计见 [DESIGN.md](DESIGN.md)，历史过程与验证证据见 [DEVLOG.md](DEVLOG.md)。

## 当前生效版本

- 人物选择背景使用**日月星本源动态试用版**：人物与黑月共同悬浮，衣袍、发梢和星光起伏，周围星云向人物汇聚。底图为用户已确认的3840×2400静态定稿；当前动态已部署，GPU自动播放、循环、人物保护及完整显示检查通过，动态效果和性能尚待游戏内确认。当前实现见 [本源动态记录](Art/Characters/yuanshi_tianzun/character_select_background/drafts/2026-10-08/ascension/CHARACTER_SELECT_ASCENSION.md)。
- 专属选择头像已定稿并接入，母图1032×1523、游戏头像132×195；“角色卡”初始遗物使用玄黑月印定稿，图标/轮廓85×85、大图256×256。
- 夜游神卡池共用墨蓝孔雀青卡身、古金细边和低对比三辰底纹。罕见/稀有整圈插图框、标题与类型牌使用原版青/金材质，标题和类型字沿用原版样式；费用数字使用独立字体样式。卡面外观已完成用户验收。
- 已接入嗜血之刃、猫王音箱、沉稳者宝珠、天蟾香炉、永不熄灭的蜡烛、红舞鞋及追杀、穿戴、共舞专属插图。能量图标为74×74和24×24。各资产定稿与专项检查范围见 [美术资产索引](Art/README.md)，绘图规则见 [ART_GUIDELINES.md](Art/ART_GUIDELINES.md)。
- 尚未制作的卡图使用占位资源；战斗、商店、篝火人物视觉仍复用铁甲战士，攻击特效使用游戏通用效果。

早期轻微动态与静态背景接入过程只保存在DEVLOG和资产记录中，不是并行生效的背景版本。重新启动游戏后加载当前部署资源。

## 当前玩法

| 项目 | 内容 |
|---|---|
| 初始属性 | 75生命、99金币 |
| 初始牌组 | 3体术、1射击、4格挡、1夜游、1噬灵 |
| 初始遗物 | 角色卡：姓名、职业、等级、经验与技能；另附太阴之灵说明 |
| 成长 | 普通战胜利30经验、精英50；累计300封顶，按100/200经验升级 |
| 太阴之灵 | 战斗开始恢复等级＋2生命，即3/4/5生命 |
| 第一幕试炼 | 不足3级时强化主敌人，获胜补足至3级 |
| 道具奖励池 | 嗜血之刃、沉稳者宝珠、天蟾香炉、永不熄灭的蜡烛、红舞鞋、伏魔杵、灵体结晶、大罗星盘、猫王音箱 |
| 本地化 | 简体中文及英文回退；中文描述数字与正文连续，不额外加空格 |

9张道具牌已完成用户游戏测试，当前作为机制稳定版本保存；这不代表所有存档与联机路径都已专项验证。成长边界和本地化有自动检查，游戏内验收范围及剩余限制以DEVLOG和专项记录为准。

## 项目结构

```text
SpiritualRealmWalker/
├─ Art/                     按资产归档的母图、提示词和试稿，不导出
│  ├─ Cards/
│  ├─ Relics/
│  ├─ Characters/
│  └─ UI/
├─ Cards/                   卡牌机制
├─ Powers/                  状态与持续效果
├─ Characters/              人物模型、内容池与卡面材质绑定
├─ Relics/                  遗物机制
├─ Progression/             成长和试炼规则
├─ Patches/                 专属卡面、费用和选择界面补丁
├─ Tools/
│  ├─ Art/                  图像导出、动态生成、预览及历史实验
│  ├─ Inspect/              原版资源与布局检查
│  ├─ Common/               路径与参数解析
│  ├─ Invoke-Tool.ps1       统一工具入口
│  └─ Extract-NovelItems.ps1 小说道具资料提取
├─ Tests/
│  ├─ Art/                  资源、部署包、布局和GPU验证
│  └─ Verify-Progression.ps1 成长与双语文本检查
├─ SpiritualRealmWalker/
│  ├─ images/               正式卡图、遗物、头像和动态辅助纹理
│  ├─ scenes/               选人背景场景、布局脚本及动态shader
│  ├─ materials/            卡面材质
│  ├─ shaders/              卡身、边框与标题绘制
│  └─ localization/         中英文本
├─ project.godot            Godot项目入口
├─ export_presets.cfg       导出配置，排除Art、Tools和Tests
├─ SpiritualRealmWalker.csproj C#引用、编译与部署配置
├─ SpiritualRealmWalker.json Mod清单
├─ DESIGN.md                当前玩法方案
├─ DEVLOG.md                历史过程及验证证据
└─ README.md                当前状态与使用入口
```

`.godot/`只保存Godot缓存、编译产物、工具输出和日志，不保存需要版本管理的手写工具源码。`灵境行者.txt`是被Git忽略的小说原文，按当前问题分段检索。资产内的`drafts/YYYY-MM-DD/`表示未定稿试稿批次。

## 开发环境与工具

当前兼容环境为Godot4.5.1 Mono、项目目标框架net9.0、RitsuLib0.6.2；此前核对的游戏版本为v0.111.0 public-beta。游戏、Godot或依赖升级后应重新核对兼容性。

制作及检查工具通过 `Tools/Invoke-Tool.ps1`运行。本机安装路径保存在忽略的 `tool-settings.local.json`，换电脑从 [配置示例](Tools/tool-settings.example.json)创建本机配置；也可用命令行或环境变量覆盖。输入图片从项目内读取，不依赖Codex会话文件。配置优先级、工具分类、从空缓存重新生成动态素材的步骤见 [工具说明](Tools/README.md)。

```powershell
pwsh -NoProfile -File Tools/Invoke-Tool.ps1 -Script Tests/Art/verify_character_select_background_layout.gd
pwsh -NoProfile -File Tools/Invoke-Tool.ps1 -Script Tests/Art/verify_ascension_deployed.gd -Gpu
```

提取小说道具资料：

```powershell
pwsh -NoProfile -File Tools/Extract-NovelItems.ps1
```

脚本读取项目根目录的`灵境行者.txt`并覆盖`ITEMS.md`，逐条保留原文出现顺序，不按同名去重。

## 编译与部署

在项目根目录运行，显式指定本机游戏目录：

```powershell
# 只编译，不部署
dotnet build SpiritualRealmWalker.csproj -c Release -p:GameDir="游戏安装目录"

# 编译并部署；GodotExe指向Mono版本的控制台程序
dotnet build SpiritualRealmWalker.csproj -c Release -p:DeployMod=true -p:GameDir="游戏安装目录" -p:GodotExe="Godot控制台程序路径"
```

项目配置中的路径属性可由`-p:GameDir`和`-p:GodotExe`覆盖；工具入口的本机JSON配置不自动传入`dotnet build`。当前MSBuild部署仍依次复制DLL、清单并导出PCK，完整暂存和失败回退流程尚未实现。

游戏加载`mods/SpiritualRealmWalker/`中的DLL、JSON清单和PCK。部署前应关闭游戏，避免DLL被锁；本项目没有独立主场景，不能用Godot运行按钮代替游戏验收。功能与运行时资源修改按项目约定编译或导出部署；纯文档、开发工具整理不更新游戏文件。

## 验证与维护

```powershell
pwsh -NoProfile -File Tests/Verify-Progression.ps1
```

游戏日志位于`%APPDATA%/SlayTheSpire2/logs/godot.log`。检查Mod初始化、RitsuLib注册、本地化合并、选择角色及正确初始牌组；新机制、存档和联机按对应专项记录测试。既有存档不会自动替换初始牌组，初始内容变化需新开局验证。

- README维护当前生效状态、结构、运行方式和剩余限制。
- DESIGN维护当前机制与数值，DEVLOG按时间保留实施过程和验证证据。
- 美术定稿按资产归档并清理该资产旧稿；绘图直接执行，实际提示词和检查结果随资产记录。
- 工具源码放在Tools/Tests并由Git管理；输出与日志放缓存，开发工具不进入游戏PCK。
- 文件删除遵循AGENTS.md：核对明确路径与范围；批量清理需用户明确授权，不扩大到无关文件。

当前下一步是验收本源动态背景的游戏内效果和性能，再决定是否定稿。
