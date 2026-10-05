# SpiritualRealmWalker 开发日志

本文按时间记录项目的实际开发过程，包括任务目标、文件变动、故障原因和验证结果。项目当前用法与有效状态见 [README.md](README.md)，当前玩法方案见 [DESIGN.md](DESIGN.md)。

## 记录规范


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

### 13. 忽略本地小说原文

- 修改 `.gitignore`：添加 `/灵境行者.txt`，仅忽略项目根目录的小说资料。
- 验证：通过 `git check-ignore` 确认命中规则，小说不再出现在未跟踪文件列表中。
- 修改 `DEVLOG.md`：记录此次调整；未修改或删除小说原文，未创建 Git 提交。

## 2026-09-29

### 1. 重构基础牌及角色卡命名

**设计与代码**

- 将4张相同基础攻击调整为3张“体术”和1张“射击”：体术1费6伤害，射击1费7伤害，两者升级均增加3点伤害。
- 将4张“影护”改为4张“格挡”：1费获得5点格挡，升级增加3点。
- 初始牌组继续包含1张“夜游”和1张“噬灵”，总数保持10张。
- 将源码文件、类名、自动注册 ID 和本地化键同步重命名为 `BodyTechnique`、`Shooting`、`Block` 和 `CharacterCard`，不再保留中文名称与英文源码名不一致的过渡命名。

**文件变化**

- 新增 `Cards/BodyTechnique.cs`、`Cards/Shooting.cs`、`Cards/Block.cs` 及对应 Godot UID；删除被替代的 `Cards/NightStrike.cs`、`Cards/ShadowGuard.cs` 及其 UID。
- 新增 `Relics/CharacterCard.cs` 及 UID；删除被替代的 `Relics/NightToken.cs` 及其 UID。
- 修改中英文 `cards.json`、`relics.json`，同步新的模型 ID、名称和说明。
- 修改 `README.md`、`DESIGN.md`、`DEVLOG.md`，同步当前文件结构、牌组和旧存档限制。

**兼容性**

- 重命名会生成新的卡牌和遗物模型 ID，旧测试存档不再兼容；需要新开一局验证。

**验证**

- Release 编译成功：0警告、0错误。
- Godot 完成项目扫描并为新增的 `Shooting.cs` 生成 UID；扫描时无法写入用户级编辑器设置，但不影响项目文件生成和 C# 编译。
- 检查当前源码、README、DESIGN 和本地化目录，已经不存在 `NightStrike`、`ShadowGuard`、`NightToken` 及其旧本地化键。
- `git diff --check` 通过，仅提示现有 Windows 换行转换。
- 本次尚未部署或实机验证；奖励卡池仍没有 Common 卡，战斗结束奖励异常需在下一批奖励牌中解决。

**删除**

- 删除6个被替代的明确文件：`NightStrike.cs`、`NightStrike.cs.uid`、`ShadowGuard.cs`、`ShadowGuard.cs.uid`、`NightToken.cs`、`NightToken.cs.uid`。
- 没有批量删除目录或文件。

### 2. 建立自动部署约定并重新部署

- 修改 `README.md`：约定功能代码、配置或本地化变更完成后，默认执行编译、检查和部署；部署前检查游戏进程，纯文档修改不部署。
- 部署命令为 `dotnet build SpiritualRealmWalker.csproj -c Release -p:DeployMod=true`，构建目标会复制 DLL 和清单并调用 Godot 导出 PCK。
- 本次部署前确认游戏未运行，随后重新部署重构后的基础牌和角色卡。
- 部署结果：Release编译0警告、0错误，Godot PCK导出成功；部署 DLL 和 JSON 的 SHA256 分别与源码产物一致，PCK大小为11648字节。
- 覆盖游戏 Mod 目录中的 `SpiritualRealmWalker.dll`、`SpiritualRealmWalker.json` 和 `SpiritualRealmWalker.pck`；未删除文件，尚未提交 Git。

### 3. 确定奖励牌以道具为核心

- 明确普通卡牌奖励不使用夜游神随等级获得的职业技能；职业技能由角色成长系统提供。
- 奖励牌主要表现小说中的道具：主动道具对应攻击或技能牌，持续效果对应能力牌，一次性物品通常消耗，代价类和规则类道具同时表现收益、条件与代价。
- 长期被动道具仍可作为遗物，药剂类物品仍可作为药水，避免所有道具强行使用同一种载体。
- 修改 `DESIGN.md`，新增“奖励牌与道具”章节；修改 `DEVLOG.md` 记录本次设计决定。
- 本次只修改文档，没有修改功能代码、删除文件或重新部署。

### 4. 固定初始牌组排列顺序

- 原因：`RegisterCharacterStarterCard` 的数量只决定副本数；此前所有注册项的 `Order` 都为默认值0，实际顺序取决于程序集类型发现顺序，类名重构后顺序随之改变。
- 修改 `BodyTechnique.cs`、`Shooting.cs`、`Block.cs`、`NightTravel.cs`、`SpiritDevour.cs`，依次设置注册顺序0、1、2、3、4。
- 预期新局牌组顺序固定为：3张体术、1张射击、4张格挡、夜游、噬灵。
- Release编译成功：0警告、0错误。检查时游戏仍在运行，因此本次没有覆盖部署文件；关闭游戏后再自动部署并新开一局验证顺序。
- 未新增或删除文件，尚未提交 Git。
- 用户关闭游戏后重新执行部署：Release编译和Godot PCK导出成功，0警告、0错误；部署 DLL、JSON 与源产物校验一致，PCK大小11648字节。

### 5. 新增小说道具信息提取工具

**新增**

- `NOVEL_ITEMS.md`：用于保存小说道具资料的正式输出文件，创建后保持空白。
- `Tools/Extract-NovelItems.ps1`：识别以“【名称：”开头的连续属性块，支持备注一、备注二、使用形态等多个字段；同名道具保留信息最完整的一次，并按原文出现顺序生成三位编号。

**验证**

- 使用小说原文输出到一个明确的临时测试文件，识别135次格式化属性展示，去重后得到130件道具，编号连续。
- 抽查前三项为镇尸符、永不熄灭的蜡烛、红舞鞋，字段顺序和中文内容得到保留。
- 验证后仅删除该明确的临时测试文件；正式 `NOVEL_ITEMS.md` 未写入内容。

**修改与部署**

- 修改 `README.md`：增加文件用途、脚本命令、去重规则和覆盖提示。
- 本次没有修改 Mod 功能代码或本地化，因此没有重新编译部署，也没有提交 Git。

### 6. 生成小说道具资料

- 将空白资料文件 `NOVEL_ITEMS.md` 更名为 `ITEMS.md`，使文件名直接对应游戏语境中的道具总称 Item。
- 修改 `Tools/Extract-NovelItems.ps1`，将默认输出路径同步改为 `ITEMS.md`。
- 修改 `README.md`，同步文件结构、默认输出文件和覆盖提示。
- 运行提取脚本，将编号后的小说道具信息写入 `ITEMS.md`。
- 提取结果：从135次格式化属性展示中得到130件同名去重后的道具，文件大小61729字节，编号从001“镇尸符”连续至130“电子表”。
- 抽查红舞鞋条目，备注一、使用形态二和备注二均完整保留。
- 本次只修改资料、脚本和文档，没有修改 Mod 功能代码、删除小说原文或重新部署。

### 7. 保留道具信息的全部重复出现

- 修改 `Tools/Extract-NovelItems.ps1`，移除按名称选取最完整条目的去重逻辑。
- 每一次以“【名称：”开头的属性展示都按原文位置独立编号；同名、同内容、改造前后状态及逐步揭示的信息全部保留。
- 重新生成 `ITEMS.md`：共保留135条记录，编号从001连续至135。
- 修改 `README.md`，将脚本说明由“同名去重”更新为“保留全部出现次数”。
- 本次只修改提取脚本和文档，没有修改 Mod 功能代码、删除文件、重新编译或部署。

### 8. 实现首批3张普通道具奖励牌

**新增**

