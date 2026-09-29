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
