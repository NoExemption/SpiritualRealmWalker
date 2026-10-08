# 共舞卡图绘制记录

## 1. 原文与机制

- 小说第1697—1733行：红舞鞋邀请张元清原地踏步，演示踢踏舞；张元清随后以较慢、蹩脚的动作模仿踢踏、旋身和小幅跳步，完成舞蹈后获得红舞鞋赏识。第1742行说明陪它跳完一支舞可终止追杀。
- 当前共舞为1费状态牌，消耗；回合结束仍留在手牌则受5点伤害。卡图表现履行共舞要求，不改费用、效果或本地化。
- 采用稍俯视脚部近景：普通鞋与两只空红舞鞋分组踏步，区别于穿戴的女性芭蕾袜站姿和追杀的胸口攻击。将原作先演示后模仿凝缩为同画面节拍呼应，是美术补充；普通鞋和深灰裤的具体外观也属补充。

## 2. 输入与实际提示词

- 内置imagegen生成新构图。输入 `Art/Cards/red_dance_shoes/red-dance-shoes.png` 仅用于鞋型、皮面、搭带扣件及手绘风格参考，不作为摆放模板。
- 仅生成样稿，待用户确认定稿后再规范命名、接入和部署；现有三张红舞鞋插图保持。

- 首次输出 `exec-7766bddb-4ab3-4b8e-828e-a404f339ae96.png`，画幅偏宽。图中为两条裤腿、两只普通鞋和两只空红鞋，鞋型未见明显直角弯折；步态更接近前掌落地、抬跟的节拍，未严格执行提示词中的一脚托跟抬前掌，不认定提示词全部实现。随后仅调整上下背景画幅至25:19，实际纠正提示词如下。

### 画幅纠正提示词

```text
Use case: precise-object-edit.
Edit ONLY the canvas/background framing of this illustration. The current image is too wide for the game card. Output a landscape image with EXACTLY 25:19 aspect ratio, like 1439x1093 or 1500x1140, NOT 3:2 or 16:10.
Keep all four shoes, both human lower legs, their shapes, paintwork, rhythm, spacing, relative scale and viewing angle unchanged. Two gray shoes are worn by two trousered human legs; two red shoes are empty and autonomous. Do not change any shoe anatomy, toe, heel, strap, buckle, opening, ankle or pose.
Fit the ENTIRE existing image into the new 25:19 canvas without cropping the left gray shoe or the right red shoe. Add unobtrusive matching dark blue-gray background space above and a small amount below to reach the required aspect ratio. Use only simple broad brushwork in the added areas; no new paving detail, objects, grass or architecture. Retain the existing contact shadows and floor marks. Do not zoom in, replace the scene or change the illustration's style. No text, frame, musical notes, symbols or watermark. Return only the adjusted 25:19 illustration.
```

### 初稿提示词

```text
Use case: illustration-story.
Asset type: hand-painted game card illustration for "Dance Together", landscape 25:19, around 1440x1094, readable at 250x190.
Input image 1: the finalized red dance shoes, used only as a reference for the SAME shoe construction, red leather, brass strap buckle, proportions and painterly style. Create a new composition, not a copy of its pose.

Scene: a tense, uncanny tap-dance imitation. A human follows the footsteps of a pair of autonomous EMPTY red shoes. Show only the human's two lower legs from below the knees, in dark gray everyday trousers and a pair of muted gray ordinary low shoes. The human is NOT wearing the red shoes. The two red shoes are a separate empty pair dancing beside the person, with both hollow shoe openings clearly visible and no feet or ghost legs inside.

Composition: a moderately elevated three-quarter close view looking down at four shoes in two separate groups. The human's muted shoes occupy the left half; the two empty red shoes occupy the right half and are the main focus. All four shoes share a clearly readable rhythm: a heel-supported forward foot with its forefoot raised slightly by rotating the WHOLE intact shoe, and a trailing foot with its toe lightly touching the ground and heel lifted. The human follows that rhythm, a little awkwardly; the autonomous shoes look nimble. Keep the two human legs attached naturally to their own gray shoes with clear ankle connections. Exactly two human legs, two gray worn shoes, and two empty red shoes; no additional limbs, feet, shoes, bodies or hands. Separate silhouettes and enough space between the two pairs. Use distinct planted-foot shadows and small lifted-foot gaps to show the step, not effects alone. Avoid overlapping/crossed limbs.

Maintain the reference shoe identity: slender rounded toe, natural short vamp, compact empty opening, a single red strap and small brass buckle, thin forefoot sole, gently curved arch and a moderate separate block heel. Shoes remain intact rigid objects, whole-object rotations only; no sharply bent toe, L-shaped sole, stretched opening, bloated heel cup, chunky toe or ballet pointe deformation.

Style: decisive hand-painted edges, broad shapes and two or three value planes, lively but restrained painted highlights. Deep indigo and blue-gray abstract brushwork, a simple low-detail floor patch and cool moonlight indication. Only a few small pale floor-tap accents at real contact points. No detailed stone pavement, grass, temple, theater scenery, spotlight beams, musical notes, symbols or magic circles. The uneasy forced-dance mood comes from the odd empty shoes and mirrored rhythm, not horror gore. No text, UI, border or watermark. Keep the red shoes' entire toes, heels and buckles within the central safe area, with margin at the top and bottom for the actual game card frame; do not clip key shoe parts.
```