- `Cards/BloodthirstyBlade.cs`：嗜血之刃，1费造成6点不可格挡伤害；目标存活时给予2层中毒，由本牌伤害击杀时恢复3点生命；升级后伤害提高至8点。
- `Cards/SteadfastOrb.cs`：沉稳者宝珠，1费获得9点格挡并将原版“碎屑”放入弃牌堆；升级后获得12点格挡。
- `Cards/HeavenlyToadIncenseBurner.cs`：天蟾香炉，1费给予所有存活敌人3层中毒并给予使用者2层中毒；升级后对敌中毒提高至4层，自身中毒不变。

**修改**

- 修改中英文 `cards.json`，增加3张奖励牌的名称、说明和升级数值显示。
- 修改 `DESIGN.md`，记录三张牌的正式首版规则、原文对应关系和待实测项目。
- 修改 `README.md`，将三张牌加入当前功能和项目文件结构。

**实现与验证**

- 三张牌均注册到夜游神卡池，稀有度为普通，使普通战斗能够生成3个合法卡牌奖励候选。
- 嗜血之刃使用游戏原生不可格挡伤害属性；当前没有原生流血状态，暂用中毒表现持续掉血。
- 沉稳者宝珠直接生成游戏原有 `Debris`；天蟾香炉将游戏原有 `PoisonPower` 同时施加给敌人和使用者。
- 首次编译发现 `AttackCommand.DamageProps` 是只读属性，改为调用支持 `DamageVar` 的 `CreatureCmd.Damage`，保留卡牌来源、出牌上下文和击杀结果。
- Release编译和Godot PCK导出成功：0警告、0错误；Godot为3个新增源码文件生成对应 UID。
- 部署前确认游戏未运行；随后覆盖游戏 Mod 目录中的 DLL、JSON 和 PCK。部署 DLL、JSON 与源产物的 SHA256 均一致，PCK大小为14528字节。
- 本次没有删除文件，也没有提交 Git；玩家中毒、不可格挡伤害、碎屑生成和三选一奖励界面仍需新开一局实测。

### 9. 增加道具原文悬停提示及嗜血代价

**功能调整**

- 为嗜血之刃、沉稳者宝珠和天蟾香炉分别增加独立卡牌悬停提示，无需注册新的卡牌关键词。
- 悬停提示标题使用道具名称，正文依次显示“类型、功能、介绍、备注”；移除资料格式的外层 `【】`，保留字段名称与中文原文字句，并使用空行划分基础信息、介绍和备注。
- 嗜血之刃每次使用在主要牌效结算后失去2点生命，表现原文中刀刃索取主人鲜血的代价。
- 根据最新设计，将嗜血之刃基础伤害从6点提高至7点，升级后由8点同步提高至9点。

**修改**

- 修改 `BloodthirstyBlade.cs`、`SteadfastOrb.cs`、`HeavenlyToadIncenseBurner.cs`，通过 RitsuLib 动态变量悬停提示接口绑定各自资料。
- 修改中英文 `cards.json`，新增三组悬停标题与正文；中文使用小说原文，英文提供对应回退翻译。
- 修改 `DESIGN.md` 和 `README.md`，同步嗜血代价、最新伤害及道具悬停说明。

**验证**

- 中英文 `cards.json` 均通过 JSON 解析。
- Release编译和Godot PCK导出成功：0警告、0错误。
- 部署前确认游戏未运行；随后覆盖游戏 Mod 目录中的 DLL、JSON 和 PCK。部署 DLL、JSON 与源产物校验一致，PCK大小为17584字节。
- 本次没有新增或删除文件，也没有提交 Git；悬停提示的实际换行与尺寸、嗜血之刃扣血顺序仍需游戏内验证。

### 10. 统一嗜血之刃的攻击升级幅度

- 将嗜血之刃的升级伤害增量由2点调整为3点，与当前体术、射击等攻击牌的升级幅度保持一致。
- 嗜血之刃基础伤害仍为7点，升级后由9点改为10点；费用、中毒、击杀治疗和失去生命的效果不变。
- 修改 `BloodthirstyBlade.cs` 和 `DESIGN.md`，没有新增或删除文件。
- Release编译和Godot PCK导出成功：0警告、0错误；部署前确认游戏未运行。
- 已覆盖游戏 Mod 目录中的 DLL、JSON 和 PCK，部署 DLL、JSON 与源产物校验一致，PCK大小仍为17584字节；未提交 Git。

### 11. 移除道具悬停提示中的多余空行

- 根据游戏内验证结果，移除三张道具牌悬停提示中“功能”与“介绍”、“介绍”与“备注”之间的空白行。
- “类型、功能、介绍、备注”现在各自换行但连续排列，字段名称和原文内容保持不变。
- 同步修改中英文 `cards.json` 和 `DESIGN.md`；没有新增或删除文件。
- 中英文 JSON 解析通过；Release编译和Godot PCK导出成功，0警告、0错误。
- 部署前确认游戏未运行；已覆盖游戏 Mod 目录中的 DLL、JSON 和 PCK，DLL、JSON与源产物校验一致，PCK大小为17552字节；未提交 Git。

### 12. 实现第二批3张道具牌

**功能实现**

- 新增“永不熄灭的蜡烛”：0费普通技能牌，移除除易伤外的负面状态，再给予自身2层易伤并消耗；升级后自身易伤降为1层。
- 新增“红舞鞋”：2费罕见能力牌，打出时从“追杀”和“穿戴”两种形态中选择。
- “追杀”在每个玩家回合结束时对当前生命最低的敌人造成5点无视格挡伤害，每3个未来回合生成1张“共舞”；升级后伤害为8点。
- “穿戴”给予2点敏捷，接下来3个回合开始时各获得6点格挡，第3回合生成“共舞”，并在该回合结束时收回敏捷；升级后给予3点敏捷。
- “共舞”为1费可打出的状态牌，打出后消耗；若回合结束时仍在手牌中，角色受到5点可被格挡的伤害，随后该牌消耗。
- 新增“伏魔杵”：3费罕见攻击牌，先失去6点生命，存活时造成30点伤害并移除自身全部负面状态；升级后伤害为33点，卡牌不消耗。

**新增文件**

- 新增6个卡牌源码及其Godot UID：`EverBurningCandle`、`RedDanceShoes`、`RedDanceShoesPursuit`、`RedDanceShoesWear`、`DanceTogether`、`DemonSubduingPestle`。
- 新增2个能力源码及其Godot UID：`RedDanceShoesPursuitPower`、`RedDanceShoesWearPower`。
- 新增中英文 `powers.json`，提供红舞鞋两种持续效果的名称与说明。

**修改文件**

- 修改中英文 `cards.json`，加入第二批道具牌、两张形态选择牌和共舞的文本；3张正式道具牌均提供连续无空行的原文悬停提示。
- 修改 `DESIGN.md`，记录3张道具牌、两种红舞鞋形态及共舞的完整结算规则。
- 修改 `README.md`，将当前奖励池更新为6张牌，补充新增文件结构和实机验证项。

**验证与部署**

- 4个中英文卡牌、能力本地化 JSON 均通过解析；现有成长测试与双语检查共32项通过。
- Release编译成功：0警告、0错误；Godot扫描并为8个新增C#文件生成UID，PCK导出成功。
- 部署前确认游戏未运行；已覆盖游戏Mod目录中的DLL、JSON和PCK，DLL与JSON的SHA256分别与源产物一致，PCK大小为29120字节。
- 未删除文件，未创建Git提交。三张牌的选择界面、回合钩子、状态移除顺序和共舞惩罚仍需游戏内新开对局验证。

### 13. 修正红舞鞋能力说明的数值占位符

- 游戏内发现红舞鞋能力说明直接显示 `{Amount}` 和 `{Turns}`，没有替换为实际数值。
- 原因是能力的 `description` 用于静态说明，不会执行动态变量替换；原版能力将动态文本放在 `smartDescription` 中。
- 修改中英文 `powers.json`：`description` 使用确定的基础数值作为回退文本，新增 `smartDescription` 显示实时伤害、格挡和剩余回合数，并使用原版蓝色数值格式。
- 没有修改能力结算逻辑，没有新增或删除文件。
- 中英文能力JSON解析通过；Release编译成功，0警告、0错误。检查时游戏仍在运行，因此本次暂未覆盖部署文件，关闭游戏后再部署验证。

### 14. 修正红舞鞋穿戴形态的格挡时机

