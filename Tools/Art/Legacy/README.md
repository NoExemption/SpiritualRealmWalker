# 历史美术工具

这些工具保留实验算法和构图检查方法，不参与当前生成流程。旧稿已按定稿要求清理，没有从Codex会话目录自动寻找旧输入。

- `prepare_character_select_reconstruction.gd`、`prepare_character_select_hands.gd`：默认从当前定稿图裁切，可用`--source`改输入、`--work-dir`改工作目录；输出是缓存中的区域图。
- `assemble_character_select_reconstruction.gd`：需要工作目录里的`manifest.json`及各`tile-*-generated.png`。先裁切、完成分区绘制，再合成；不会自行调用绘图服务。
- `export_character_card_black_moon.gd`、`inspect_character_card_moon.gd`：通过`--input-dir`提供包含`character-card-source.png`和`character-card-black-moon-generated.png`的实验目录。默认目录中的这些旧稿已清理，必须另行提供输入。
- `export_character_select_art.gd`、`inspect_character_select_reconstruction.gd`：原低清导出与重建对照实验，使用前准备对应输入；不代表当前4K原生生成方案。
- `preview_red_shoes_*.gd`：保留各次构图检查方式，数组中的历史稿文件需在对应资产目录准备后才能重跑；当前定稿检查用`Tests/Art/verify_red_shoes_forms_final.gd`。
- `preview_character_select_clarity.gd`及`character_select_clarity_experiment.gdshader`：早期清晰度实验，当前正式背景不依赖这些工具。

历史检查位于`Tests/Art/Legacy/`，旧方案对保护区域的预期与当前悬浮动画不同。不要将旧检查的失败解释为当前动态回归失败。
