# 美术资产目录

按资产用途和名称归档，寻找素材时不需要先知道制作日期。每个资产目录保存定稿母图、必要的导出图和绘图记录；游戏实际加载的资源仍位于 `SpiritualRealmWalker/images/`，本目录不进入游戏PCK。

```text
Art/
├─ Cards/
│  ├─ bloodthirsty_blade/
│  ├─ cat_king_speaker/
│  ├─ heavenly_toad_incense_burner/
│  ├─ steadfast_orb/
│  ├─ ever_burning_candle/
│  ├─ red_dance_shoes/                 主牌、追杀与穿戴
│  └─ dance_together/
├─ Relics/
│  └─ character_card/
├─ Characters/
│  └─ yuanshi_tianzun/
│     ├─ portrait/
│     └─ character_select_background/
│        ├─ reconstruction/           高清重建与手指修正记录
│        └─ drafts/2026-10-08/
│           ├─ idle/                  早期轻微动态试用记录
│           └─ ascension/             当前本源动态试用稿
└─ UI/
   ├─ energy_icons/
   └─ card_style/
```

## 素材索引

| 资产 | 绘图或实现记录 | 当前素材状态 |
|---|---|---|
| 嗜血之刃 | [绘图记录](Cards/bloodthirsty_blade/BLOODTHIRSTY_BLADE.md) | 当前接入版本 |
| 猫王音箱 | [绘图记录](Cards/cat_king_speaker/CAT_KING_SPEAKER.md) | 当前接入版本 |
| 天蟾香炉 | [绘图记录](Cards/heavenly_toad_incense_burner/HEAVENLY_TOAD_INCENSE_BURNER.md) | 已确认定稿 |
| 沉稳者宝珠 | [绘图记录](Cards/steadfast_orb/STEADFAST_ORB.md) | 已确认定稿 |
| 永不熄灭的蜡烛 | [绘图记录](Cards/ever_burning_candle/EVER_BURNING_CANDLE.md) | 已确认定稿 |
| 红舞鞋、追杀、穿戴 | [共用绘图记录](Cards/red_dance_shoes/RED_DANCE_SHOES.md) | 三张插图已确认定稿 |
| 共舞 | [绘图记录](Cards/dance_together/DANCE_TOGETHER.md) | 已确认第二张图定稿 |
| 角色卡遗物 | [绘图记录](Relics/character_card/CHARACTER_CARD.md) | 玄黑月印版已确认定稿 |
| 元始天尊头像 | [绘图记录](Characters/yuanshi_tianzun/portrait/CHARACTER_SELECT_PORTRAIT.md) | 母图与132×195头像已确认定稿 |
| 元始天尊选人背景 | [绘图记录](Characters/yuanshi_tianzun/character_select_background/CHARACTER_SELECT_BACKGROUND.md) | 3840×2400静态原图已确认定稿 |
| 本源动态背景 | [当前试用记录](Characters/yuanshi_tianzun/character_select_background/drafts/2026-10-08/ascension/CHARACTER_SELECT_ASCENSION.md) | 已接入试用，尚未确认定稿 |
| 早期轻微动态背景 | [历史试用记录](Characters/yuanshi_tianzun/character_select_background/drafts/2026-10-08/idle/CHARACTER_SELECT_IDLE.md) | 保留历史说明与检查记录，已清理被替代的旧预览 |
| 三辰能量图标 | [图标说明](UI/energy_icons/ENERGY_ICONS.md) | 已确认定稿 |
| 三辰卡身与边框 | [当前样式](UI/card_style/CARD_STYLE.md)、[概念记录](UI/card_style/THREE_LUMINARIES_CARD_CONCEPT.md) | 游戏内外观已验收 |

“已确认定稿”指用户已选定美术版本；各素材的接入检查、游戏显示与验收范围以对应记录为准。

## 维护约定

- 分类目录采用 `Cards`、`Relics`、`Characters`、`UI`；资产目录使用稳定的英文标识，文件名维持现有命名，避免目录迁移同时改动图片身份。
- 同一资产的定稿母图、必要的导出图、说明和导入配置放在一起；同源形态图可共用一个目录，例如红舞鞋的主牌、追杀、穿戴。
- 新试稿放在对应资产的 `drafts/YYYY-MM-DD/` 下，必要时再按方案命名子目录。日期只表示试稿批次，不作为整个美术库的主分类。
- 提示词、原文依据、生成源路径、尺寸和验证结果随资产记录。已定稿资产不长期保留多份重复图；确认定稿后按[绘图规范](ART_GUIDELINES.md)清理该资产旧稿。未确认的试用素材保留，本次整理没有删除任何图片。
- 高清重建、修正等历史证据可保存在资产内的 `reconstruction/` 等记录目录。历史删除清单及开发日志中的旧路径表示操作当时的位置，不应为了迁移改写删除事实。
- `.png.import` 随PNG移动，更新源路径后由Godot重新导入；正式运行时路径保持稳定。文档、导出与预览工具引用美术母图时必须同步更新。
- 动画演示文件放在试稿的 `previews/` 内，以 `.gdignore` 排除Godot纹理导入。GIF与动画WebP用于查看效果，不能作为游戏静态纹理导入。

2026-10-08迁移清单与文件校验结果见 [directory-migration.json](directory-migration.json)。全库绘图规则见 [ART_GUIDELINES.md](ART_GUIDELINES.md)。