- 游戏内发现穿戴形态的格挡在敌人行动结束后、玩家新回合正式开始前出现，随后被新回合的格挡清除流程立即移除，实际无法抵挡伤害。
- 将格挡触发点从玩家回合开始前改为玩家回合结束时：打出红舞鞋的当前回合及接下来2个玩家回合结束时各获得6点格挡，共触发3次。
- 共舞仍在第3个未来回合开始时加入手牌；该回合结束时收回红舞鞋给予的敏捷。
- 修改穿戴能力代码、中英文卡牌及能力文本、`DESIGN.md` 和 `README.md`；没有新增或删除文件。
- 4个中英文卡牌、能力JSON解析通过；Release编译成功，0警告、0错误。随后确认游戏已经关闭并完成部署，DLL与JSON的SHA256分别与源产物一致，PCK大小为30224字节；第13项的能力数值说明修复也随本次一并部署。

### 15. 让红舞鞋在穿戴结束后返回手牌

- 穿戴形态结束时，在收回红舞鞋给予的敏捷之后，将红舞鞋重新加入手牌，使玩家可以再次选择穿戴或改为追杀。
- 返回的红舞鞋继承原牌的升级状态：基础版返回基础版，升级版返回升级版。
- 修改穿戴能力代码、中英文卡牌及能力文本、`DESIGN.md` 和 `README.md`；没有新增或删除文件。
- 4个相关中英文JSON解析通过；Release编译成功，0警告、0错误。部署前确认游戏未运行，随后完成部署；DLL与JSON的SHA256分别与源产物一致，PCK大小为30496字节。

### 16. 让红舞鞋追杀形态锁定目标并在目标死亡后返回

- 追杀形态不再自动攻击生命最低的敌人。选择追杀后，将一张0费、保留、消耗的临时“追杀”牌加入手牌，由玩家拖向一名敌人完成锁定。
- 追杀效果挂在被锁定的敌人身上，每个玩家回合结束时只对该目标造成无视格挡伤害，不会在目标之间转移。
- 被锁定目标死亡时，将与原牌升级状态相同的红舞鞋加入使用者手牌，可以再次选择形态和目标。
- 共舞仍按每3个玩家回合生成一次；修改追杀选择牌、追杀能力、红舞鞋主牌、中英文文本、`DESIGN.md` 和 `README.md`，没有新增或删除文件。
- 4个相关中英文JSON解析通过；Release编译成功，0警告、0错误。部署前确认游戏未运行并完成部署，DLL与JSON的SHA256分别与源产物一致，PCK大小为30752字节。
- 游戏内最终验收通过：第二批3张道具及红舞鞋两种形态、指定追杀、目标死亡返还、穿戴格挡、共舞和动态说明均未发现问题，作为当前6张道具牌的稳定版本提交Git。

## 2026-09-30

### 1. 实现第三批道具牌

- 灵体结晶：普通技能，0费获得2点太阴之力并消耗，升级获得保留。
- 大罗星盘：稀有能力，2费，从下一回合起在正常抽牌前查看顶部3张牌，选择1张入手，其余进入弃牌堆；升级查看4张，空牌堆跳过，不提前洗牌。
- 猫王音箱：罕见技能，1费选择鼓声或唢呐并消耗；鼓声获得2点力量并给予全体敌人1层虚弱，唢呐获得4点力量并在第三次玩家回合结束失去10点生命。升级两种音频力量分别为3/5。唢呐使用当回合计入，共3回合；多次使用独立计时，可被净化。
- 新增5个卡牌源码：`SpiritCrystal.cs`、`GreatLuoAstrolabe.cs`、`CatKingSpeaker.cs`、`CatKingSpeakerDrum.cs`、`CatKingSpeakerSuona.cs`；新增2个能力源码：`GreatLuoAstrolabePower.cs`、`CatKingSpeakerSuonaPower.cs`，Godot生成7个对应UID。
- 修改中英文卡牌和能力JSON，加入牌效、选择提示及原文悬停说明；修改README与DESIGN，同步奖励池9张及当前规则。本次未改写ITEMS中用户已有的制作状态标记。
- Release编译0警告、0错误；4个JSON解析及现有32项成长与双语检查通过。游戏关闭后完成部署，DLL和清单哈希一致，PCK为40576字节。
- 没有删除文件，没有提交Git；第三批待游戏内验证，能力图标与卡牌插图仍使用占位资源。

### 2. 验收第三批并保存9张道具牌稳定版本

- 用户确认第三批游戏内测试结束，未报告问题；据此将灵体结晶、大罗星盘和猫王音箱标记为已完成实机验收。
- 修改README和DESIGN的第三批验收状态；补齐ITEMS中大罗星盘的已制作标记，并保留用户已有的其他道具状态标记。
- 将第三批5个卡牌源码、2个能力源码、7个Godot UID、中英文卡牌与能力文本及开发文档纳入Git提交，保存当前9张道具牌的稳定版本。
- 本次仅修改文档状态并创建提交，不重新部署；没有新增或删除文件，小说原文继续被忽略。

### 3. 制作两件道具的四张风格样图

- 使用内置image_gen生成嗜血之刃、猫王音箱各一张中式志怪绘本与现代都市怪谈插图，供美术风格比较。
- 新增 `Art/Concepts/2026-09-30/` 下4张PNG及 `PROMPTS.md`，记录提示方向与生成方式。
- 图片尚未绑定游戏卡牌资源；本次未修改功能代码，未部署，未提交Git，没有删除文件。

### 4. 接入嗜血之刃的志怪版卡图

- 新增 `SpiritualRealmWalker/images/cards/bloodthirsty_blade.png`，复制志怪版源图用于第一次游戏内显示测试；本次保留原图构图，通过游戏自身卡图区域显示。
- 修改 `Cards/BloodthirstyBlade.cs`，通过RitsuLib的公开 `CustomPortraitPath` 接口绑定图片，普通与升级版共用。
- 修改 `export_presets.cfg`，排除 `Art/*` 风格对照源图；修改README说明当前卡图状态。
- Release编译0警告、0错误，Godot图片导入及项目缓存中的预览PCK导出成功。Godot自动生成5个PNG导入配置及被忽略的纹理缓存。
- 检查时游戏正在运行，暂未覆盖游戏部署文件，实际显示与裁切待游戏关闭后部署验收；未删除文件，未提交Git。

### 5. 部署嗜血之刃卡图并更新自动关闭约定

- 用户授权以后部署检测到游戏运行时直接关闭，无需手动关闭；本次停止SlayTheSpire2进程后重新部署。
- Release编译0警告、0错误，Godot导出成功；DLL及清单哈希与源产物一致，PCK为2469004字节。
- 导出包含嗜血之刃正式测试纹理，未包含Art目录下的风格对照图；实际游戏显示仍待验收。
- 修改README中的部署约定及DEVLOG；覆盖游戏Mod目录中的DLL、JSON和PCK。没有新增或删除文件，未提交Git。

### 6. 根据原文制作嗜血之刃手绘样稿

- 小段查阅小说首次外观描写及首次道具信息，确认银亮柳刃、总长四十厘米和血液喂刀表现。
- 新增 `Art/Concepts/2026-09-30/bloodthirsty-blade-handpainted-v2.png` 与 `BLADE_V2.md`，记录原文依据、完整提示词和待确认事项。
- 使用内置image_gen制作25:19横向样稿，以手绘色块、简洁背景和少量血迹比较新风格。握柄细节为美术补充，仍待用户确认。
- 未替换游戏卡图，未编译或部署，未提交Git，没有删除文件。

### 7. 部署嗜血之刃手绘样稿

- 将手绘v2样稿复制覆盖 `SpiritualRealmWalker/images/cards/bloodthirsty_blade.png`，保留原有概念图；卡牌源码绑定路径无需修改。
- 按授权关闭游戏，Godot重新导入纹理；新增v2概念图的PNG导入配置，更新被忽略的纹理缓存。
- Release编译及PCK导出成功，0警告、0错误；覆盖游戏Mod目录中的DLL、JSON和PCK。源卡图与样稿哈希一致，部署DLL与编译产物一致。
- 本次未删除文件，未提交Git；卡图实际显示待游戏内确认。

### 8. 整理绘图规范并制作嗜血之刃v3

