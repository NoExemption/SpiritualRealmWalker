# 灵境行者 Mod（SpiritualRealmWalker）

以小说《灵境行者》为主题制作的《杀戮尖塔 2》角色 Mod。首名角色为“元始天尊”，职业固定为“夜游神”。

当前项目已编写并部署第一版夜游神机制，通过 Release 编译与成长规则检查，待游戏内验收。当前有效的机制与卡牌方案见 [DESIGN.md](DESIGN.md)，逐次开发过程、文件变动和验证证据记录在 [DEVLOG.md](DEVLOG.md)。

## 当前功能

卡牌插图的原文核对、构图、手绘与配色要求见 [绘图规范](Art/ART_GUIDELINES.md)。

三辰卡面已统一部署到夜游神整个卡池：墨蓝孔雀青卡身、古金细边和低对比日月星底纹。覆盖19类自定义牌及升级版本（初始、奖励、选择衍生牌和共舞），后续同池新牌自动沿用；罕见与稀有的整圈插图框、类型牌和完整顶部标题纹饰直接使用原版青色、金色材质，保留折面、高光和阴影，普通牌保留深色古金框及标题带。标题与类型字恢复原版字体、稀有度描边和字色；普通类型牌签恢复灰色，所有类型字采用统一深色。费用图标、独立插图、正文和标题升级绿色继续使用现有逻辑。配色、文件用途和验收范围见 [卡身与边框说明](Art/CARD_STYLE.md)。已通过部署资源渲染和此前游戏初始化检查；2026-10-05用户确认本次卡面游戏内验收完成。

三辰能量图标已确认定稿并编译部署，费用图标74×74、文本小图标24×24，后者由前者直接缩小。卡牌、遗物和药水池共用 `SpiritualRealmWalker/images/ui/energy_big.png` 与 `energy_text.png`，代表太阴、星辰与太阳共用的能量；已验证部署PCK能加载两张纹理，游戏内显示待验收。资源及配色依据见 [图标说明](Art/Icons/2026-10-04/ENERGY_ICONS.md)。

猫王音箱已接入带灰银色猫图案的手绘卡图：`SpiritualRealmWalker/images/cards/cat_king_speaker.png`，普通与升级版共用；游戏内显示待验收。

沉稳者宝珠和天蟾香炉已确认美术定稿并绑定 `steadfast_orb.png`、`heavenly_toad_incense_burner.png`，普通与升级版共用；部署后的卡框显示待验收。

嗜血之刃已绑定手绘挥砍卡图，资源位于 `SpiritualRealmWalker/images/cards/bloodthirsty_blade.png`，普通版与升级版共用。概念图为 `Art/Concepts/2026-09-30/bloodthirsty-blade.png`，已部署，游戏内显示待验收，其他卡图仍为占位图。`Art/` 不进入游戏PCK。

第三批新增灵体结晶、大罗星盘、猫王音箱，奖励池共9张；用户已完成游戏内测试，未报告问题，当前作为9张道具牌的稳定版本保存。

灵体结晶的回能描述采用原版能量图标格式，显示两枚共用图标，普通与升级版保持获得2点能量；此次描述修改后的游戏内显示待验收。

费用数字使用本 Mod 专属样式：在三辰费用图标上向上移动4个显示像素，字号上限由原版32调整为26；普通费用为暖象牙白（`#f1deb7`），搭配3像素棕黑描边（`#1b1711`）与右下方短阴影（`#100e0bdd`，偏移1/2像素）。保留原版减费绿色、增费红色及禁用灰色；只影响夜游神卡池，其他卡池恢复原布局。修改后的游戏内显示待验收。

费用字体采用独立FontVariation，`VariationEmbolden`增加0.65；先完成原版本地化字体刷新，再应用加粗变体，防止字重被覆盖，不修改游戏共享字体。

费用字体及其回退字体的独立副本使用普通光栅化，关闭MSDF，规避人工加粗轮廓相交造成的黑色针孔；原版共享字体仍保持MSDF，黑点修正后的游戏内显示待验收。

