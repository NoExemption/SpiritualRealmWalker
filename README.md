# 灵境行者 Mod（SpiritualRealmWalker）

本文件是项目的学习说明与进度记录。每次完成项目任务，同步更新文件用途、操作步骤、验证结果和待办；只记录实际完成的内容。

## 1. 当前阶段

- 已创建正式 Godot C# 项目骨架，Mod ID 与程序集名称统一为 SpiritualRealmWalker。
- 入口目前只输出初始化日志，尚未添加角色、卡牌、美术、BaseLib 或 PCK 资源包。
- 已使用 .NET SDK 10.0.401 编译：零警告、零错误。
- 已使用 Godot 4.5.1 .NET 无界面编辑器导入项目：成功退出。
- 正式项目已部署；2026-09-28 通过 Steam 启动游戏，日志确认 ModEntry.Initialize 执行及初始化完成。
- 已初始化本地 Git 仓库，初始分支为 main；尚无提交、未暂存文件、未配置远程仓库。

## 2. 本机路径与开发工具

| 项目 | 路径或版本 | 用途 |
|---|---|---|
| 源码目录 | D:\Code\SpiritualRealmWalker | 编辑与编译正式项目 |
| Godot 编辑器 | D:\Godot_v4.5.1-stable_mono_win64 | 管理场景、图片、动画和资源导出 |
| Godot 版本 | 4.5.1.stable.mono.official.f62fdbde1 | 支持 C# 的 .NET 版本 |
| .NET SDK | 10.0.401 | 将 C# 编译为 DLL；本项目目标仍为 net9.0 |
| 游戏目录 | D:\SteamLibrary\steamapps\common\Slay the Spire 2 | 提供程序集引用；已检查版本为 v0.111.0 |
| 部署目录 | 游戏目录下的 mods\SpiritualRealmWalker | 已放置 DLL 和 JSON，并验证游戏初始化成功 |

以上为本次验证时的环境，工具或游戏升级后需要重新核实。

## 3. 文件与目录说明

以下路径均相对于源码目录。

| 文件或目录 | 来源 | 用途与维护方式 |
|---|---|---|
| project.godot | 手动创建 | Godot 项目入口，定义名称、C# 支持、程序集名和 Mobile 渲染器；在 Godot 中导入此文件 |
| SpiritualRealmWalker.csproj | 手动创建 | C# 项目配置；使用 Godot.NET.Sdk/4.5.1，目标为 net9.0，引用游戏的 sts2.dll；游戏引用不复制到编译输出 |
| ModEntry.cs | 手动创建 | Mod 入口；游戏通过 ModInitializer 特性找到 Initialize 方法，目前调用 GD.Print 输出初始化标记 |
| SpiritualRealmWalker.json | 手动创建 | Mod 清单；定义 ID、显示名称、版本、依赖、是否有 DLL/PCK、是否影响玩法；作者字段暂为空 |
| .gitignore | 手动创建 | 规定以后提交 Git 时忽略 .godot、bin、obj 和常见编辑器缓存；它本身不会创建仓库或删除文件 |
| .git/ | Git 初始化生成 | 本地版本库元数据；不要手动编辑。初始化不等于已保存源码版本，首次提交后才形成可回溯快照 |
| README.md | 手动维护 | 项目说明、文件用途、编译部署流程、验证状态和变更记录 |
| ModEntry.cs.uid | Godot 自动生成 | 脚本稳定标识；应保留，使用版本控制时随源码提交，通常无需手改 |
| .godot/ | Godot 与编译工具自动生成 | 编辑器缓存、导入数据与 C# 编译中间文件；不手动编辑，不提交版本库 |
| .godot/mono/temp/bin/Release/SpiritualRealmWalker.dll | 编译生成 | 实际由游戏加载的代码程序集；修改 C# 后重新编译生成，不能直接编辑 |
| .godot/mono/temp/bin/Release/SpiritualRealmWalker.json | 编译复制 | 来自源码目录的清单副本；修改清单应改源码文件，再编译 |

自动生成目录内部可能新增缓存文件，不逐个维护清单；记录其类别和作用即可。

## 4. 从源码到游戏的流程

1. 修改 C# 逻辑、项目配置或 Mod 清单。
2. .NET SDK 按 csproj 的配置编译，生成 DLL 并复制清单。
3. 后续加入图片、场景等内容时，由 Godot 导入并导出 PCK 资源包。
4. 将需要的产物部署到游戏 mods\SpiritualRealmWalker。
5. 通过 Steam 启动游戏，游戏读取清单、加载程序集并执行 ModEntry.Initialize。
6. 检查日志确认入口实际执行；只看到 Mod 名称不等于加载成功。

## 5. 打开与编译

在 Godot 项目管理器中选择“导入”，打开本目录的 project.godot。
这是由游戏加载的 Mod，不是独立游戏，暂不设置主场景，也不使用编辑器的运行按钮验证 Mod。