- 新增 `Art/ART_GUIDELINES.md`，统一原文检索、250×190构图、手绘色块、焦点动势、背景配色及验收流程；README增加入口。
- 新增 `Art/Concepts/2026-09-30/bloodthirsty-blade-handpainted-v3.png` 和 `BLADE_V3.md`，记录原文依据、完整提示词与检查结果。
- 内置image_gen生成新样稿，增加弧形挥斩笔触。安全余量与细碎纹理仍待改进，未替换当前游戏资源。
- 本次只制作概念图和文档，未编译或部署，未提交Git，没有删除文件。

### 9. 修正嗜血之刃器型及遮挡余量

- 搜索柳刃与柳叶刀实物资料，区分历史兵器与同名日式厨刀；以小说短刀尺寸为准进行造型推断。
- 新增 `bloodthirsty-blade-handpainted-v4.png` 和 `BLADE_V4.md`，收窄刀身、降低倾角、扩大上下余量，取消不合理运动弧线。
- 修改 `Art/ART_GUIDELINES.md`，明确完整显示优先于主体占比、运动轨迹需符合实际、具体器型需查找实物依据。
- 本次未替换正式卡图，未编译或部署，未提交Git，没有删除文件；游戏显示待确认。

### 10. 恢复短刃造型并重新设计挥砍构图

- 根据用户反馈恢复v2/v3短刃与鲜红血迹，以v2图作为内置image_gen参考，重新安排刀柄左上、刀尖右下的挥砍构图。
- 新增 `bloodthirsty-blade-handpainted-v5.png` 与 `BLADE_V5.md`，记录完整提示词、用户造型选择和检查限制；更新绘图规范。
- 未替换游戏卡图，未编译或部署，未提交Git，没有删除文件。遮挡效果待游戏验收。

### 11. 部署嗜血之刃v5并列出旧稿清理范围

- 覆盖正式 `bloodthirsty_blade.png`，Godot重新导入纹理并生成v3/v4/v5概念图导入配置。
- 关闭游戏后编译部署；首次导出因Godot编辑器设置错误失败，重试成功，0警告、0错误，覆盖部署DLL、JSON与PCK。
- README同步v5卡图状态。用户要求清除旧稿，但此前明确禁止批量删除，因此未删除文件，交由用户手动清理概念图目录中的旧版本及对应说明、导入配置。
- 未提交Git，实际游戏显示待验收。

### 12. 更新删除授权规则并清理美术草稿

- 项目原先没有实体AGENTS.md；新增该文件，记录用户更新规则：明确要求或允许的范围内可以批量删除，操作前验证绝对路径与范围。
- 在 `Art/Concepts/2026-09-30` 内删除19个文件：嗜血之刃v2/v3/v4图片及各自.import（6个），都市/志怪图片及各自.import（4个），BLADE_V2/V3/V4.md（3个），旧v5.import（1个），猫王音箱都市/志怪图片及各自.import（4个），旧PROMPTS.md（1个）。
- 将保留的v5图片改名为 `bloodthirsty-blade.png`，说明改名为 `BLOODTHIRSTY_BLADE.md`；更新说明及README。旧开发日志保留历史文件名以记录实际操作。
- 正式游戏卡图及部署文件不变；本次未重新编译、部署或提交Git。未删除目录和Godot缓存。

### 13. 根据首次外观描写绘制猫王音箱

- 小段阅读小说首次出现附近内容，确认黑色金属复合外壳、四方盒子、扬声器、两个按钮和半掌大小。
- 新增 `Art/Concepts/2026-09-30/cat-king-speaker.png` 与 `CAT_KING_SPEAKER.md`，内置image_gen制作暖赭背景手绘样图，并记录完整提示词、出处和美术补充。
- 机身下缘及背景密度仍需验收。本次未替换游戏资源，未编译、部署或提交Git，没有删除文件。

### 14. 猫王音箱添加猫形图案

- 用户确认提示词后，以原图为编辑目标调用内置image_gen，新增 `cat-king-speaker-cat-emblem.png`，在机身左侧添加灰银色坐猫剪影，保留原稿。
- 更新 `CAT_KING_SPEAKER.md` 记录编辑提示词及结果；更新绘图规范，要求以后每次绘图前先展示提示词，确认后执行。
- 未修改游戏资源，未编译或部署，未提交Git，没有删除文件。

### 15. 规范猫王音箱文件名并部署

- 单独删除无猫图案的旧 `Art/Concepts/2026-09-30/cat-king-speaker.png`，将带猫图案的 `cat-king-speaker-cat-emblem.png` 改名为 `cat-king-speaker.png`。
- 新增正式资源 `SpiritualRealmWalker/images/cards/cat_king_speaker.png`；修改 `Cards/CatKingSpeaker.cs` 绑定卡图，普通及升级版共用。
- 修改README及CAT_KING_SPEAKER.md，记录当前文件名和接入状态；Godot生成两张新卡图的.import配置及被忽略的缓存。
- Release编译与PCK导出成功，0警告、0错误；部署DLL、JSON、PCK，图片与概念稿哈希一致，部署DLL与编译产物一致。
- 未提交Git，实际显示待游戏内验收。导入时编辑器仍引用已删除的旧草稿路径，出现路径提示，不影响最终编译导出。

### 16. 绘制沉稳者宝珠与天蟾香炉样稿

- 根据用户确认提示词分别调用内置image_gen，新增 `steadfast-orb.png`、`heavenly-toad-incense-burner.png` 以及各自同名大写英文说明MD，位于今日概念图目录。
- 说明记录原文依据、完整提示词及偏差：宝珠出现额外裂纹和碎石，香炉装饰偏多、主体偏大，三足结构待确认。
- 未接入游戏，未编译或部署，未提交Git，没有删除文件；后续修图仍须先确认提示词。

### 17. 修正宝珠表面并添加香炉紫色毒气

- 用户确认编辑提示词后，分别使用内置image_gen编辑两张原稿。
- 新增 `steadfast-orb-smooth.png`，去除裂纹与碎石、表现温润完整的土黄色宝珠；新增 `heavenly-toad-incense-burner-purple-mist.png`，保留香炉并增加少量半透明紫色烟气。
- 更新两份道具美术说明，记录编辑提示词和结果，区分原文依据与用户指定美术表现。
- 保留旧稿，未接入游戏，未编译或部署，未提交Git，没有删除文件。

### 18. 宝珠与香炉定稿接入并部署

- 用户确认定稿并授权后续自动清理、规范命名和部署；写入Art/ART_GUIDELINES.md，绘图前仍须确认提示词。
- 分别单独删除裂纹版steadfast-orb.png、无紫雾版heavenly-toad-incense-burner.png；将修改稿改为上述标准名称。
- 新增正式卡图steadfast_orb.png、heavenly_toad_incense_burner.png，修改Cards/SteadfastOrb.cs和Cards/HeavenlyToadIncenseBurner.cs绑定，普通与升级版共用。
- 更新README、两份美术说明与DEVLOG；Godot生成4个图片.import及被忽略的纹理缓存。Release编译及PCK导出成功，0警告、0错误，部署DLL、JSON、PCK；两张图片与概念稿及部署DLL与编译产物哈希一致。
- 未提交Git，卡框遮挡与实际显示待游戏内验收。

## 2026-10-04

### 1. 排查卡牌费用图标占位

- 检查Characters/NightWandererCardPool.cs：EnergyColorName为NightWanderer，BigEnergyIconPath与TextEnergyIconPath均为null；遗物池和药水池也使用相同名称且未提供图标。
- 当前游戏日志确认缺失 `card/energy_nightwanderer`，请求路径为 `res://images/atlases/ui_atlas.sprites/card/energy_nightwanderer.tres`；项目图片目录没有对应能量图标。截图红色NO PE与该费用位置缺失资源相符。
- 本地RitsuLib 0.6.2 XML说明确认BigEnergyIconPath用于覆盖EnergyIconHelper.GetPath返回的大图标路径；TextEnergyIconPath用于富文本中的小能量图标，自定义能量名称不会自动生成纹理。
- 结论：费用数值本身可见，问题在自定义能量图标未配置。后续可显式复用原版图标或制作并绑定专属图标；本次仅排查，未修改功能源码或资源，未部署、未提交Git。

### 2. 核实原版能量图标尺寸

