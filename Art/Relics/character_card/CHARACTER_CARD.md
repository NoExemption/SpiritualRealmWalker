# 角色卡遗物绘图记录

## 状态与输出

2026-10-07用户确认玄黑月印修订版定稿。使用内置imagegen生成/编辑透明母图，Godot完成缩放及保留原像素的局部合成；主体美术由imagegen生成。以下早期首稿与试用内容保留为过程记录，其中旧名称已按文末定稿清理清单处理。

当前有效定稿：`character-card.png`（1254×1254母图）、`character-card-big.png`（256×256大图）、`character-card-icon.png`（85×85小图）。正式资源路径继续使用 `SpiritualRealmWalker/images/relics/character_card.png`、`character_card_big.png`及`character_card_outline.png`。

- `character-card-source.png`：1254×1254，保留生成母图；SHA256：407EDFBF90B1D6CB4E2670A62B3748F674079FC69DF306AB03E8AA4255EA626F。
- `character-card-big.png`：256×256，RGBA透明大图。
- `character-card-icon.png`：85×85，RGBA透明小图，由同一母图缩放。
- 内置生成原文件：`C:\Users\dasseinzumtode\.codex\generated_images\01a0e593-02fa-7321-9c90-7e4f1d81e979\exec-de7f4be7-83c3-42e4-830c-1406fce47f80.png`，保留原文件。

## 原版尺寸依据

直接挂载本机原版 `D:\SteamLibrary\steamapps\common\Slay the Spire 2\SlayTheSpire2.pck`，读取Texture2D实际尺寸。抽查akabeko、alchemical_coffer、amethyst_aubergine、amphorae：

| 资源 | 完整逻辑画布尺寸 |
| --- | --- |
| `res://images/relics/<name>.png` | 256×256 |
| `res://images/atlases/relic_atlas.sprites/<name>.tres` | 85×85 |
| `res://images/atlases/relic_outline_atlas.sprites/<name>.tres` | 85×85 |

图集region为裁切区域，必须加margin才是完整画布。例如akabeko普通图region81×69加margin4×16得到85×85，不能据裁切尺寸制作图标。遗物轮廓图的85×85规格已查明，本轮先交付彩色大/小图，轮廓辅助资源在确认接入时制作。

