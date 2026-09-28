# SpiritualRealmWalker 开发日志

本文按时间记录项目的实际开发过程，包括任务目标、文件变动、故障原因和验证结果。项目当前用法与有效状态见 [README.md](README.md)，当前玩法方案见 [DESIGN.md](DESIGN.md)。

## 记录规范

每天的开发内容使用三级标题，按发生顺序从1开始编号；新的一天重新从1开始。

每项记录尽量包含以下内容：

- **目标**：本次工作要解决的问题。
- **新增**：新建的源码、配置或资源文件。
- **修改**：已有文件的具体变化。
- **删除**：删除的明确文件；没有删除时也应说明。
- **验证**：编译、导出、日志或游戏界面验证结果。
- **限制与下一步**：仍未验证或尚未实现的内容。

工具自动生成的 `.godot/` 缓存和编译中间文件只记录类别，不逐项罗列。

## 2026-09-28

### 1. 创建正式项目骨架

**目标**

在 `D:\Code\SpiritualRealmWalker` 建立可编译的正式 Godot C# Mod 项目。

**新增**

- `project.godot`：Godot 项目入口。
- `SpiritualRealmWalker.csproj`：C# 项目配置，目标框架为 `net9.0`。
- `ModEntry.cs`：Mod 初始化入口。
- `SpiritualRealmWalker.json`：Mod 清单。
- `.gitignore`：排除 `.godot/`、`bin/`、`obj/` 和编辑器缓存。
- `README.md`：最初的项目说明与进度记录。

**自动生成**

- `.godot/`：Godot 缓存、导入信息和编译中间文件。
- `ModEntry.cs.uid`：Godot 脚本稳定标识。

**验证**

- Release 编译为 0 个警告、0 个错误。
- Godot 4.5.1 Mono 无界面导入成功。

**删除**

- 未删除文件。

### 2. 补充项目学习说明

**修改**

- 扩充 `README.md`，加入文件用途、自动生成内容、环境路径、开发流程和验证状态。

**验证**

- 核对实际文件清单并回读文档。
- 本次没有功能代码变化，因此没有重复编译。

**删除**

- 未删除文件。

### 3. 修正编译输出中的清单复制

**问题**

首次 Release 编译成功，但输出目录缺少 `SpiritualRealmWalker.json`。

**修改**

- `SpiritualRealmWalker.csproj`：将清单条目由 `None Update` 改为 `None Include`，显式加入项目并保留 `PreserveNewest` 复制规则。

**验证**

- 再次编译为 0 个警告、0 个错误。
- 输出目录同时包含 DLL 和 JSON，清单副本与源码文件哈希一致。

**自动生成**

- `.godot/` 下的 DLL、调试符号、清单副本和中间文件得到更新。

**删除**

- 未删除文件。

### 4. 首次部署并验证空 Mod 加载

**新增到游戏目录**

- `mods\SpiritualRealmWalker\SpiritualRealmWalker.dll`
- `mods\SpiritualRealmWalker\SpiritualRealmWalker.json`

**验证**

- 部署文件与编译产物的 SHA256 一致。
- 通过 Steam 启动游戏。
- `godot.log` 确认发现清单、加载 DLL、调用 `ModEntry.Initialize`，并输出 `[SpiritualRealmWalker] Initialized v0.1.0`。

**限制**

- 该次验证只证明空 Mod 入口可加载，不代表角色和战斗内容已实现。

**删除**

- 未删除文件。

### 5. 初始化 Git 仓库

**新增**

- `.git/`：通过 `git init -b main` 生成的本地仓库元数据。

**说明**

- 保留现有 `.gitignore`。
- 本次未暂存、未提交、未设置全局 Git 配置。
- 后续由用户完成初始提交，并配置 `origin` 远程仓库。

**删除**

- 未删除文件。

### 6. 接入并验证 RitsuLib 0.6.2

**决策**

- 项目只直接依赖 RitsuLib，不同时直接引用 BaseLib。
- 固定使用 RitsuLib 0.6.2，并选择游戏 `0.111.0` 的兼容运行时。

**修改**

- `SpiritualRealmWalker.csproj`：新增 `STS2.RitsuLib` 0.6.2 NuGet 引用。
- `SpiritualRealmWalker.json`：声明 `STS2-RitsuLib` 运行时依赖。
- `ModEntry.cs`：新增 Mod ID，并通过 `ModTypeDiscoveryHub.RegisterModAssembly` 注册当前程序集。
- `README.md`：记录依赖决策和验证状态。

**新增到游戏目录**

- `mods\STS2-RitsuLib`：完整 RitsuLib 运行时，包含 loader、shared、`compat\0.111.0`、`assets.zip` 和 viewer 等内容。

**验证**

