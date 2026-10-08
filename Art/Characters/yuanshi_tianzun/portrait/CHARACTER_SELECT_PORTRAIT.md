# 元始天尊角色选择头像

日期：2026-10-08。状态：用户已确认定稿，已规范命名、绑定并部署；重新启动游戏后加载新头像，界面显示待查看。

## 依据与构图

用户确认的方案：以三辰本源背景中的同一面貌重绘近景胸像，略抬下巴、沉静目光、长发与发冠，脑后玄黑圆月、额头金日、肩披星袍。参考定稿背景 `../character_select_background/character-select-background.png`；原文要点沿用 [选人背景记录](../character_select_background/CHARACTER_SELECT_BACKGROUND.md) 中第136156—136159行。发冠与衣缘延续已接受的美术补充，不宣称原文逐项规定。

灰蓝雾光为背景，脸部作为主要亮面，黑月与黑发用银蓝细轮廓区分。图中只画头、肩和上胸，人物下方有意裁切，不含手、UI、文字或按钮边框。

## 本机原版尺寸与状态核对

- 原版PCK路径 `res://images/packed/character_select/char_select_ironclad.png`，与静默、摄政、亡灵契约师、故障机器人等头像均为132×195。
- 按钮场景 `res://scenes/screens/char_select/char_select_button.tscn`，内部头像TextureRect约88×130，并通过Mask裁切。
- 选中和普通未选中复用一张CharacterSelectIcon，由原版HSV shader与独立outline改变状态；不分别重画两张头像。LockedIcon属于未解锁状态。
- 检查日志 `.godot/character-select-portrait-inspect.log`，本机程序集状态检查 `.godot/character-select-probe.txt`；RitsuLib 0.6.2本机XML确认支持 `CustomCharacterSelectIconPath`。

## 文件与核对

| 文件 | 实测像素 | 用途 |
|---|---:|---|
| [character-select-portrait.png](character-select-portrait.png) | 1032×1523 | 内置image_gen原生母图，规范命名定稿 |
| [character-select-portrait-icon.png](character-select-portrait-icon.png) | 132×195 | 规范命名定稿头像 |

母图实际尺寸接近132:195比例，导出时Lanczos等比缩至133×195，取132×195区域，仅去除右侧1个导出像素，无拉伸。重新加载核对132×195且不透明，保存退出码0。另在忽略的缓存中导出88×130用于查看。

已查看原生图、132×195与88×130：额头金日仍是独立亮点，五官和黑月轮廓可辨；发冠、脸部未被裁切。黑月细节和衣袍刺绣在小图中压缩为整体明暗。实际原版遮罩、未选中HSV调暗、选中亮框和界面组合尚未做游戏内验收。

原生生成源：`C:/Users/dasseinzumtode/.codex/generated_images/01a0e593-02fa-7321-9c90-7e4f1d81e979/exec-6d7e0cd4-3535-4808-85ea-e14b3c41552e.png`。复制入项目，保留默认生成源。辅助身份参考只是从背景截取面貌，并非新美术作品。没有改变已定稿背景、角色绑定、机制，未编译部署、删除文件或提交Git。

## 定稿接入（2026-10-08）

- 用户确认定稿，原样将两份v1文件移动为上述规范名称，不保留重复旧稿。两份旧名import原本不存在；Godot重新导入生成有效定稿配置。
- 母图SHA256：`5965D352356768B8E546EF5C06E4DA366621DFE6A2C9ED8A4CC5367A9D39A816`。
- 132×195头像SHA256：`F5F7433F73291EBDCE39A8BFDB0258A89DCBED87BF95A7A6982CFC7C1A5D146B`，与正式PNG一致。
- 正式PNG：`SpiritualRealmWalker/images/character_select/yuanshi_tianzun_icon.png`。元始天尊角色覆盖 `CustomCharacterSelectIconPath`，原版选中、未选中HSV与亮框保持原处理。战斗等尚未完成资源仍复用铁甲战士。
- Release编译0警告、0错误，暂存及正式部署PCK中132×195纹理全部RGB像素与规范定稿一致。导入无损、尺寸限制0；已定稿3840×2400背景核对继续通过。
- 游戏PID61164的路径查询未返回可执行路径，核对名称后尝试关闭被Windows拒绝访问，曾请用户退出游戏。随后直接更新部署文件成功，DLL/PCK/清单与构建产物的SHA256全部匹配，部署已完成；仍在运行的游戏需要重新启动后加载新版，没有宣称当前进程已热更新。
- 项目内两份v1样稿均已改为规范命名定稿，无重复旧图或失效旧名import，生成原图仍留在Codex默认目录。没有修改其他角色机制、关闭或启动游戏、删除无关文件或提交Git。