公开[添加新遗物教程](https://tutorials.sts2modding.com/docs/04-ritsulib/04-03-add-relic/)也注明小图及轮廓85×85、大图256×256；该教程为社区资料，尺寸结论以本机原版实际测量为依据。未把网页教程称为官方发布的美术规范。

只读检查脚本：`.godot/inspect_relic_sizes.gd`；日志：`.godot/relic-size-probe.log`。输出脚本：`.godot/export_character_card_relic.gd`；日志：`.godot/character-card-export.log`。工具退出码均0；既有根证书读取提示不影响本地纹理检查。

## 原文与美术补充

[灵境行者.txt](../../../灵境行者.txt)第128—129行：身份证大小的黑色卡片；材质似乎是金属，触手温润；边缘浅浅银色云纹；中央黑色圆月及清晰不规则斑块。保持满月，不替换为普通夜游神的月牙。没有在实体卡上绘制角色姓名、技能或属性面板。

轻微透视、圆角、冷银侧光与蓝灰边缘是美术补充；不是小说明确结构。透明背景为游戏资源需求。成稿银云纹比原文的“浅浅”更突出，便于小尺寸阅读；中心月面有体积明暗感，属于艺术表现，不声称原文描述了凸起月球。

## 完整实际提示词

```text
Use case: stylized-concept
Asset type: Slay the Spire 2 starter relic inventory icon, source illustration for exact 256x256 large PNG and 85x85 small PNG.
Primary request: Draw the physical character card from the Chinese novel 灵境行者: one exquisite black card the size and proportions of a real identity card, seemingly metal but warm and smooth to the touch, shallow silver cloud patterns around its edges, a black full moon printed at its center with clearly visible irregular lunar surface patches.
Scene/backdrop: Truly transparent alpha background, a single isolated object, no ground, no environment, no background color, no cast shadow outside the object.
Subject: A thin horizontal rectangular black metal identity card with gently rounded corners, width-to-height proportion approximately 1.58:1. A refined, restrained shallow engraved silver Chinese auspicious cloud border. The center has a complete dark full-moon disc with a few large irregular charcoal-grey lunar patches; the moon must read as BLACK, never white, never a crescent. The black moon is distinguished from the near-black metal card through subtle differences in value and surface finish. Preserve flat card geometry: it is a card, not a box, book, shield, playing card suit, pendant or tablet.
Style/medium: Polished hand-painted fantasy roguelike relic icon, confident readable contour, broad painted value planes, modest visible brushwork, stylized materials, sophisticated ominous noble feeling. No photorealism, no 3D render. Design for clear recognition at only 85 pixels: strong simple card silhouette, full moon and cloud border remain visible, do not rely on microscopic engraving.
Composition/framing: Square canvas. Entire card centered, nearly front-facing, mild shallow perspective that reveals just a thin edge. The long axis stays almost horizontal, about 8 degrees of tilt only. Card occupies about 88 percent of canvas width and 64 percent of height, fully within canvas with transparent padding. Full moon remains a recognizable circular emblem, no severe foreshortening. No cropping.
Lighting/mood: Restrained cold silver edge illumination, silver clouds softly highlighted, center remains dark, mysterious and precious. A barely perceptible cool blue undertone along the metal edge is acceptable, no luminous halo or magical particle shower.
Color palette: Obsidian black, charcoal grey, subdued cool silver, tiny muted blue-grey edge accents. No gold, no bright blue, no purple, no saturated accents.
Text: None.
Constraints: One physical card only; no text, no name, no numbers, no portrait, no face, no hands, no human, no sun, no stars, no additional symbols, no gems, no skulls, no runes, no watermark. Cloud engraving is shallow and elegant, not a thick filigree frame. Actual transparent background.
```

工具参数：`transparent_background=true`，新图无参考图路径。生成不支持在此接口指定85×85或256×256精确尺寸，因此保留母图，以Lanczos缩放导出原版尺寸，未裁剪或重排构图。

## 检查结果

实际查看256×256及85×85输出：卡片完整，黑色满月与银色云纹可辨，无文字、水印、人物或额外日星符号。两张均通过PNG重新加载尺寸与alpha验证。小图月面细碎纹理随缩小减少，卡身及中心满月保持可读。材质纹理偏精细，最终画风与游戏背景对比仍需用户评价，不能以本地图片预览代替游戏内验收。

本轮没有修改遗物类、玩法、正式资源、卡牌图、已有样稿，没有删除文件、编译部署或提交Git。

## 游戏试用接入

用户要求“先接入游戏看看效果”，因此仅接入当前样稿，不作美术定稿或清理旧稿。

- `Relics/CharacterCard.cs`的`AssetProfile`绑定三张资源：`SpiritualRealmWalker/images/relics/character_card.png`（85×85）、`character_card_big.png`（256×256）、`character_card_outline.png`（85×85）。大小图为上述概念PNG的原样副本，未重新绘制。遗物说明、附加说明框、等级计数及治疗/经验机制不变。
- 按原版轮廓纹理检查结果制作白色透明轮廓：从85×85小图alpha派生，向外扩展约2像素，舍弃alpha≤0.1的透明噪点；它是渲染辅助遮罩，不改变彩色图案。
- Godot导入三张正式图及三张概念图，新增对应`.png.import`。概念图仍由`Art/*`导出排除规则排除。保留所有母图、样稿与绘图记录。
- Release编译、PCK导出部署完成，0警告、0错误；DLL和清单的部署哈希与构建/源文件一致。沙箱首次编译无法读取NuGet配置，提权重试成功。部署时没有游戏进程，未关闭或启动游戏。
- 独立挂载部署PCK后，三张纹理尺寸及alpha正确，像素与执行相同`fix_alpha_edges`默认导入处理后的源PNG完全一致。默认`process/fix_alpha_border=true`会修复透明边缘RGB，直接拿未处理PNG逐像素比较会有差异，因此检查采用相同导入处理，不把原PNG与部署纹理误称字节/原像素完全相同。
- 忽略的辅助脚本为`.godot/inspect_relic_outline.gd`、`prepare_character_card_relic.gd`、`verify_character_card_relic.gd`，相应日志保存在`.godot/`。既有根证书、旧布局引用及编辑器设置保存权限提示未影响资源导入和部署核对。

选人界面、遗物栏与悬停/图鉴的实际显示待用户查看；本轮没有提交Git。

## 玄黑月印局部修订

用户确认首稿整体无大问题，要求只修改圆月内部：整体呈黑色，保留黑色之间的变化，削弱灰色真实月球感，突出神秘尊贵。按已经讨论的方案直接以内置imagegen编辑，未再要求提示词确认。

### 输出与来源

- 输入：`character-card-source.png`，已先查看原图。
- 内置编辑输出：`C:\Users\dasseinzumtode\.codex\generated_images\01a0e593-02fa-7321-9c90-7e4f1d81e979\exec-f9e779b5-8e9b-419e-857b-582e62012be1.png`，1254×1254；项目保留副本`character-card-black-moon-generated.png`。
- 局部保留后的母图：`character-card-black-moon-source.png`，1254×1254，SHA256：98D2FAA129FCCC43E047646664C7946F09CE85D03D21D590A47EA70144522BCD。
- 导出：`character-card-black-moon-big.png`（256×256）、`character-card-black-moon-icon.png`（85×85），同一修订母图Lanczos缩放，实际重新加载确认准确尺寸和透明alpha。

### 完整实际编辑提示词

```text
Use case: precise-object-edit.
Input image 1 is the exact edit target: the already accepted black metal character-card relic with silver cloud engraving, on a transparent square canvas.
Primary request: Change ONLY the interior surface of the central full-moon emblem into a mysterious, noble, layered BLACK moon seal. Everything outside the moon interior must stay unchanged.
Local change: The entire moon should read immediately as near-black rather than a realistic grey lunar globe. Use an obsidian base approximately #050608, irregular ink-black patches approximately #0B0D12, and very restrained deepest cool-black variation approximately #14171D. Keep a few irregular broad patches in approximately the same overall distribution as the current moon, but integrate their edges softly into the surrounding black. Preserve perceptible variation at close view; do not make a uniform flat black circle. Reduce the brightest moon-interior areas drastically. The brightest interior marks must still read as BLACK, not grey. Convey quiet depth through subtle matte versus warm satin surface finish, not through bright reflections.
Remove within the moon only: photorealistic grey lunar soil, tiny crater texture, granular grey details, hemispherical illumination, bright rim lighting on the moon's surface, raised spherical appearance. The result is a flat printed or inlaid dark full-moon seal on the card, with velvety irregular near-black tonal markings. Dark, enigmatic, understated, precious, no glow.
Strict invariants: Keep the full moon's exact size, position, circular boundary, and the thin surrounding silver circle UNCHANGED. Preserve the entire black card body, every silver cloud ornament, the silver outer card rim, body grain, their colors, reflections, geometry, thinness, rounded corners, perspective, orientation, framing, transparent alpha background and original canvas composition. Do not redraw, restyle, shift or recolor any of these. No new symbols, no star dots, no sun, no crescent, no lettering, no magical particles, no watermark. Preserve actual transparency. Deliver only the complete edited card with the same framing, not a close-up or a comparison sheet.
```

工具参数：`referenced_image_paths`为上述原母图绝对路径，`transparent_background=true`。

### 保持局部修改与检查

内置编辑在月面以外也有细微纹理重绘，因此交付图以原母图为底，仅合入生成的月面内部。Godot辅助脚本按原银圈的径向亮度定位边界，退让6像素保留银圈及周边，再于内部3像素过渡；主体美术由imagegen生成，辅助脚本只完成局部合成、原像素保留与尺寸导出。

忽略的`.godot/export_character_card_black_moon.gd`和导出日志确认：月面内部181124像素变化，限定区域外变化像素为0；卡身、银云纹、外框、透明轮廓及构图保持原母图像素。圆月中央半径210像素区域的平均RGB由28.7707/255降至14.6639/255，数值只说明明显压暗，不代替美术评价或声称所有像素严格等于提示词色值。

实际查看256×256及85×85：黑月保留暗色不规则斑块，灰色月壤感及亮面显著减弱，银圈与云纹完整。小图变化更含蓄，保留黑月识别；是否达到用户期望的神秘尊贵感仍待评价。

原版与修订版均保留。此轮只生成局部修订样稿及记录，没有替换已经部署的首稿，没有修改代码、重新编译部署或提交Git。用户确认定稿后再按项目流程接入。

### 修订稿游戏试用部署

用户随后明确要求“将其接入游戏看看效果”。原样复制 `character-card-black-moon-icon.png` 与 `character-card-black-moon-big.png` 覆盖正式 `character_card.png` 和 `character_card_big.png`，沿用已有AssetProfile绑定及轮廓图。卡片外形不变，轮廓不需重新绘制；遗物机制、本地化及界面布局不变，未将试用请求视为美术定稿或清理授权。

- Godot重新导入2张正式PNG，并为4张修订概念图新增导入配置。原版母图、首稿及修订稿都保留，`Art/*`继续排除出游戏导出包。
- 核对正在运行的游戏PID4596及可执行路径后，按既有授权关闭游戏。Release编译、PCK导出部署成功，0警告、0错误；部署DLL和清单哈希匹配。未重新启动游戏。
- 独立挂载部署PCK，三张纹理尺寸及alpha正确；大小图正式PNG与指定玄黑月印稿像素一致，三张部署纹理与执行相同默认透明边缘修复后的源PNG像素一致。检查脚本沿用`.godot/verify_character_card_relic.gd`，日志`.godot/character-card-black-moon-deployment-check.log`，退出码0。
- 既有根证书、编辑器旧布局及设置保存提示未影响导入和部署。实际游戏表现待用户查看，没有提交Git。

## 玄黑月印版确认定稿

2026-10-07用户确认定稿。按照项目既有定稿流程，仅整理角色卡自身的图片与失效导入配置，逐个核对明确绝对路径并逐个删除文件，保留本绘图记录、DEVLOG历史及Codex生成原输出，不清理其他道具或目录。

### 最终文件与像素

| 当前概念定稿 | 原修订稿名 | 尺寸 | SHA256 |
| --- | --- | --- | --- |
| `character-card.png` | `character-card-black-moon-source.png` | 1254×1254 | 98D2FAA129FCCC43E047646664C7946F09CE85D03D21D590A47EA70144522BCD |
| `character-card-big.png` | `character-card-black-moon-big.png` | 256×256 | C6B04B87DF4D218A73AC1452F670CEA1F58FDE158C9ED152D312FE100B7C1FAB |
| `character-card-icon.png` | `character-card-black-moon-icon.png` | 85×85 | AC2158392315735CB5CE75BF8F40BAA20AF15A27C8BFF37B719E59C525F0258C |

三张只规范命名，没有重绘、重新缩放或改像素；重新计算哈希均保持不变。Godot为规范文件名生成3份有效导入配置。正式大小图仍使用此前已部署的相同像素，沿用轮廓和AssetProfile绑定。

### 逐项清理名单

以下均位于 `D:\Code\SpiritualRealmWalker\Art\Concepts\2026-10-07\`，共11个明确文件，未删除目录：

- 首稿图片：`character-card-source.png`、旧 `character-card-big.png`、旧 `character-card-icon.png`。
- 未局部保留的中间输出副本：`character-card-black-moon-generated.png`。
- 对应首稿/中间稿导入配置：`character-card-source.png.import`、旧 `character-card-big.png.import`、旧 `character-card-icon.png.import`、`character-card-black-moon-generated.png.import`。
- 规范命名前失效配置：`character-card-black-moon-source.png.import`、`character-card-black-moon-big.png.import`、`character-card-black-moon-icon.png.import`。

上文同名首稿历史已清理，当前 `character-card-big.png` 和 `character-card-icon.png` 是玄黑月印定稿，不能再把历史首稿哈希用于当前文件。Codex原始生成图仍保留于前述生成目录，可回溯绘制过程。

### 最终部署与核对

- 更新README定稿状态，重新导入、Release编译、PCK导出部署成功，0警告、0错误。部署时没有游戏进程，未关闭或启动游戏，没有提交Git。
- DLL与清单源/部署哈希匹配。独立加载部署PCK确认85×85小图、85×85轮廓和256×256大图透明通道正确，像素与默认透明边缘修复后的源文件一致；大小图正式PNG与规范命名定稿一致。
- 验证脚本 `.godot/verify_character_card_relic.gd` 已更新为规范概念文件名，日志 `.godot/character-card-final-deployment-check.log`，退出码0；构建日志 `.godot/character-card-final-build.log`。既有根证书、旧布局和编辑器设置权限提示未影响导入验证。

用户已确认玄黑月印版美术定稿；本次整理和部署没有改变已确认画面。