- 联网查阅人物教程，确认BigEnergyIconPath要求74×74、TextEnergyIconPath要求24×24。
- 只读解析本机SlayTheSpire2.pck资源目录和纹理头部，确认大图标AtlasTexture区域及边距、小图标CTEX宽高与教程一致。
- 更新Art/ART_GUIDELINES.md记录尺寸、用途及来源；未提取或修改游戏资源，未部署、未提交Git，没有删除文件。

### 3. 输出三辰能量图标PNG

- 用户确认输出后，使用内置image_gen分别生成大版、小版，再通过Godot缩放为74×74与24×24。
- 新增 `Art/Icons/2026-10-04/energy_big.png`、`energy_text.png`、`ENERGY_ICONS.md`；新增被忽略的 `.godot/export_energy_icons.gd` 用于确定尺寸导出。
- 检查RGBA透明通道及最终尺寸通过；大版装饰偏繁复，小版星形未完全符合圆星点方案，说明中记录美术偏差，未标记定稿。
- 首次受限环境Godot启动崩溃，独立目录重试成功。本次未修改功能代码，未部署、未提交Git，没有删除文件。

### 4. 核对太阴、星辰与太阳的小说视觉描写

- 按用户反馈小段查阅黑月、星官晋升、星盘与日游神晋升段落，确认太阴黑雾/黑月，星辰璀璨星光及星盘银色呈现，太阳印记红色外焰与鎏金圆核。
- 更新ENERGY_ICONS.md，记录原文行号、第一版配色与卡通质感问题及新的庄严天象印记方向；银白星光方案明确为取自星盘呈现的美术推断。
- 未重新生成图片，等待新提示词确认；未部署、未提交Git，没有删除文件。

### 5. 依据小说重新绘制三辰图标

- 用户确认重绘后，内置image_gen分别制作黑月、银白星辰、鎏金圆日与暗红外焰的新大/小图标。
- 新增 `Art/Icons/2026-10-04/energy_big_revised.png`、`energy_text_revised.png`，通过被忽略的 `.godot/export_revised_energy_icons.gd` 导出74×74和24×24尺寸；RGBA透明通道检查通过。
- 更新ENERGY_ICONS.md记录完整提示词和实际偏差：大版尖角与外沿装饰仍偏多，小版三星为三条连线。尚未定稿，保留旧版，未部署、未提交Git，没有删除文件。

### 6. 统一费用图标与文本小图标

- 按用户要求，文本小图标不再独立绘制，直接将 `energy_big_revised.png` 的74×74图案通过Godot Lanczos缩放为24×24，覆盖 `energy_text_revised.png`，保持相同构图、配色和纹样。
- 修改 `.godot/export_revised_energy_icons.gd`，使小图始终读取大图生成；更新 `Art/ART_GUIDELINES.md` 与 `Art/Icons/2026-10-04/ENERGY_ICONS.md`，停用单独生成小图的规则，旧提示词作为历史保留。
- PNG头部检查确认74×74与24×24均为RGBA，Godot检测透明通道通过，并查看最终小图。Godot另有根证书读取及沙盒内编辑器设置保存提示，不影响两张PNG成功保存。本次未新增或删除文件，未绑定游戏资源、未部署、未提交Git。

### 7. 三辰能量图标定稿、接入与部署

- 用户确认定稿，依照此前授权自动清理旧稿、规范命名并接入。删除前核对绝对路径，每次仅删除一个明确文件：初版 `Art/Icons/2026-10-04/energy_big.png`、`energy_text.png` 和被忽略的 `.godot/export_revised_energy_icons.gd`。
- 将新版 `energy_big_revised.png`、`energy_text_revised.png` 分别更名为 `energy_big.png`、`energy_text.png`；新增正式资源 `SpiritualRealmWalker/images/ui/energy_big.png`、`energy_text.png`，Godot自动生成两张正式资源及两张概念资源的 `.import` 和忽略的纹理缓存。
- 新增 `Characters/ThreeLuminariesEnergyIcons.cs`，Godot自动生成其 `.cs.uid`，集中管理太阴、星辰、太阳共用的两条图标路径；修改 `NightWandererCardPool.cs`、`NightWandererRelicPool.cs`、`NightWandererPotionPool.cs`，将原先空图标路径绑定为正式资源。不改能量名称和机制。
- 修改被忽略的 `.godot/export_energy_icons.gd` 为读取定稿费用图标，缩小生成24×24文本图标并同步正式资源；新增忽略的 `.godot/verify_energy_pack.gd` 用于本次部署资源加载检查。更新 `README.md`、图标说明和本日志。
- Godot导入成功；编辑器曾尝试定位已删除的早期刀图路径，属于旧编辑器布局提示。Release编译、PCK导出及部署成功，0警告、0错误。部署前未发现游戏在运行，未关闭任何进程。
- 独立挂载部署PCK，两个正式资源路径均能加载为74×74与24×24纹理；概念/正式PNG、编译/部署DLL及源/部署清单的SHA256分别一致。受限环境资源检查另有证书及编辑器设置保存提示，不影响纹理加载。游戏内费用数字叠加和文本图标显示待用户验收。本次未提交Git。

### 8. 灵体结晶改为原版能量图标描述

- 只读解析本机原版PCK中的中英文卡牌文本，参考肾上腺素（ADRENALINE）、放血（BLOODLETTING）等卡牌的 `{Energy:energyIcons()}` 格式；没有修改或导出原版文件。
- 修改 `Cards/SpiritCrystal.cs`，新增 `EnergyVar(2)`，回能效果从该变量读取数值，保持描述与效果一致；0费、消耗、升级获得保留和原文悬停资料均保持原方案。
- 修改 `SpiritualRealmWalker/localization/zhs/cards.json` 与 `eng/cards.json` 中灵体结晶的 `description` 和 `smartDescription`：中文为 `获得{Energy:energyIcons()}。`，英文为 `Gain {Energy:energyIcons()}.`。按原版格式以两枚三辰文本图标显示，不写力量名称。
- 更新 `DESIGN.md` 的当前图标状态及灵体结晶显示约定，更新 `README.md` 和本日志。本次没有新增或删除项目文件，未修改其他卡牌文本。
- Release编译与部署成功，0警告、0错误；双语卡牌JSON解析及键一致性检查通过，部署DLL的SHA256与编译产物一致，Git差异空白检查通过。部署前未发现游戏运行。卡面实际图标排版仍待游戏内验收，未提交Git。

## 2026-10-05

### 1. 对齐三辰费用图标中的数字

- 用户截图中费用数字偏离图标中央圆面。只读核对本机原版PCK内 `scenes/cards/card.tscn`：EnergyIcon为64×64显示控件，EnergyLabel垂直边距-26/30，布局中心偏下2像素；结合字形度量和当前图标圆面，将本Mod费用标签向上校正4个显示像素。
- 新增 `Patches/EnergyCostLabelAlignmentPatch.cs`，在 `NCard.UpdateEnergyCostVisuals` 后仅对夜游神卡池调整费用标签上下边距，原-26/30变为-30/26；保存基准防止重复刷新累加偏移，节点转为其他卡池时恢复。Godot自动生成其 `.cs.uid`。
- 修改 `SpiritualRealmWalker.csproj`，引用游戏现有 `0Harmony.dll` 且不复制该库；修改 `ModEntry.cs`，注册本Mod的Harmony补丁。没有下载新依赖，没有修改游戏原版资源，也没有改动两张定稿PNG。
- 更新 `README.md`、`Art/Icons/2026-10-04/ENERGY_ICONS.md` 与本日志，记录修正范围及待验收状态。新增被Git忽略的 `.godot/inspect_energy_layout.gd`，只用于读取原版字体度量；首次函数名不匹配，修正后成功读取0/1/2/3/X的度量，未生成新图或修改图片。本次没有删除文件。
- Release编译、PCK导出及部署成功，0警告、0错误；部署DLL与编译产物的SHA256一致，Git差异空白检查通过。
- 以无窗口模式短暂启动游戏验证初始化，不进入对局。首次直接启动缺少Steam AppID；只读本机安装清单确认2868840后，使用临时进程环境变量重试，游戏正常加载DLL/PCK，日志确认本Mod初始化成功且未报告补丁注册异常，退出码0。无窗口退出存在引擎资源清理提示及既有占位遗物警告，不能替代视觉验收。游戏已自动退出。
- 4像素修正为根据截图和布局作出的初次对齐，最终卡面位置仍待游戏内确认；未提交Git。