在 PowerShell 中编译：

```powershell
Set-Location 'D:\Code\SpiritualRealmWalker'
dotnet build .\SpiritualRealmWalker.csproj -c Release
```

当前实际输出目录为 .godot\mono\temp\bin\Release；未来以编译输出显示的路径为准。
若游戏位置变化，可以覆盖 GameDir：

```powershell
dotnet build .\SpiritualRealmWalker.csproj -c Release -p:GameDir="新的游戏目录"
```

## 6. 部署与加载验证（已完成首次验证）

将编译输出中的 SpiritualRealmWalker.dll 和 SpiritualRealmWalker.json 放入游戏目录的 mods\SpiritualRealmWalker，然后通过 Steam 启动游戏。
当前没有自定义资源，所以清单的 has_pck 为 false；新增图片或场景后，再配置资源导出并将其改为 true。

日志位置：%APPDATA%\SlayTheSpire2\logs\godot.log。
本次已观察到的入口标记：

```text
[SpiritualRealmWalker] Initialized v0.1.0
```

本次日志还确认了游戏自身的初始化完成记录：

```text
[INFO] Finished mod initialization for '灵境行者' (SpiritualRealmWalker).
```

已对部署的 DLL、JSON 与编译产物逐一比较 SHA256，完全一致。此次验证仅证明空 Mod 入口可加载，不代表角色、卡牌或战斗功能已经实现。

## 7. 变更记录

### 2026-09-28：创建正式项目骨架

- 新增 project.godot、SpiritualRealmWalker.csproj、ModEntry.cs、SpiritualRealmWalker.json、.gitignore、README.md。
- 编译与导入自动生成 .godot/ 和 ModEntry.cs.uid。
- 编译零警告、零错误；Godot 导入成功。
- 未部署到游戏，未修改游戏文件，未删除文件。

### 2026-09-28：补充学习文档

- 修改 README.md：补充逐文件说明、自动生成内容、环境路径、开发流程、验证状态和变更记录。
- 本次仅更新文档；未修改功能代码，未新增或删除项目文件。
- 验证方式：核对当前文件清单并回读文档；不重复运行与文档修改无关的编译测试。

### 2026-09-28：执行 Release 编译并修正清单复制

- 首次编译成功，但检查发现输出目录缺少 SpiritualRealmWalker.json。
- 修改 SpiritualRealmWalker.csproj：将清单条目的 None Update 改为 None Include，显式加入编译项目并保留 PreserveNewest 复制规则。Update 只修改已有条目，此前未实际包含该清单。
- 再次编译成功：零警告、零错误。输出目录同时存在 DLL 和 JSON；清单副本与源码清单的文件哈希一致。
- 更新 README.md；编译工具生成或更新 .godot 下的 DLL、调试符号、清单副本及中间文件。
- 未修改 ModEntry.cs 或清单内容，未删除文件，未部署或启动游戏。本次仅完成编译与产物检查。

### 2026-09-28：部署正式 Mod 并验证游戏加载

- 在游戏目录新增 mods\SpiritualRealmWalker 文件夹。
- 新增 mods\SpiritualRealmWalker\SpiritualRealmWalker.dll：复制已编译的 Mod 代码。
- 新增 mods\SpiritualRealmWalker\SpiritualRealmWalker.json：复制编译输出的清单。
- 两个部署文件与编译产物的 SHA256 一致。
- 通过 Steam 启动游戏；godot.log 确认发现清单、加载 DLL、调用 ModEntry、输出 Initialized v0.1.0，并完成初始化。
- 修改 README.md：同步部署状态、验证证据及下一步。未修改源码、项目配置或清单内容，未删除文件。
- 游戏启动过程中自行更新日志及运行数据；这些不是新增的项目源文件。

### 2026-09-28：初始化本地 Git 仓库

- 在 D:\Code\SpiritualRealmWalker 执行 git init -b main，新增 .git/ 元数据目录。
- 保留现有 .gitignore：排除 .godot/、bin/、obj/ 和编辑器缓存；ModEntry.cs.uid 应随源码提交。
- 更新 README.md 的版本控制状态、目录用途和变更记录。
- 本次不暂存文件、不创建提交、不配置远程地址，不修改全局 Git 设置；未删除文件。
- 可运行 git status 查看待跟踪文件。首次提交前尚无可回退的代码快照。

## 8. 维护约定与下一步

- 每次完成项目任务，同步更新本文的当前阶段、受影响的文件说明、验证结果及变更记录。
- 向用户说明新增、修改、删除的具体文件与原因，以及工具自动生成的主要内容。
- 将“已经验证”和“计划执行”明确区分；操作失败或尚未验证时如实记录。
- 遵守用户的文件删除规则：不执行批量删除；需要批量清理时请用户手动操作。
- 下一步：确定首个角色及最小内容范围，再引入所需基础库并实现角色骨架。



