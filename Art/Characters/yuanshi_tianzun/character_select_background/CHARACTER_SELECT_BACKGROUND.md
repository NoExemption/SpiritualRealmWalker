# 元始天尊选人界面背景图

日期：2026-10-08<br>
状态：2026-10-08用户确认3840×2400细节重建与双手修正版正式定稿，已接入并部署。<br>
工具：内置 image_gen绘图，Godot准备尺寸并导入，Release编译部署；暂不制作动态。

## 原文依据

原文：`D:/Code/SpiritualRealmWalker/灵境行者.txt`，本轮小段阅读第136150—136170行。

- 第136156行：拾起星光交织的长袍及巴掌大的黑色圆月。
- 第136157行：两份本源化为星光、黑光融入体内，身后展开华丽星光长袍。
- 第136158行：脑后升起漆黑的圆月。
- 第136159行：日之神力在额头凝成金色太阳印记。
- 第136160—136165行：灵境震动、意识覆盖太阳系、初步掌握宇宙规则，随后出现于浩渺灵境。
- “巴掌大”描述拾起时的遗物，不是脑后黑月的强制尺寸。

## 用户方向与美术补充

- 用户指定小说结尾取得日月星三大本源的元始天尊，古式衣着，避免现代服装。
- 采用电影获得力量后悬浮的姿态：身体竖直、双臂自然向下外展、手掌开放、双足向下。
- 使用东方神话半写实厚涂游戏插画风格，墨蓝、银蓝、玄黑，额头金色太阳作为暖色焦点。
- 右侧人物，左侧约55%低对比空间供姓名、生命金币、四行介绍及初始遗物；底部尽量留给人物选择按钮。
- 半束长发、交领衣服、传统鞋、腰带与金色衣缘属于克制的美术补充，原文没有逐项规定。
- 远处神树剪影及星空雾层作为灵境环境提示，避免额外神祇、战争人群、现代建筑、王座与武器。

## 文件与尺寸

| 文件 | 实测像素 | 用途 |
|---|---:|---|
| [character-select-background.png](character-select-background.png) | 3840×2400 | 规范命名定稿，与已部署背景完全一致 |

项目内旧图、中间稿及其失效导入配置已按定稿流程清理；以下历史过程中的旧文件名用于追溯，不代表文件仍存在。具体40个删除文件的绝对路径见 `reconstruction/finalization-cleanup.json`。

- 提示词请求3840×2400及最高原生细节，但内置工具实际输出1586×992；不能将尺寸导出称为原生4K。
- 使用Godot Lanczos等比例缩放到3840×2402，再去除上下各1个输出像素，得到3840×2400。此过程仅准备尺寸，不重绘、补画或宣称增加细节。
- PNG为不透明背景。源图与输出重新加载核对尺寸成功；导出脚本退出码0。
- 忽略的尺寸准备脚本：`.godot/export_character_select_art.gd`；日志：`.godot/character-select-art-export.log`。
- 生成源文件仍保存在Codex默认输出位置；项目中的旧稿副本在正式定稿后已清理，没有删除Codex默认输出目录中的源文件。

原生生成来源：

1. `C:/Users/dasseinzumtode/.codex/generated_images/01a0e593-02fa-7321-9c90-7e4f1d81e979/exec-ea4f8a6c-7a94-4e6c-a90b-ae2b5fccf484.png`
2. `C:/Users/dasseinzumtode/.codex/generated_images/01a0e593-02fa-7321-9c90-7e4f1d81e979/exec-a6bd885a-59ca-418b-bf78-835c631f24d0.png`

## 当前定稿（2026-10-08）

用户在接入游戏后确认定稿。已确认的双手修正版规范命名为 `character-select-background.png`，SHA256仍为 `F9B4ADE3AA3EEC1EBCDDC5FBF656089D6E47F85B0D8590AEB5690534D89E785C`，尺寸仍为3840×2400，与正式PNG及部署PCK中的图像一致。定稿不重绘、不改变图像或布局。首轮整理遗漏清旧稿，用户指出后删除18张项目旧图/中间稿、18份对应导入配置及4个废弃脚本/UID，共40个文件；保留规范命名定稿、正式游戏资源、完整提示词、尺寸和验证记录。没有删除目录或触及其他道具，没有关闭游戏或提交Git；生产像素和布局不变，不重复编译部署。

## 高清接入验证（定稿前记录）