### 2. 缩小费用数字并协调图标配色

- 用户实测反馈数字仍遮挡下方太阳，且普通费用颜色不协调。保留向上4像素修正，将字号上限由32调整为26（约缩小19%），同步MegaLabel自动字号范围，避免刷新后恢复为大字。
- 修改 `Patches/EnergyCostLabelAlignmentPatch.cs`，普通浅色费用改为暖象牙白 `#f1deb7`，使用2像素深棕描边 `#2b2115`；保留原版减费绿色、增费红色及禁用灰色。
- 同时处理 `NCard.UpdateEnergyCostVisuals` 和 `UpdateEnergyCostColor`，覆盖单独刷新颜色的情况。用弱引用表保存标签原位置、字号范围及主题覆盖，重复刷新不累加偏移，节点转为其他卡池时恢复原样式。
- 更新 `README.md`、`Art/ART_GUIDELINES.md`、`Art/Icons/2026-10-04/ENERGY_ICONS.md` 和本日志。本次没有新增或删除文件，两张定稿PNG保持不变，未下载依赖。
- 按已有授权关闭运行中的游戏，Release编译及部署成功，0警告、0错误；部署DLL的SHA256与编译产物一致，Git差异空白检查通过。
- 无窗口短暂启动游戏，Mod初始化成功且未报告补丁注册异常，进程自动退出、退出码0，没有进入对局。数字缩小、普通费用配色和太阳留白的最终视觉效果，以及战斗中减费/增费颜色，仍待游戏内验收；未提交Git。

### 3. 轻微加粗费用数字字形

- 用户参考其他Mod卡面，希望费用数字稍粗。保留26字号、向上4像素位置、2像素深棕描边和暖象牙白配色，在原版粗体基础上轻微增加字形厚度。
- 修改 `Patches/EnergyCostLabelAlignmentPatch.cs`，复制原字体变体并将 `VariationEmbolden` 增加0.35；按原字体缓存独立变体，不修改共享字体、不在重复刷新时累加字重。标签转为其他卡池时恢复原字体覆盖。
- 更新 `README.md`、`Art/ART_GUIDELINES.md`、`Art/Icons/2026-10-04/ENERGY_ICONS.md` 和本日志；修改被Git忽略的 `.godot/inspect_energy_layout.gd`，增加字体变体度量检查。本次未新增或删除文件，未改图片，未下载依赖。
- Release编译及部署成功，0警告、0错误，部署DLL与编译产物SHA256一致。Godot只读加载原版粗体，确认原始加粗值仍为0、独立变体约0.35，并成功计算26字号下0123X字形度量；受限环境另有证书/编辑器设置保存提示，不影响度量检查。
- 部署前未发现游戏运行，本次没有重复启动游戏；实际粗细和太阳留白效果待用户实测。未提交Git。

### 4. 修复字重被覆盖，并增加棕黑数字阴影

- 用户截图反馈加粗仍不明显，参考卡牌的数字具有更明显边缘阴影。只读检查原版MegaLabel方法IL，发现 `RefreshFont()` 调用 `ApplyLocaleFontSubstitution`：此前先覆盖加粗字体、再刷新字体的顺序会使独立字重被覆盖。此前仅度量变体，未验证其在最终标签上的保留，这是上次检查的限制。
- 修改 `Patches/EnergyCostLabelAlignmentPatch.cs`，先刷新本地化字体，再应用独立加粗字体；`VariationEmbolden`由0.35调整为0.65，保持26字号和向上4像素位置。
- 普通费用仍为暖象牙白；描边调整为3像素棕黑 `#1b1711`，增加棕黑短阴影 `#100e0bdd`（右1/下2像素，阴影描边2像素）。保存并恢复原阴影设置，避免节点复用影响其他卡池；费用增减及禁用文字颜色保留。
- 更新 `README.md`、`Art/ART_GUIDELINES.md`、`Art/Icons/2026-10-04/ENERGY_ICONS.md` 和本日志；本地忽略的字体度量脚本同步检查0.65变体。本次没有新增或删除文件，没有修改PNG。
- Release编译、导出及部署成功，0警告、0错误，部署DLL哈希与编译产物一致；Godot成功计算0.65变体的26字号字形度量，原始字体加粗值仍为0。受限环境有既有证书/编辑器设置保存提示，不影响度量。
- 部署前未发现游戏运行。没有重复启动游戏，最终阴影、粗细与太阳留白仍待游戏内实测；未提交Git。

### 5. 排查数字2/3的黑色针孔

- 用户截图反馈费用数字2/3内部有小黑点。核对本机GodotSharp说明：人工加粗可能导致轮廓自相交，使MSDF字体渲染异常；Godot只读检查确认原版Kreon费用字体启用MSDF。此原因与截图相符，属于有依据的诊断，尚未通过游戏内对比最终证实。
- 修改 `Patches/EnergyCostLabelAlignmentPatch.cs`，逐层复制费用字体、基础字体及回退字体，仅在独立FontFile副本关闭 `MultichannelSignedDistanceField`，改用普通光栅化；保留0.65字重、26字号、当前位置及棕黑描边/阴影，不修改共享字体和其他卡池。
- 修改被Git忽略的 `.godot/inspect_energy_layout.gd`，验证原字体MSDF仍为true、副本为false，原始加粗值仍为0，0.65加粗副本的26字号0123X度量有效。受限环境既有证书及编辑器设置保存提示未影响度量。
- 更新 `README.md`、`Art/ART_GUIDELINES.md`、`Art/Icons/2026-10-04/ENERGY_ICONS.md` 和本日志。没有新增或删除文件，没有修改PNG。
- 按既有授权关闭运行中的游戏，Release编译、导出及部署成功，0警告、0错误。最终黑点是否消失及缩放清晰度仍待游戏内验收；未提交Git。

### 6. 提交卡图、三辰能量图标及显示修正

- 用户明确要求提交Git，本次保存当前完整工作状态：四张道具定稿卡图及绑定、三辰费用/文本图标、费用数字排版与字体渲染修正、灵体结晶图标描述，以及对应文档、导出配置和项目操作规则。
- 提交前核对Git改动和美术文件范围，确认小说 `灵境行者.txt`、`.godot/`缓存与本地检查脚本仍被忽略；不将它们纳入提交。
- 本次仅追加本日志并执行Git暂存/提交，没有生成新美术、删除文件或修改功能；沿用最新已通过的Release编译及部署结果，不重复构建或关闭游戏。
- 费用字重/阴影已获用户基本认可；数字2/3黑点的最终修正仍保留“待游戏内验收”状态，不把提交等同于实测完成。本次只提交到本地仓库，不推送远端。

### 7. 制作三辰共用卡身与边框

- 用户要求先制作卡身和边框。采用深靛蓝正文区、蓝灰金属外沿及细暗金线，呼应太阴、星辰、太阳共用费用图标；保留原版稀有度标题带，暂不添加文字区底纹。
- 新增 `Characters/ThreeLuminariesCardStyle.cs`，加载并缓存两种材质；修改 `Characters/NightWandererCardPool.cs`，通过RitsuLib的 `PoolFrameMaterial` 绑定卡身。新增 `Patches/CardPortraitBorderStylePatch.cs`，在卡牌Reload/UpdateVisuals后设置独立插图边框材质，仅处理夜游神卡池，节点复用至其他卡池时恢复原材质。
- 新增 `SpiritualRealmWalker/shaders/three_luminaries_card_frame.gdshader`、`three_luminaries_portrait_border.gdshader`，以及 `SpiritualRealmWalker/materials/` 下同名两份 `.tres`。分别重新配色卡身和插图边框，保留原版纹理、透明区域及节点调制。Godot自动生成两份C#和两份shader对应的 `.uid`。
- 新增 `Art/CARD_STYLE.md`，记录统一视觉方向、颜色参数、文件用途和验收范围；修改 `README.md`、`Art/ART_GUIDELINES.md`，追加本日志。没有调用绘图工具，没有新增PNG正式美术，也没有删除文件或修改卡牌机制、费用图标。
- 新增被Git忽略的 `.godot/inspect_card_frame.gd` 与 `.godot/verify_card_style.gd`，分别只读提取原版卡框参考、独立挂载部署PCK并渲染卡身；本地生成 `original_frame_reference.png`、`card_style_preview.png` 及检查输出日志。初次预览因TextureRect最小尺寸导致裁切、主窗口隐藏API提示错误；调整属性顺序并移除该API调用后重新渲染通过，无shader错误，300×422预览正文取样为不透明深蓝。预览不包含完整游戏卡牌节点，不能替代完整视觉验收。
- Godot导入、Release编译、PCK导出及部署通过，0警告、0错误；导入期间有既有编辑器布局引用旧刀图的提示。部署前未发现游戏运行，无需关闭。编译与部署DLL的SHA256一致。
- 使用临时Steam AppID环境变量无窗口短暂启动游戏，日志确认Mod初始化成功，退出码0，没有进入对局。长短描述、三类卡牌的完整外观及节点复用恢复仍待游戏内实测。本次未提交Git。