## 3. 当前样稿与检查

- 原输出：`C:/Users/dasseinzumtode/.codex/generated_images/01a0e593-02fa-7321-9c90-7e4f1d81e979/exec-faf120dd-1de9-4952-8664-98187ecedca6.png`。
- 项目样稿：`Art/Concepts/2026-10-06/dance-together-draft.png`，1438×1093，接近25:19（约1.315645）；SHA256：`53637DCAFEC389D40AFFEE1FAD97D90260C41A6EB14CDCE047674B9D9055E41C`。由内置工具调整画幅后复制，没有手动裁剪、改像素或覆盖其他卡图。
- 图中两条裤腿各自连接一只灰鞋，两只红鞋为空鞋口，没有多出的手脚或穿红鞋的隐形腿；鞋头、方跟、搭带可辨，没有直接看出直角折起或鞋身断裂。前后脚以抬跟、前掌接地/近地的姿态呼应，动作略偏轻踏而非大幅舞步；背景及地面仍有较明显笔触纹理，不认定每项提示词逐项实现。
- Godot GPU组合预览 `.godot/dance_together_preview.png`（690×550），脚本 `.godot/preview_dance_together.gd`，日志 `.godot/dance-together-preview.log`，退出码0。实际查看250×190缩略图和组合图，四只鞋的关键鞋尖、鞋跟与红鞋扣件区域未被遮挡。
- 本机原版图集没有独立名为 `card_frame_status_s` 的纹理，预览采用现有技能框型作为余量参考，并将类型标成状态；它不是完整NCard或状态牌的实际游戏截图，不代替游戏内验收。检查脚本未导入新图或修改运行时绑定。
- 首次原版框型探查未指定项目日志路径，受沙箱用户日志写入限制崩溃；改用 `.godot/probe-status-frame.log` 后探查成功，预览也成功。既有根证书读取提示未影响本地渲染。
- 当前只保存样稿与绘制记录，等待用户评价及定稿；正式共舞仍保持占位图，没有删图、关闭游戏、编译、部署或提交Git。

## 4. 第一张宽幅图试部署

- 用户要求先部署第一张查看效果；此次属于试用，不视为美术定稿。选择初次输出 `exec-7766bddb-4ab3-4b8e-828e-a404f339ae96.png`，实际尺寸1573×1000；没有重新绘图、裁剪或补背景。
- 新增概念副本 `Art/Concepts/2026-10-06/dance-together-wide-draft.png` 和正式加载路径 `SpiritualRealmWalker/images/cards/dance_together.png`；原输出及两份副本SHA256均为 `8BD7DB49287041852CB2C590A75CA0C22EDE250F57BCCF2DEFE95AA4C90730A3`。保留25:19修改稿以便比较，没有清理旧图。
- `Cards/DanceTogether.cs` 新增独立 `CustomPortraitPath`，只绑定图像，1费、消耗、留手受5点伤害及不能升级的机制不变。README同步为共舞宽幅图试用状态。
- Godot导入新增宽幅概念图、已有25:19样稿及正式图的3份 `.png.import`；Release编译、PCK导出和部署成功，0警告、0错误。部署前没有检测到游戏进程，未关闭或重新启动游戏。
- 独立加载部署PCK，纹理1573×1000，全部RGBA8像素与宽幅概念副本一致；DLL及清单与源文件哈希一致。检查脚本 `.godot/verify_dance_together_wide.gd` 与导入/核对日志被Git忽略。已知根证书、编辑器设置权限及旧布局引用提示未影响导入和部署。
- 实际卡框如何显示宽幅图待用户在游戏内检查；本次未使用组合预览代替验收，也未提交Git。后续用户确认定稿后再清理共舞旧稿并更新正式命名。

## 5. 第二张定稿、清理与替换部署

- 2026-10-06用户选择保留第二张并确认定稿，即第3节25:19修改图。将 `dance-together-draft.png` 重命名为 `dance-together.png`，保留1438×1093原图；SHA256仍为 `53637DCAFEC389D40AFFEE1FAD97D90260C41A6EB14CDCE047674B9D9055E41C`。
- 按既有定稿清理授权核对绝对路径后逐一删除 `dance-together-wide-draft.png`、其 `.png.import` 及旧 `dance-together-draft.png.import`。保留本记录和Codex原输出，不扩展到其他道具。Godot为规范命名的概念图新建 `.png.import`。
- 用定稿覆盖 `SpiritualRealmWalker/images/cards/dance_together.png`，沿用已绑定的正式路径；运行时PNG哈希与概念定稿一致，导入配置重新导入。未改共舞代码、费用、消耗、伤害或本地化。
- 核对正在运行的游戏PID33360及可执行路径后按既有授权关闭，完成Release编译、PCK导出与部署，0警告、0错误。独立加载部署纹理1438×1093，全部RGBA8像素与第二张定稿一致；DLL、清单与源产物哈希一致。
- 新增忽略的 `.godot/verify_dance_together_final.gd` 及导入/核对日志。既有根证书、编辑器设置保存权限与旧布局引用提示未影响导入或部署验证。README和DEVLOG同步定稿结果；未重新启动游戏或提交Git，实际游戏显示待验收。