当前高清重建、双手修正与原生分区尺寸详见 [高清重建记录](reconstruction/README.md)，完整实际提示词及生成源路径保存在该目录的JSON中。2026-10-08按用户要求接入新版：正式PNG与此稿SHA256均为 `F9B4ADE3AA3EEC1EBCDDC5FBF656089D6E47F85B0D8590AEB5690534D89E785C`。导入使用 `compress/mode=0`、`process/size_limit=0`；从部署PCK重新读取尺寸3840×2400，全部RGB像素与修正版一致。原专用场景及布局未改，部署后五组屏幕/UI缩放检查全部通过。关闭已核实的游戏PID21472完成Release编译、PCK导出部署，0警告、0错误；未重启游戏，实际视觉效果待查看。

- 第一版黑月顶部约0.5%画面高度，16:9按比例填满时可能削顶；最低足尖约94%，进入底部人物按钮区。针对这些位置作一次构图修订。
- 修订版黑月顶部约10%，完整圆形和近黑暗纹可读；额头太阳、星光长袍及悬浮姿态保留。
- 主体缩小并向右收拢，左侧低对比空间增加。少量左端衣摆仍靠近画面中线，最终须以真实文本宽度核对。
- 两条手臂的肩肘腕连接、双手和双足未见明显缺失、重复或断接；主代理与只读美术复核均查看修订原图。
- 最低鞋尖仍约86%高度，靠近底部按钮区；是否遮挡依赖接入后的实际布局。未将样稿视觉检查当作游戏内验收。
- 绘图阶段不涉及动态拆层、着色器、角色选择背景绑定、角色机制、已有遗物和卡牌资源；后续按用户指示完成以下静态背景接入。

## 图2接入与部署（2026-10-08）

- 用户要求将图2接入游戏查看效果，选择构图修订版的3840×2400导出图。
- 正式资源：`SpiritualRealmWalker/images/character_select/yuanshi_tianzun_bg.png`，SHA256为`D0FFAF7DC51BAD47AA85A54A3513391671EF92D8D9D377B4914C99186F87F622`，与所选导出图一致。
- 在`YuanshiTianzunCharacter.CustomCharacterSelectBgPath`直接绑定上述PNG。RitsuLib 0.6.2背景工厂支持Texture2D，独立只读核对程序集确认`ExpandMode=IgnoreSize`、`StretchMode=KeepAspectCovered`、四边锚点铺满且偏移为0、`MouseFilter=Ignore`、`ClipContents=true`。背景等比居中覆盖，其他屏幕比例会裁切边缘而不拉伸变形，无需新增场景。
- Godot导入成功，Release编译、PCK导出与部署成功，0警告、0错误。部署前Get-Process未发现SlayTheSpire2进程，未关闭或启动游戏。CIM进程查询受沙箱限制，改用Get-Process完成核对。
- 独立加载部署PCK，3840×2400背景资源存在，与正式PNG和图2导出图全部RGB像素一致；验证脚本`.godot/verify_character_select_background.gd`退出码0。部署DLL和清单SHA256与源产物一致。
- 导入阶段既有根证书、旧编辑器布局及编辑器设置保存提示不影响上述检查结果。
- 仅新增选人静态背景及角色绑定；姓名、介绍、灰框、遗物说明、人物选择按钮和战斗内角色资源继续沿用现有设置。没有制作动态、删除文件或提交Git。
- 尚未取得实际游戏选人截图；左侧文本对比度及底部鞋尖/按钮遮挡待用户游戏内查看。

## 修复原版动画容器导致的放大裁切（2026-10-08）

- 用户随后提供实际游戏截图：背景明显放大，黑月顶部及人物脚部被裁。上述PNG直连方式已经由专用场景替代；图2PNG本身及所有像素不变。
- 原版`AnimatedBg`虽然为全屏锚点，却带偏移`(-388,-80,252,40)`，尺寸比父屏大640×120，初始缩放1.1、轴心(1280,600)。原版窗口尺寸回调在窄屏还会继续提高缩放，最大约1.2683。直接让静态纹理铺满此容器，会产生二次放大和额外裁切。
- 新绑定`res://SpiritualRealmWalker/scenes/character_select/yuanshi_tianzun_bg.tscn`。根控件保持原树层级和绘制顺序，进入树时清除工厂补入的全屏锚点及轴心，按实际选人界面尺寸布局，并通过自身缩放和全局位置抵消父容器变换；仅在值变化时更新。共享原版容器的偏移和缩放不改动。
- 子`TextureRect`使用`IgnoreSize`和`KeepAspectCentered`，等比完整显示图片，不裁剪图像边缘；比例不同的屏幕以深墨蓝色底补边。当前16:10画面可完整铺满，16:9等比例不再通过裁图填满。
- 新增忽略的布局验证脚本，模拟RitsuLib全屏锚点初始化和原版容器偏移，验证16:10、16:9、4:3、超宽比例，以及UI缩放0.8/1/1.333和父容器缩放1.1/1.115/1.2683共5组组合；背景全局矩形与实际屏幕一致，未修改共享容器。
- 首次普通权限关闭游戏失败，首轮部署因PID42108锁住DLL而失败。随后再次核对该PID及游戏路径，以既有部署授权关闭游戏，重新Release编译、PCK导出部署成功，0警告、0错误。
- 从实际部署PCK加载导出的场景及编译GDScript，5组布局检查通过、退出码0；背景PNG全部RGB像素仍与所选图2一致，DLL及清单SHA256匹配。脚本日志位于`.godot/character-select-background-deployed-layout-verify.log`。
- 实际游戏修复后的选人截图仍待确认；未重新启动游戏或提交Git。