### 8. 根据实测截图重新设计卡身与边框

- 用户认为首版接近原版且缺少美感，提供一张本Mod截图及三张参考图。分析后，首版厚灰标题带、厚金属框及正文内凹结构仍占据视觉，单纯配色不足以建立三辰主题。
- 修改 `Art/CARD_STYLE.md`，追加“三辰星仪”新版提案及完整待确认提示词：墨蓝至孔雀青卡身、暗金窄边、深色镶金标题带与类型牌、蓝黑正文区、统一低对比日月星底纹。首版说明保留为当前部署状态，新版明确标为尚未制作。
- 新版须按用户既有要求先确认绘图提示词，再生成概念图。当前未调用绘图工具、未生成或删除图片，未修改代码、材质和游戏部署文件，也未提交Git。此次为文档调整，不重复构建或关闭游戏。

### 9. 绘制三辰卡面概念样图

- 用户确认上一步提示词并要求执行。使用内置imagegen，以当前天蟾香炉截图为编辑目标，定稿香炉插图与费用图标为参考，生成墨蓝孔雀青、窄金边、深色镶金标题与三辰正文底纹的完整卡面概念图。
- 新增 `Art/CardStyles/2026-10-05/three-luminaries-card-concept.png`（1060×1484）；新增同目录 `THREE_LUMINARIES_CARD_CONCEPT.md`，保存实际调用提示词、输入角色、用途及初步检查；修改 `Art/CARD_STYLE.md`，状态改为已生成样图、待定稿，添加样图与说明入口；追加本日志。
- 核对PNG尺寸，源生成文件与项目副本SHA256一致。视觉检查确认中文标题、类型、费用和两行正文正确，正文与底纹能够辨认；生成图改变了费用徽记、部分原画细节及图文比例，因此该图仅用于整体风格评审，正式接入沿用既有费用PNG和香炉卡图，并按游戏节点拆分适配。
- 尚未获样图定稿指示，当前没有删除旧稿、修改运行时代码或材质、关闭游戏、编译部署或提交Git。当前游戏仍使用第一版卡身；本次新文件位于排除导出的Art目录。

### 10. 将三辰样式统一接入全部自定义卡牌

- 用户要求部署，并明确本Mod全部牌均使用新版。以已确认的概念图为依据，用原生Godot材质重建墨蓝孔雀青卡身、古金窄线、深色标题与类型牌、低对比三辰圆印；费用图标、数字、插图及文字仍独立显示，不将整张样图绑定到天蟾香炉或其他单牌。
- 覆盖核对：19类均注册到 `NightWandererCardPool`，包括5初始、9奖励、4选择衍生及共舞；攻击5/技能11/能力2/状态1。普通和升级版共用，后续同池新牌自动沿用；原版碎屑、晕眩保留各自原版卡池样式。
- 修改 `Characters/ThreeLuminariesCardStyle.cs`，新增标题和类型牌材质入口，缓存普通/罕见/稀有三档标题色带；修改 `Patches/CardPortraitBorderStylePatch.cs`，处理Reload、UpdateVisuals、UpdateTypePlaque、UpdateTypePlaqueSizeAndPosition四个入口，统一应用独立部件并保存/还原原材质及标签设置，保留升级绿色。修改 `Characters/NightWandererCardPool.cs` 的当前样式说明，卡身继续由PoolFrameMaterial全池绑定。
- 改写 `SpiritualRealmWalker/shaders/three_luminaries_card_frame.gdshader`、`three_luminaries_portrait_border.gdshader`，重建色面与线纹，避免继续沿用旧灰框分区；底纹强度调低至0.17。新增 `three_luminaries_banner.gdshader`、`three_luminaries_type_plaque.gdshader` 及对应两份 `materials/*.tres`；Godot生成两份新shader的 `.uid`。原有两份材质资源路径不变。
- 核对本机游戏IL发现类型牌宽度会在延迟更新中设为 `max(文字宽度+17,61)`，因此为每个类型牌缓存独立材质副本，并在尺寸更新后设置element_size，避免英语等长类型名称的金边偏位；不修改共享模板尺寸。新增入口后再次编译部署并复核初始化。
- 新增 `Art/CardStyles/2026-10-05/three-luminaries-runtime-preview.png`（1360×510），Godot自动生成其 `.png.import`；本轮导入同时生成先前概念图的 `.png.import`。更新 `README.md`、`Art/ART_GUIDELINES.md`、`Art/CARD_STYLE.md`、`THREE_LUMINARIES_CARD_CONCEPT.md` 及本日志，记录范围、参数、文件用途与检查限制。
- 新增被Git忽略的 `.godot/inspect_native_ui.gd`、`.godot/inspect_card_assets.gd`、`.godot/verify_full_card_style.gd`，只读核对原版布局/字体、挂载部署PCK并组合渲染，生成预览与检查日志。首次受限启动无法写用户日志，授权环境重试成功；导入仍有既有编辑器布局引用已删除旧刀图的提示。原版游戏文件未修改。
- Godot导入、GPU材质渲染、Release编译、PCK导出及部署通过，0警告、0错误；检查三种牌型、三档稀有度与长短正文，无shader编译错误。无窗口短暂启动游戏验证，初始化和19类注册成功，进程自动退出；DLL源与部署SHA256一致。部署前未发现游戏运行，无需关闭。
- 当前预览按原版控件位置组合，不是完整NCard游戏截图；实际对局、升级、选择牌及节点复用外观仍待游戏内验收。本次没有删除文件、调用新的绘图或提交Git。
- 最终无窗口检查退出码0、注册数量19。日志另有Loadout模组 `NLoadoutPanelButton.UpdateRainbowColor` 在dummy渲染器中触发纹理空参数提示，以及无窗口退出的RID清理提示；已核对调用栈，不来自本次卡面补丁。没有将无窗口检查视为完整游戏视觉验收。

### 11. 统一中文描述数字前后的连续排版

- 用户要求数字两侧不留空格。检查发现 `SpiritualRealmWalker/localization/zhs/cards.json` 当前工作区已清理这些空格：例如“造成{Damage:diff()}点伤害。”、“给予所有敌人{EnemyPoison:diff()}层中毒。”；保留该已有修改，没有重复重写文件或改动卡牌数值。
- 检查19类卡牌的description与smartDescription共38条，均无数字或动态变量两侧空格；同时检索其他中文本地化文件，未发现该类空格。英文排版及能量图标表达式保持不变。
- 修改 `Art/CARD_STYLE.md`，记录后续中文数值连续排版规则；追加本日志。本次没有新增或删除项目文件，没有修改代码及美术。
- 按既有授权关闭运行中的游戏，Release编译、PCK导出和部署成功，0警告、0错误。只读解析部署PCK，中文卡牌文本的全部键和值与源码一致；没有重复启动游戏或提交Git。

### 12. 用整圈插图框突出罕见与稀有

