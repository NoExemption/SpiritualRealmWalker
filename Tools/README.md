# 开发工具

工具源码由Git管理，输出、日志、帧序列和可重新生成的中间数据写入忽略的 `.godot/tool-output/` 或 `.godot/tool-logs/`。制作工具不随游戏PCK导出。

## 分类

| 目录 | 用途 |
|---|---|
| `Tools/Art/` | 定稿图导出、人物参考裁切、动态覆盖分析、图层准备、预览渲染和动画打包 |
| `Tools/Inspect/` | 原版卡框、字体、遗物尺寸、选人布局等只读检查 |
| `Tools/Art/Legacy/` | 已停止使用的旧稿处理及实验工具，使用前按对应输入条件准备素材 |
| `Tests/Art/` | 当前资源、部署PCK、布局、中文排版与GPU动态检查 |
| `Tests/Art/Legacy/` | 旧宽幅共舞与早期轻微动态方案的专项检查 |
| `Tools/Common/tool_paths.gd` | GDScript统一路径与参数解析 |
| `Tools/Art/tool_paths.py` | Python统一项目根目录与输出参数 |

2026-10-08从缓存目录移入55个工具文件，其中15个为历史工具；不删除历史实验代码。当前入口列在下方，历史工具与当前方案不能混用。

另将缓存子目录中3个.NET资源探查项目的6份源码/项目文件移入`Tools/Inspect/Dotnet/`，其编译输出留在缓存。探查工具使用第一个参数指定要读取的DLL，不依赖本机Steam或NuGet路径。例如：`dotnet run --project Tools/Inspect/Dotnet/CharacterSelectProbe -- "游戏目录/data_sts2_windows_x86_64/sts2.dll"`。

## 环境配置与统一运行入口

复制 `Tools/tool-settings.example.json` 到项目根目录 `tool-settings.local.json`，填写本机 `GameDir`、`GodotExe`、`PythonExe`。本机配置被Git忽略；移动项目无需修改项目内部图片路径，换电脑只需配置安装位置。当前电脑已配置。

统一入口：

```powershell
pwsh -NoProfile -File Tools/Invoke-Tool.ps1 -Script Tests/Art/verify_character_select_background_layout.gd
pwsh -NoProfile -File Tools/Invoke-Tool.ps1 -Script Tests/Art/verify_ascension_deployed.gd -Gpu
pwsh -NoProfile -File Tools/Invoke-Tool.ps1 -Script Tools/Inspect/inspect_relic_sizes.gd
```

`-GodotExe`、`-PythonExe`、`-GameDir`、`-ModPack`可覆盖配置；随后优先读取环境变量 `GODOT_EXE`、`PYTHON_EXE`、`STS2_GAME_DIR`、`SRW_MOD_PACK`，最后读取本机配置。未指定程序时尝试PATH中的`godot`与`python`。`-CheckOnly`只检查语法，`-Gpu`启用实际GPU渲染，其他GDScript默认headless运行。

GDScript支持 `--game-dir`、`--game-pack`、`--mod-pack`、`--cache-dir`；具体制作工具还支持 `--source`、`--cleanplate`、`--output-dir`等参数。通过 `-ToolArguments @('--参数', '值')` 传入。部署核对默认读取配置游戏目录中的当前PCK；检查暂存包时使用 `-ModPack` 指定，不再依赖历史会话的暂存目录。

传入数组参数时，在PowerShell中直接调用脚本，例如：`& ./Tools/Invoke-Tool.ps1 -Script Tools/Art/analyze_ascension_matte.py -ToolArguments @('--cache-dir', '独立输出目录')`。

Python依赖见 `Art/requirements.txt`：NumPy、OpenCV和Pillow。工具根据自身位置定位项目，支持 `--project-root`、`--cache-dir`、`--frames-dir`、`--output-dir`、`--source`和`--reference`。仅使用各工具相关的参数。

## 当前动态背景：从项目输入重新生成

输入为 `Art/Characters/yuanshi_tianzun/character_select_background/` 内已定稿背景，以及其 `drafts/2026-10-08/ascension/` 中的星云补绘和提取参考。无需访问Codex生成目录，清理Godot缓存后也可以从头生成。

按顺序执行：

```powershell
pwsh -NoProfile -File Tools/Invoke-Tool.ps1 -Script Tools/Art/analyze_ascension_matte.py
pwsh -NoProfile -File Tools/Invoke-Tool.ps1 -Script Tools/Art/prepare_ascension_layers.gd
```

第一步生成 `.godot/tool-output/ascension/` 中两份R8覆盖数据和分析报告；第二步生成该目录 `layers/` 下两张3840×2400辅助纹理。默认只写缓存输出，不覆盖当前正式纹理。确认需要接入时再将生成结果复制到正式资源目录并重新导入。

当前场景渲染与动画打包：

```powershell
pwsh -NoProfile -File Tools/Invoke-Tool.ps1 -Script Tools/Art/render_yuanshi_idle_preview.gd -Gpu
pwsh -NoProfile -File Tools/Invoke-Tool.ps1 -Script Tools/Art/package_ascension_preview.py
pwsh -NoProfile -File Tools/Invoke-Tool.ps1 -Script Tools/Art/package_ascension_web_preview.py
```

渲染工具名称沿用早期命名，实际加载当前本源动态场景，生成121帧到 `.godot/tool-output/idle-preview-frames/`。打包工具默认更新该资产的试用预览和验证记录；可用 `--output-dir`写到另一个目录，用`--frames-dir`指定已有帧。`package_yuanshi_idle_preview.py`只用于早期静止黑月方案，不能验证当前整体悬浮场景。

## 当前常用工具与检查

- 制作：`export_energy_icons.gd`、`export_character_card_relic.gd`、`export_yuanshi_character_select_portrait.gd`、`prepare_yuanshi_portrait_reference.gd`。
- 图片/PCK核对：`Tests/Art/verify_character_select_background.gd`、`verify_yuanshi_character_select_portrait.gd`、`verify_character_card_relic.gd`、`verify_energy_pack.gd`、`verify_dance_together_final.gd`。
- 布局与动态：`Tests/Art/verify_character_select_background_layout.gd`、`check_character_description_layout.gd`、`verify_ascension_deployed.gd`。
- GPU卡框组合：`Tests/Art/verify_full_card_style.gd`、`verify_candle_art.gd`、`verify_red_shoes_art.gd`、`verify_red_shoes_forms_final.gd`，需`-Gpu`。

目录、机器路径和导出隔离检查：`pwsh -NoProfile -File Tests/Verify-Tooling.ps1`。

旧稿在定稿时已清理，历史工具不意味着其旧输入仍然存在。重建实验需要先准备分区并提供生成后的分区图；黑月局部合成实验需要原始与修改图；历史卡图预览需要对应比较稿。详见 [历史工具说明](Art/Legacy/README.md)。当前定稿、提示词及历史证据仍以 [美术资产索引](../Art/README.md)为准。