## 第一版完整实际提示词

```text
Use case: stylized-concept.
Asset type: one finished static full-screen character-selection background illustration for a Chinese mythology game mod. Landscape 16:10 composition, target 3840 × 2400 pixels at the highest native detail available. This is artwork only, not a screenshot or interface mockup.

Scene and narrative: 元始天尊 / Zhang Yuanqing at the end of the novel 灵境行者, at the instant he has obtained the powers of the Sun, Moon and Stars and appears in the boundless spiritual realm. He is a serene, overwhelmingly powerful young Chinese man suspended in mid-air. The three canonical visual elements are: an exquisite robe woven from starlight opening behind his body, a PITCH-BLACK FULL CIRCULAR MOON behind his head, and a small golden SUN EMBLEM ON HIS FOREHEAD.

Composition, absolutely essential: create a wide continuous painted scene. Reserve the entire LEFT 55 percent of the canvas as calm, very low-contrast deep indigo atmospheric space so white and gold game-interface text can later be placed there. Do not paint text, panels, frames, menus or symbols into this space. The empty side must feel like a natural part of the same vast realm, with broad subtle mist and only a few very dim distant stars. Place the single full-body man on the RIGHT, face/head centered around x=77%, y=25%. His torso is vertical and his complete body floats down to approximately y=84%, with both feet visible and clear negative space underneath. All important anatomy, moon and robe edges fit inside the canvas. Keep his hands inside approximately x=61% to x=92%. Leave the bottom 15 percent quiet and low in detail for the later character-selection buttons. Keep important features inside the central 80 percent of the image height for a later 16:9 crop. No tilted diagonal hero composition.

Pose and anatomy: use the majestic movie-like posture of a person levitating after receiving enormous power: upright torso, shoulders open, chin very slightly raised, eyes open and gaze calm toward the viewer with a subtle upward direction. Both arms hang diagonally downward and outward about 30–40 degrees away from the torso; elbows relaxed with a slight natural bend. Both wrists connect visibly to their respective forearms. Palms gently face forward/upward; fingers naturally separated and relaxed. Exactly two anatomically correct arms and two hands, each with five distinct plausible fingers; no clenched fists or exaggerated spell gestures. Legs extend naturally downward beneath the robe, close but not fused, with one foot slightly lower and forward than the other; toes point gently down as in real levitation. Exactly two feet in elegant dark traditional cloth shoes. The robe may hide the knees but its silhouette must not imply extra legs. No aggressive fighting stance, throne or weapon.

Face and clothing: handsome young adult East Asian male, human proportions, refined but clearly masculine face, clear readable eyes, calm dignified expression, no beard. Black long hair, partially tied high with simple loose lengths lightly floating; a few graceful strands only, no tentacle-like hair. Ancient-inspired cross-collar inner clothing, dark navy waist belt and wide flowing sleeves, no modern clothes, business suit, zippers or contemporary trousers. A magnificent deep-indigo and ink-blue starlight outer robe unfolds behind his shoulders and around his body, with broad clearly painted cloth folds and sparse luminous silver-blue stars woven INTO the fabric. Cloth moves upward and outward in broad graceful curves and settles into elegant asymmetrical folds; it remains readable fabric, not galaxy smoke, wings or innumerable thin ribbons. Separate hand silhouettes from the sleeves. Keep the robe mainly within the right half. Do not let bright fabric extend into the left text area.

Moon: exactly ONE perfectly round solid BLACK full-moon disc suspended directly behind the HEAD, about 1.8–2.2 head-widths in diameter, aligned like a dark majestic halo. Face, hair and head overlap its center in front. Its surface is extremely dark, with restrained irregular ink-black and charcoal-black tonal patches, subtle layered dark-cloud texture to convey mysterious noble depth. It must read as an opaque near-black celestial disc, NOT a realistic gray lunar photograph, NOT a white moon, crescent, eclipse with blazing corona, portal, black hole or rune circle. A very thin cool muted gray-blue rim and a faint local atmospheric separation may make the disc distinguishable from the backdrop, but its interior stays black and the circular silhouette remains clear. No bright ring, ornaments or symbols inside the moon.

Sun: a SMALL sharply readable warm gold sun mark centered on the man's forehead: one simple golden disc with a few tiny short rays. It glows gently and highlights his brow; it is part of his forehead, not a floating sun, third eye, jewel, crown or oversized flame. Gold is a restrained accent at this single focal point.

Background: a vast spiritual realm suggested by layered deep blue-black mist, faraway sparse stars and a quiet suggestion of immense depth. Far on the right only, a barely visible distant silhouette of a gigantic divine tree may be suggested through haze; it should remain subordinate and indistinct. The central-right figure and robe are the entire focal point. No extra characters, kneeling crowds, other gods, foreground buildings, detailed planets, stone platforms or cityscape. Do not fill the left side with a giant luminous galaxy or bright nebula.

Style and light: high-quality hand-painted EASTERN MYTHOLOGICAL SEMI-REALISTIC DIGITAL GAME ILLUSTRATION, with deliberate thick painterly brushwork, crisp designed silhouettes and broad grouped light-and-shadow planes. Anatomically believable humans and cloth, stylized edges and simplified distant background. Consistent with painted deck-building game artwork. Cool starlight gently describes the face, hands and folds; warm forehead gold contrasts with indigo, silver-blue and ink-black. Rich but controlled values, majestic, mysterious, sacred and composed. Keep facial features and cloth texture readable at full-screen scale without overly fine visual noise. No photography, glossy 3D rendering, anime face, comic cel outlines, excessive lens flare, red horror lighting or explosion of magical effects.

Output constraints: ONE cohesive complete landscape artwork, opaque background, no caption, writing, letters, logo, watermark, UI, card frame, borders, split panels or multiple versions. Highest native image detail, preserve the 16:10 wide composition and all reserved UI-safe space.
```