- 可选角色：元始天尊／夜游神。
- 初始属性：75 点生命、99 金币。
- 独立内容池：夜游神卡牌池、遗物池、药水池。
- 初始牌组：3张“体术”、1张“射击”、4张“格挡”、1张“夜游”和1张“噬灵”。
- 初始遗物：“角色卡”，显示等级、经验、自愈量及试炼档位。
- 成长：普通胜利30经验、精英50经验，累计300封顶；战前恢复等级＋2生命。
- 第一幕试炼：不足3级时强化主敌人生命与力量，胜利补足至3级。
- 道具奖励池：嗜血之刃、沉稳者宝珠、天蟾香炉、永不熄灭的蜡烛、红舞鞋、伏魔杵、灵体结晶、大罗星盘、猫王音箱，共9张，包含普通、罕见和稀有牌。
- 道具资料：悬停9张道具牌时显示原文类型、功能、介绍和备注。
- 本地化：简体中文及英文回退文本。
- 占位资源：角色视觉暂时复用铁甲战士，攻击特效暂用游戏通用斩击，卡牌与遗物尚无正式图片。

骨架版本的导出、注册、本地化和实际开局已经验证。新机制编译为0警告、0错误，32项成长规则检查及本地化检查通过；现已导出 PCK 并部署，DLL与清单的 SHA256 和源产物一致。新机制的游戏行为、读档和联机尚待实测。

## 开发环境

| 项目 | 路径或版本 |
|---|---|
| 源码目录 | `D:\Code\SpiritualRealmWalker` |
| 游戏目录 | `D:\SteamLibrary\steamapps\common\Slay the Spire 2` |
| 游戏版本 | `v0.111.0` public-beta |
| Mod 部署目录 | `D:\SteamLibrary\steamapps\common\Slay the Spire 2\mods\SpiritualRealmWalker` |
| Godot | `D:\Godot_v4.5.1-stable_mono_win64`，4.5.1 Mono |
| .NET SDK | 10.0.401；项目目标框架为 `net9.0` |
| RitsuLib | 0.6.2，运行时位于游戏目录的 `mods\STS2-RitsuLib` |

这些信息是当前本机环境快照。升级游戏、Godot 或 RitsuLib 后需要重新验证兼容性。

## 项目结构