## 完整实际提示词

```text
Use case: identity-preserve.
Asset type: Slay the Spire 2 character-selection button portrait, a narrow vertical hand-painted game illustration.
Primary request: Create ONE new close-up portrait of Yuanshi Tianzun, the same young Chinese male deity shown in the supplied approved artwork, after gaining sun, moon and stars.
Input images: Image 1 is a close appearance reference for the same person's face, hair, small crown, forehead mark and indigo starwoven clothing; Image 2 is the approved full-screen painting for matching identity, colors and painterly style. These are references, not crop targets. Recompose into a centered close-up bust portrait.

Canvas: EXACT vertical aspect ratio 132:195 (44:65), maximum available native detail. This will be reduced to 132 × 195 pixels, so design readable bold forms.
Composition: head, neck, shoulders and upper chest only. Center the face. The crown stays inside a generous 6% top margin. Head and hair together occupy roughly 65–75% of the image width; face large enough for both eyes and expression to survive at tiny size. Face is nearly frontal, chin raised very slightly, calm dignified gaze directed forward and subtly upward. Preserve his actual facial identity from reference: same oval face and jaw, dark brows and eyes, straight nose, lips, warm pale skin and long black hair. Shoulders extend naturally to both bottom corners; chest is cut off by the bottom, intentionally. No hands or arms in frame.
Hair: same half-tied long hair and modest antique crown as the reference. Hair flows softly toward both sides with a few broad strands, emphasizing a clear head silhouette. Simplify microscopic strands instead of cluttering the portrait.
Moon: exactly ONE perfectly circular opaque BLACK full-moon disc directly behind the head, completely within the frame with narrow margins, about 88% of the canvas width in diameter. Head and hair overlap it in front. Near-black with only restrained irregular ink-black and charcoal-black painted tonal variation. Very thin muted cool blue-gray outer edge. It must remain black, noble and mysterious; no gray realistic lunar surface, bright white moon, crescent, black-hole vortex or bright glowing corona.
Sun: a SMALL gold sun mark centered on his forehead, simple golden disc with a few short rays, crisp and readable. Gentle warm accent; preserve this physical forehead mark, no floating sun or giant magical effects.
Stars: shoulders and upper chest wear the same ancient cross-collar deep indigo starwoven robe, silver-blue fabric planes, restrained gold trim and a few clear star glints integrated into the cloth. Reduce the reference embroidery to legible grouped motifs; no dense sparkles. Keep the costume identity, not a new armor design.
Backdrop: quiet simple cool gray-blue mist surrounding the black moon, slightly lighter than black hair so silhouette is clear. No tree, landscape, buildings, planets, extra subjects or complicated nebula.
Style: match the references' Eastern mythology semi-realistic hand-painted game illustration, slightly simplified broad paint planes and confident edges suitable for a small icon. Face is the main light focal area; black moon, indigo robe and hair form grouped dark shapes. Warm gold is a small accent. Cohesive skin anatomy, clean eyes and facial planes. No glossy plastic skin, photo, 3D render, anime eyes, oversharpening halos or excessive grain.
Output: ONE cohesive full-bleed vertical illustration with opaque painted background. No card frame, UI button, border, lettering, symbol overlay, text, logo, watermark, comparison panels or multiple alternatives. The game will add its own selection outline.
```