## 构图修订完整实际提示词

参考图片是第一版原生图，作为编辑目标，使用referenced_image_paths传入。

```text
Use case: precise-object-edit.
Image 1 is the edit target, a finished character-selection illustration. Preserve its 16:10 landscape aspect ratio and cohesive hand-painted semi-realistic Eastern mythology style. Request the highest native pixel detail available; desired final canvas 3840 × 2400.

Make ONLY a compositional size and placement correction to the EXISTING right-side floating man, his attached robe and the black moon. Preserve the same young Chinese male identity and expression, long black hair, small golden forehead sun, deep indigo starwoven robe, silver-blue painted fabric, and exactly the current upright levitating pose, open relaxed hands and two pointed-down traditional shoes. Preserve the background atmosphere, palette and distant right-side tree.

Scale the man and his entire attached starwoven robe DOWN uniformly to about 80–82% of their present size, without changing his proportions or inventing a new pose. Reposition this smaller grouped figure at center x approximately 77%, with his head center at y approximately 26%, and the lowest shoe ending at y=83–84%. Both feet must be clear and comfortably above the bottom 15% of the canvas. Maintain natural shoulders, elbows, wrists and fingers, five fingers per hand, two arms, two hands and two feet. The drapery remains broad physical cloth with starlight woven into it.

Reposition the existing opaque pitch-black circular moon behind his head so that its COMPLETE circular top stays below y=9% and its bottom behind the shoulders; the entire circle is inside the image with breathing room. Reduce its diameter together with the figure, keep it near-black with the same restrained irregular dark textures and thin muted blue-gray boundary. No new glowing corona, gray moon, white moon or black-hole effect. Head overlaps the disk in front. Preserve the small golden SUN MARK ON THE FOREHEAD.

Bring the outer robe folds inward slightly as needed to fit: keep all bright fabric and all human features to the RIGHT of the canvas's x=55% boundary. The left 55% must remain calm deep-blue atmospheric background for later interface text; paint matching quiet background into newly uncovered areas, with no visible seams or obvious vertical dividing line. Keep the rightmost cloth fold at least 3% away from the right image edge. Keep the bottom 15% quiet with NO shoes or significant cloth ends. This correction must increase safe margins, not crop the figure or stretch the canvas.

Do not change the face, anatomy, costume design, colors, forehead emblem, texture style or background visual identity. No UI, text, panels, logos, watermarks, extra subjects or split images. One finished static full-screen artwork only.
```