- NuGet 还原和 Release 编译为 0 个警告、0 个错误。
- 官方发布压缩包 SHA256 为 `605E7129DBFB1FC9B8500F50609230F95734103CDD94C40E944B9309E9E1B4A0`，与发布摘要一致。
- 游戏日志确认 RitsuLib 0.6.2 使用 0.111.0 兼容分支，框架补丁全部成功，随后 SpiritualRealmWalker 完成初始化。

**删除**

- 安装完成后逐个删除本次下载的临时压缩包。
- 未修改、暂存或删除用户已有的 `灵境行者.txt`。

### 7. 建立“元始天尊／夜游神”最小角色骨架

**目标**

建立可注册的角色、专属内容池、十张初始牌和中英文本地化骨架。

**新增**

- `Characters/YuanshiTianzunCharacter.cs`：注册可立即选择的“元始天尊”，定义 75 生命、99 金币和临时主题色。
- `Characters/NightWandererCardPool.cs`：夜游神卡牌池。
- `Characters/NightWandererRelicPool.cs`：夜游神遗物池。
- `Characters/NightWandererPotionPool.cs`：夜游神药水池。
- `Cards/NightStrike.cs`：初始攻击牌“夜袭”，1 费造成 6 点伤害，升级增加 3 点。
- `Cards/ShadowGuard.cs`：初始技能牌“影护”，1 费获得 5 点格挡，升级增加 3 点。
- `SpiritualRealmWalker/localization/zhs/characters.json`
- `SpiritualRealmWalker/localization/zhs/cards.json`
- `SpiritualRealmWalker/localization/zhs/ancients.json`
- `SpiritualRealmWalker/localization/eng/characters.json`
- `SpiritualRealmWalker/localization/eng/cards.json`
- `SpiritualRealmWalker/localization/eng/ancients.json`
- `export_presets.cfg`：Godot PCK 导出配置。
- `SpiritualRealmWalker.sln`：Godot Mono 导出 C# 项目所需的解决方案。

**修改**

- `SpiritualRealmWalker.csproj`：加入 Godot 路径、部署目录、本地化输入和 `DeployMod` 构建目标。
- `SpiritualRealmWalker.json`：启用 PCK、标记为影响玩法并更新主题说明。
- `YuanshiTianzunCharacter.cs`：根据当前游戏 API 补齐动画延迟和建筑师攻击特效接口。
- `NightStrike.cs`：向当前版本的 `FromCard` 调用传入 `CardPlay`。
- `README.md`：同步项目结构、构建方式和验证记录。

**验证**

- Release 编译和部署构建均为 0 个警告、0 个错误。
- 当时的七份 JSON 全部通过语法解析。
- 游戏日志确认角色、两张卡和两项初始牌配置共 5 项注册成功，中英文地化表完成合并。

**限制**

- 角色视觉暂用铁甲战士，攻击特效暂用游戏通用斩击。
- 该次日志验证没有覆盖实际点击角色并进入战斗。

**删除**

- 未删除文件。
- 未修改、移动或整本读取 `灵境行者.txt`。

### 8. 修复选择元始天尊后沿用上一角色

**问题**

元始天尊能出现在角色选择界面，但点击后游戏仍以上一个有效角色开局。

**诊断**

- `godot.log` 显示 `NCharacterSelectScreen.SelectCharacter` 抛出 `ArgumentOutOfRangeException`。
- 选择状态因此未能写入，开局沿用了此前角色。
- 原因是夜游神遗物池为空，而角色选择详情会读取第一件初始遗物。

**新增**

- `Relics/NightToken.cs`：注册夜游神专属初始遗物“夜游令”；当前没有额外效果。
- `SpiritualRealmWalker/localization/zhs/relics.json`：夜游令简体中文文本。
- `SpiritualRealmWalker/localization/eng/relics.json`：夜游令英文回退文本。

**修改**

- `README.md`：记录故障、原因、修复状态和复测要求。

**验证**

- Release 编译和部署构建为 0 个警告、0 个错误。
- 游戏日志确认 7 项自动注册全部成功，其中包括 `NightToken` 及其初始遗物绑定。
- 中英文 `relics.json` 均已合并。
- 当前仍会出现缺少夜游令专属图标的占位资源警告。
- 修复后的实际角色选择和开局结果等待用户界面复测。

**删除**

- 未删除文件。
- 部署前关闭正在运行的游戏进程，以便更新 DLL。

### 9. 拆分项目说明与开发日志

**目标**

让入口文档和过程记录分别承担清晰职责，避免 README 随开发过程持续膨胀。

**新增**

- `DEVLOG.md`：迁移并重组全部历史开发记录，统一为目标、文件变化、验证、限制和删除情况。

**修改**

