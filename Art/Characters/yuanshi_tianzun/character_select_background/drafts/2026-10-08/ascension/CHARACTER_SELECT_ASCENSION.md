# 日月星本源动态试用版

2026-10-08用户要求将人物周围烟雾般的星云做成涌向人物的动态，同时应用此前方案的整体悬浮、衣袍、发丝和星光四项。当前已接入部署，尚未确认动态定稿。

## 动作

- 人物与脑后黑月整体悬浮：源图±6像素、12秒周期，在2560×1600显示时约±4像素。
- 左右袖摆、两侧及下方袍角按各自区域独立变形，肩膀、腰部、手和中央衣身固定；最大源图位移28/18像素，羽化和锚点保护减少实际幅度。左右节奏错开。
- 左右自由发梢独立起伏，6秒周期、最大源图13/8像素；根部、脸部和黑月不局部变形。
- 长袍已有星纹高光沿空间相位缓慢明灭，最大调制15%，不新增密集粒子。太阳印记仅轻微呼吸。
- 周围星云向胸口附近汇聚：两组连续向外取样的背景纹理交替混合，视觉上的云纹向人物收拢。每个相位淡出后重置，不会到循环末尾突然倒放。左右及脚下云纹有流动，左侧文字背景和远处树木保持安静。

## 原画与图层

3840×2400定稿PNG未修改，SHA256仍为F9B4ADE3AA3EEC1EBCDDC5FBF656089D6E47F85B0D8590AEB5690534D89E785C。实际人物、月亮、衣袍、头发及双手RGB全部采样该原画。

内置image_gen生成两张1586×992辅助图，完整实际提示词见`character-select-ascension-prompts.json`：

1. `character-select-cloud-cleanplate-v1.png`：去除人物和月亮后补绘星云。规范化到3840×2400用于人物后方露出的背景，新增填补区域是小图放大，不声称这些区域有原生4K细节。
2. `character-select-extraction-reference-v1.png`：透明提取尝试改变了人物比例，未使用它的人物RGB。仅作为不确定轮廓先验，与原图内容分析结合建立覆盖区域，并从原图圆形边缘拟合黑月。

运行时原画、补绘背景及覆盖纹理组成分离的背景/人物平面。覆盖纹理R为人物，G为移除旧人物并留出运动余量的区域。背景用补绘图填补后再流动，人物在其上整体移动和分区变形。没有把移动的人物重复叠在含有旧人物的底图上。

这是2.5D背景/人物分离与分区UV动画，不是骨骼绑定或物理布料模拟，也没有为每条衣料单独制作完整背面。发丝和衣角的抠取边缘仍以试用效果验收为准。

## 文件

- Shader：`SpiritualRealmWalker/scenes/character_select/yuanshi_tianzun_ascension.gdshader`
- 场景：`SpiritualRealmWalker/scenes/character_select/yuanshi_tianzun_bg.tscn`
- 辅助背景：`SpiritualRealmWalker/images/character_select/yuanshi_tianzun_cloud_fill.png`
- 覆盖纹理：`SpiritualRealmWalker/images/character_select/yuanshi_tianzun_subject_mask.png`
- 预览：`previews/character-select-ascension-preview.gif`、`previews/character-select-ascension-detail.gif`；轻量960×600聊天预览`previews/character-select-ascension-preview.webp`
- 像素记录：`character-select-ascension-validation.json`

GIF为Godot Mobile Vulkan、RTX4060渲染，1280×800、10帧/秒、12秒循环，固定256色调色板用于控制预览体积。游戏实时使用4K原画。

## 验证与部署

121帧循环验证首尾一致；左侧文字背景最大通道差0。在第3秒抵消2个预览像素的整体悬浮后，脸部、两个掌心及黑月内部样本最大通道差均为0。星云区域26613个像素在第3秒发生变化。

部署PCK再次进行GPU验证：关闭所有动作时与原图渲染完全一致；12秒循环一致；关闭场景脚本处理并暂停场景树后，默认生产配置仍自动播放。动画通过shader TIME驱动，不依赖脚本更新时间。4K原图文件哈希保持一致。

本次仅改资源，导出并替换PCK，DLL不变；当前部署PCK与暂存PCK的SHA256均为574B1032CA8630AF30E451E044AC412108B8C441FDC7D72271FE7020EB4BD845。将背景取样改为显式原画uniform，消除内置sampler作为函数参数时的headless编译提示后，部署GPU与5组布局检查再次通过。重启游戏加载，实际游戏显示与性能待用户验收。旧版shader与试用GIF保留，未删除无关文件或提交Git。