- 用户实测认可卡身，但反馈仅标题顶部色条不足以区分稀有度，要求包裹插图的整个边框采用对应颜色。保持卡身、星仪底纹和费用图标，罕见整圈插图框改为青色 `#73d5df`，稀有改为金色 `#f2bd65`；类型小牌同步着色，亮底使用深墨字，普通/基础/衍生/状态仍使用原有深色古金框和暖白类型字。
- 修改 `Characters/ThreeLuminariesCardStyle.cs`，按普通/罕见/稀有缓存插图框材质，增加统一ConfigureRarity接口；修改 `Patches/CardPortraitBorderStylePatch.cs`，每次刷新同时设置框与类型牌颜色，保留每节点宽度参数、标题升级色和转其他卡池恢复逻辑，防止复用时串色。恢复逻辑识别两种类型字色，标题字体颜色始终不修改或恢复。
- 修改 `SpiritualRealmWalker/shaders/three_luminaries_portrait_border.gdshader`、`three_luminaries_type_plaque.gdshader`，增加rarity_color/rarity_strength参数，在原alpha区域内对整个实体框和小牌着色，保留轻微材质明暗和透明插图窗口。不改牌型形状、数值、卡图或中文描述。
- 更新 `README.md`、`Art/CARD_STYLE.md` 和本日志；重新生成并覆盖已有 `Art/CardStyles/2026-10-05/three-luminaries-runtime-preview.png`。修改被Git忽略的 `.godot/verify_full_card_style.gd`，同步稀有度颜色参数与前次连续数字排版，更新本地预览及检查日志。本次没有新增或删除项目文件，没有调用绘图工具或提交Git。
- 按既有授权关闭运行中的游戏；Release编译、PCK导出部署成功，0警告、0错误。独立GPU加载部署PCK并渲染，确认普通保持原样、罕见青框、稀有金框及同色类型牌，无shader错误；编译和部署DLL的SHA256一致，Git差异格式检查通过。
- 沿用当前四个Harmony入口，未重复启动游戏；预览按游戏控件组合，不代替完整NCard对局测试。实际游戏中红舞鞋、大罗星盘及升级/选择牌的外观仍待用户验收。

### 13. 修正类型文字重影并统一顶部稀有度配色

- 用户实测反馈：罕见/稀有类型文字出现重影，青色与金色略浅，顶部标题纹饰未随插图框完整着色。核对发现深墨类型字仍叠加2像素描边、右下偏移阴影及阴影描边，小尺寸笔画因此重叠。
- 修改 `Patches/CardPortraitBorderStylePatch.cs`：罕见/稀有类型字取消描边，普通类型字改为1像素描边；全部类型字取消阴影、阴影偏移和阴影描边，恢复逻辑同步识别透明类型阴影。标题继续保留原有4像素描边和短阴影，标题升级绿色仍由游戏管理。
- 修改 `Characters/ThreeLuminariesCardStyle.cs`：罕见主色由 `#73d5df` 加深为 `#4eb7c6`，稀有由 `#f2bd65` 加深为 `#dda74f`；插图框、类型牌及标题共用ConfigureRarity的颜色。新增完整标题着色参数，普通仍沿用原窄色带。
- 修改 `SpiritualRealmWalker/shaders/three_luminaries_banner.gdshader`、`three_luminaries_portrait_border.gdshader`、`three_luminaries_type_plaque.gdshader`：罕见/稀有整个顶部标题带及两侧卷尾同步青/金配色，将浅色边缘高光混合降至0.14，避免配色显得过浅；保留原alpha轮廓、插图窗口和轻微材质明暗。
- 更新 `README.md`、`Art/CARD_STYLE.md` 及本日志；覆盖已有 `Art/CardStyles/2026-10-05/three-luminaries-runtime-preview.png`（1360×510）。同步被Git忽略的 `.godot/verify_full_card_style.gd`，让稀有度、类型字和标题描边/阴影参数与代码一致，更新本地预览和检查日志。没有新增或删除项目文件，没有调用绘图工具或修改卡牌机制。
- 执行自动Release编译、PCK导出和部署，0警告、0错误。独立GPU挂载部署资源，四种材质加载和渲染成功，退出码0、无shader错误；编译与部署DLL的SHA256一致，Git差异格式检查通过。只读审查确认bool参数、普通配色、升级绿色及节点复用恢复处理一致。
- 当前预览按原版控件组合，不能替代完整NCard与实际对局显示；本次没有重复启动游戏或提交Git。最终游戏内的字形和配色仍待用户验收。

### 14. 对齐参考图的原版稀有度材质与标题、类型文字

- 用户继续反馈青色/金色与参考Mod不同，标题和类型字与普通牌的观感不一致。只读采样参考图并核对本机游戏PCK、NCard与MegaLabel的DLL逻辑，确认参考色正是原版稀有度材质；不同部件的明暗、折面来自各自纹理，不能只用单一hex平涂替代。
- 原版 `card_banner_uncommon_mat.tres` 的h/s/v为1/1/1，`card_banner_rare_mat.tres` 为0.563/1.198/1.14，普通为1/0/0.85。NCard的标题带、插图框、类型牌均使用 `CardModel.BannerMaterial`；原版中文标题和类型字采用 `noto_sans_mono_cjksc_regular_shared.tres`，标题暖白及描边色随稀有度变化，类型字始终为同一黑色、透明度0.752941。
- 修改 `Characters/ThreeLuminariesCardStyle.cs`，仅缓存三辰卡身、普通深色插图框和普通标题带，移除自定义青/金色与类型牌参数维护；修改 `Patches/CardPortraitBorderStylePatch.cs`，罕见/稀有等彩色部件直接使用该卡的原版材质，所有类型牌恢复原版材质（普通为灰色），彻底撤除标题、类型字的主题覆盖与恢复代码。字体、字色、稀有度描边、阴影及升级绿色交回原版；不修改任何共享原版材质参数或游戏文件。
- 只读复核发现共享原版材质若进入原恢复缓存，会在“本池普通→本池罕见→其他池罕见”的复用路径中被误还原为旧普通色。新增ApplyNativeMaterial，在赋原版材质时清除旧缓存；仅自定义普通部件进入恢复追踪。修正后再次编译部署，并经复核确认该风险已闭合。
- 未修改shader文件。旧 `three_luminaries_type_plaque.gdshader` 及同名材质保留，但当前不再加载；旧标题/插图框shader的自定义彩色分支也不再使用，普通深色分支继续工作。没有删除文件、修改卡图或卡牌机制，也没有调用绘图工具。
- 更新 `README.md`、`Art/CARD_STYLE.md`、`Art/ART_GUIDELINES.md`、`Art/CardStyles/2026-10-05/THREE_LUMINARIES_CARD_CONCEPT.md` 及本日志；覆盖已有 `three-luminaries-runtime-preview.png`（1360×510）。修改被Git忽略的 `.godot/verify_full_card_style.gd`，预览同步原版材质、实际Noto中文字体和标题/类型样式，修正此前预览误用思源宋体的问题。
- 新增被Git忽略的 `.godot/probe_native_typography.gd`、`.godot/NativeTypeProbe/NativeTypeProbe.csproj`、`Program.cs` 及检查输出/缓存，用于只读核对字体资源和游戏DLL逻辑；没有新增正式运行时资源。参考截图仅用于只读取色，没有复制到项目或修改图片。
- 按既有自动部署流程执行Release编译、PCK导出及部署，最终0警告、0错误；独立GPU加载三种自定义材质、三档原版稀有度材质与实际中文字体，渲染成功、退出码0、无shader错误。编译与部署DLL的SHA256一致，Git差异格式检查通过。
- 预览按原版控件组合，未重复启动游戏，不能代替完整NCard对局与节点复用实测；最终游戏内外观仍待用户验收。本次未提交Git。

### 15. 游戏内验收通过并提交三辰卡面稳定版本

- 用户确认卡面验收完成，并明确要求提交Git。记录当前三辰卡身、原版青/金稀有度材质、标题/类型字效果已获游戏内外观认可；不将其扩展为所有节点复用或对局路径的专项测试。
- 本次修改 `README.md`、`Art/CARD_STYLE.md` 和本日志，补充验收完成状态。没有新增、删除文件或修改功能，没有重新关闭游戏、编译或部署；沿用上一项已通过的最终Release构建与部署结果。
- 提交范围涵盖自上次提交以来的三辰卡面C#实现、材质/shader及UID、概念图/预览及导入说明、中文卡牌数值连续排版和对应文档。旧类型牌材质作为早期实现记录一并保存，当前仍不加载。
- 提交前检查全部跟踪和新增文件，确认小说 `灵境行者.txt`、`.godot/`临时检查脚本与缓存仍被忽略，不进入提交。仅提交本地仓库，不推送远端。