- `README.md`：重写为项目入口，保留当前功能、环境、目录结构、构建部署、验证方法、维护规则和下一步。
- 修正旧说明中“遗物池尚未注册专属遗物”等已经过期的状态。

**验证**

- 回读两份文档并核对交叉链接、当前文件结构和已完成状态。
- 本次只改文档，不需要重新编译或部署。

**删除**

- 未删除项目文件；原 README 中的历史信息已经迁移到本文件。

### 10. 建立独立玩法设计文档

**目标**

将当前已经确定的夜游神第一版机制与按时间记录的开发过程分离，使现行规则能够集中查阅和持续修订。

**新增**

- `DESIGN.md`：集中记录第一版等级经验、太阴之力、太阴之灵、初始牌组、夜游、噬灵、第一幕 Boss 晋升试炼和角色卡职责，并单列尚未确定的设计。

**修改**

- `README.md`：增加 `DESIGN.md` 的文档入口和项目结构说明；将角色实际开局改为已验证；将下一步更新为实现当前设计方案。
- `DEVLOG.md`：在文档入口中增加设计文档链接，并追加本次文档调整记录。

**验证**

- 回读三份 Markdown 文档，检查交叉链接、章节结构和当前已确定规则。
- 本次只修改文档，没有修改功能代码，因此不需要重新编译或部署。

**删除**

- 未删除文件。

### 11. 实现第一版夜游神机制

**新增**

- `Cards/NightTravel.cs`：1费无实体，保留、消耗，永久初始牌。
- `Cards/SpiritDevour.cs`：1费8伤害，直接击杀后治疗3、回能1、生成原版晕眩，否则施加1虚弱；可循环使用。
- `Progression/NightWandererProgression.cs`：集中管理1—3级、300经验封顶及四档试炼阈值。
- `Tests/Verify-Progression.ps1`：验证等级边界、经验封顶、试炼分档、典型路线及双语文本键。

**修改**

- `Relics/NightToken.cs`：改为角色卡逻辑；累计经验使用原版 SavedProperty 保存，遗物计数显示等级，动态说明显示经验、治疗和试炼档位；实现战前治疗、战后经验和第一幕 Boss 强化。保留类名和模型 ID。
- `Cards/NightStrike.cs`、`Cards/ShadowGuard.cs`：初始数量由各5张改为各4张。
- `SpiritualRealmWalker/localization/zhs/cards.json`、`eng/cards.json`：新增两张职业牌文本。
- `SpiritualRealmWalker/localization/zhs/relics.json`、`eng/relics.json`：夜游令更名为角色卡，增加动态说明。
- `README.md`：同步功能、文件职责、验收步骤及部署状态。
- `DESIGN.md`：记录实现状态、暂禁升级、Boss目标和联机去重规则，明确能量界面仍沿用原版。
- `DEVLOG.md`：记录本次文件变化及验证限制。

**验证**

- Release 编译：0警告、0错误。
- 32项成长边界检查通过，全部本地化 JSON 可解析，中英卡牌和遗物键一致。
- 检查发现游戏进程仍在运行，本次未关闭游戏、未覆盖部署目录。

**限制与下一步**

- 本次编译和规则检查不等同于游戏内验证；需新局检查伤害、最后一击治疗、消耗/保留、读档、Boss和联机。
- 两张新牌升级方案尚未确定，暂时不可升级。
- 联机试炼按队伍中最高档强化一次，各人独立保存经验；尚未联机验证。
- 保留旧遗物 ID 不代表迁移旧牌组，新局才会使用4＋4＋1＋1配置。
- 本次仅沿用原版能量，未替换能量球图标或全局能量提示。

**自动生成与删除**

- 编译更新 `.godot/mono/temp/` 内 DLL、调试符号及中间产物。
- 未删除文件，未修改小说原文，未暂存或提交 Git。

### 12. 部署第一版夜游神机制

**目标与验证**

- 确认游戏进程已退出，执行 Release 编译和 Godot PCK 导出部署。
- 构建成功：0警告、0错误；PCK 导出成功。
- 部署 DLL 与编译产物、部署 JSON 与源码清单的 SHA256 分别一致。
- 尚未启动游戏验证本版本实际行为，下一步新开局验收。

**修改与自动生成**

- 覆盖游戏 `mods/SpiritualRealmWalker/` 内的 `SpiritualRealmWalker.dll`、`SpiritualRealmWalker.json`、`SpiritualRealmWalker.pck`。
- Godot 自动生成 `Cards/NightTravel.cs.uid`、`Cards/SpiritDevour.cs.uid`、`Progression/NightWandererProgression.cs.uid`，并更新 `.godot/` 缓存和编译产物。
- `README.md`：更新部署状态与下一步。
- `DEVLOG.md`：新增本条编号记录。

**删除**

- 未删除文件，未修改功能代码，未提交 Git。