```text
SpiritualRealmWalker/
├─ Cards/                         卡牌代码
│  ├─ SpiritCrystal.cs            灵体结晶：回能，升级保留
│  ├─ GreatLuoAstrolabe.cs         大罗星盘：持续观星与定向过牌
│  ├─ CatKingSpeaker.cs           猫王音箱：选择音频并消耗
│  ├─ CatKingSpeakerDrum.cs       鼓声选择牌
│  ├─ CatKingSpeakerSuona.cs      唢呐选择牌
│  ├─ BodyTechnique.cs            基础攻击牌“体术”
│  ├─ Shooting.cs                 基础攻击牌“射击”
│  ├─ Block.cs                    基础技能牌“格挡”
│  ├─ NightTravel.cs              夜游：无实体、保留、消耗
│  ├─ SpiritDevour.cs             噬灵：击杀治疗、回能与晕眩，否则虚弱
│  ├─ BloodthirstyBlade.cs        嗜血之刃：不可格挡伤害、中毒与击杀治疗
│  ├─ SteadfastOrb.cs             沉稳者宝珠：高额格挡并生成碎屑
│  ├─ HeavenlyToadIncenseBurner.cs 天蟾香炉：使所有敌人和自身中毒
│  ├─ EverBurningCandle.cs          永不熄灭的蜡烛：净化并获得易伤
│  ├─ RedDanceShoes.cs              红舞鞋：在追杀与穿戴间选择
│  ├─ RedDanceShoesPursuit.cs       红舞鞋的追杀形态选择牌
│  ├─ RedDanceShoesWear.cs          红舞鞋的穿戴形态选择牌
│  ├─ DanceTogether.cs              红舞鞋生成的状态牌“共舞”
│  └─ DemonSubduingPestle.cs        伏魔杵：献祭生命、攻击并净化
├─ Powers/
│  ├─ GreatLuoAstrolabePower.cs   正常抽牌前查看顶部牌并选择
│  ├─ CatKingSpeakerSuonaPower.cs 唢呐独立计时与生命代价
│  ├─ RedDanceShoesPursuitPower.cs  追杀的回合伤害与共舞计时
│  └─ RedDanceShoesWearPower.cs     穿戴的格挡、共舞与敏捷期限
├─ Characters/                    角色与职业内容池
│  ├─ YuanshiTianzunCharacter.cs  “元始天尊”角色模型
│  ├─ NightWandererCardPool.cs     夜游神卡牌池
│  ├─ NightWandererRelicPool.cs    夜游神遗物池
│  ├─ NightWandererPotionPool.cs   夜游神药水池
│  ├─ ThreeLuminariesEnergyIcons.cs 三辰共用费用及文本图标路径
│  └─ ThreeLuminariesCardStyle.cs   三辰共用卡身与边框材质加载
├─ Relics/
│  └─ CharacterCard.cs            角色卡、存档、战前恢复及试炼钩子
├─ Progression/NightWandererProgression.cs  等级、经验封顶和试炼分档
├─ Patches/EnergyCostLabelAlignmentPatch.cs  三辰费用数字的位置、大小与普通费用配色
├─ Patches/CardPortraitBorderStylePatch.cs  专属插图边框材质及节点复用恢复
├─ Tests/Verify-Progression.ps1    成长边界与双语文本检查
├─ Tools/Extract-NovelItems.ps1    从小说原文提取并逐次编号道具信息
├─ ITEMS.md                        从小说原文提取的编号道具资料
├─ SpiritualRealmWalker/
│  ├─ images/ui/                   正式能量图标（74×74与24×24）
│  ├─ materials/                   三辰卡身、普通插图框和标题带材质
│  ├─ shaders/                     墨蓝孔雀青、古金细线与三辰圆印绘制
│  └─ localization/
│     ├─ zhs/                      简体中文文本
│     └─ eng/                      英文回退文本
├─ ModEntry.cs                     Mod 初始化入口与 RitsuLib 程序集注册
├─ SpiritualRealmWalker.json       Mod 清单及运行时依赖
├─ SpiritualRealmWalker.csproj     C# 引用、编译和部署配置
├─ SpiritualRealmWalker.sln        Godot Mono 所需解决方案
├─ project.godot                   Godot 项目入口
├─ export_presets.cfg              PCK 导出配置
├─ README.md                       项目入口与使用说明
├─ DESIGN.md                       当前有效的机制、数值与卡牌设计
└─ DEVLOG.md                       开发日志与逐次文件变动
```

`.godot/` 是 Godot 和编译工具生成的缓存及中间产物，由 `.gitignore` 排除，不应手动维护。`灵境行者.txt` 是原作资料，只按当前设计问题分段检索，不整本读取，也不作为程序资源处理。

提取小说中采用固定属性格式的道具信息：

```powershell
pwsh -NoProfile -File .\Tools\Extract-NovelItems.ps1
```

脚本默认读取项目根目录中被 Git 忽略的 `灵境行者.txt`，将结果写入 `ITEMS.md`。每次以“【名称：”开头的属性展示都使用独立三位序号，并严格按原文顺序保留；同名或同内容条目出现多次时也不会去重。执行脚本会覆盖现有的 `ITEMS.md`。

## 构建

只验证 C# 编译：

```powershell
Set-Location 'D:\Code\SpiritualRealmWalker'
dotnet build .\SpiritualRealmWalker.csproj -c Release
```

编译并将 DLL、清单和 PCK 部署至游戏目录：

```powershell
Set-Location 'D:\Code\SpiritualRealmWalker'
dotnet build .\SpiritualRealmWalker.csproj -c Release -p:DeployMod=true
```

若游戏安装位置改变，可以临时覆盖路径：

```powershell
dotnet build .\SpiritualRealmWalker.csproj -c Release -p:GameDir="新的游戏目录"
```

部署前应关闭游戏，避免正在加载的 DLL 阻止覆盖。Godot 中可通过项目管理器导入 `project.godot`；该项目是由游戏加载的 Mod，没有独立主场景，不使用 Godot 的运行按钮验证。

项目约定：完成功能代码、配置或本地化修改后，默认执行 Release 编译、必要检查和部署。部署前检查游戏是否运行；用户已授权检测到游戏运行时直接关闭游戏，再完成部署，无需等待手动关闭。仅修改开发文档时不重复部署。

## 加载与验证

游戏加载的三个文件位于 `mods\SpiritualRealmWalker`：

- `SpiritualRealmWalker.dll`：C# 逻辑。
- `SpiritualRealmWalker.json`：Mod 清单。
- `SpiritualRealmWalker.pck`：本地化及后续 Godot 资源。

运行日志位于：

```text
%APPDATA%\SlayTheSpire2\logs\godot.log
```

有效验证应同时包括：

1. 日志出现 `[SpiritualRealmWalker] Initialized v0.1.0`。
2. RitsuLib 报告 SpiritualRealmWalker 的自动注册全部成功。
3. 中英文 `cards.json`、`characters.json`、`relics.json` 完成合并。
4. 游戏中能选择元始天尊并以该角色开始一局。
5. 新局包含3体术、1射击、4格挡、1夜游、1噬灵和“角色卡”。

以上前四项在此前骨架版本已验证，新机制版本需要重新验收。缺少自定义卡图和遗物图标产生的占位资源警告是当前已知限制。

编译后执行自动检查：

```powershell
pwsh -NoProfile -File Tests/Verify-Progression.ps1
```

新机制实机检查：

- 普通战胜利获得30经验，精英获得50；跨100/200时升级，超过300封顶。
- 受伤后进入战斗，按等级恢复3/4/5生命；保存退出并继续后经验相同。
- 夜游抽到后保留，支付1费获得无实体并消耗；下一场仍在牌组中。
- 噬灵未击杀时施加虚弱；击杀时治疗3、回能1、生成晕眩。特别检查最后一个敌人的击杀治疗。
- 第一幕 Boss 战检查各档生命/力量增幅，3级无增幅，获胜时至少达到3级。
- 现有存档不会自动替换旧牌组；请新开局验证。新牌升级尚未设计，暂不能升级。
- 永不熄灭的蜡烛保留已有易伤、移除其他负面状态，再给予自身2层易伤；升级后为1层，并在使用后消耗。
- 红舞鞋确认两种形态选择、追杀指定并锁定目标、目标死亡后返回手牌、每3回合生成共舞、穿戴在玩家回合结束时给予格挡、穿戴结束后返回手牌，以及共舞留在手中时造成5点伤害。
- 伏魔杵先失去6点生命，再造成30点伤害并净化全部负面状态；升级后造成33点伤害。

## 文档维护规则

- `README.md` 只维护当前有效状态、项目结构、构建方式和验证方法。
- `DESIGN.md` 维护当前有效的机制、数值、卡牌和职业设计；方案改变时直接更新对应章节。
- `DEVLOG.md` 按时间追加每次任务的目的、文件变化、问题、解决方案和验证结果。
- 已验证、待验证和计划中的内容必须明确区分。
- 每次完成任务都向用户说明具体新增、修改、删除的文件；自动生成内容单独说明。
- 功能代码、配置或本地化修改完成后默认自动编译并部署；部署前检查游戏进程，运行中则直接关闭。纯文档修改不部署。
- 不执行批量文件删除；需要批量清理时由用户手动处理。

## 下一步

启动游戏，新开“元始天尊”对局，按上述清单验收第一版机制。
