using System.Collections.Generic;
using Godot;
using MegaCrit.Sts2.Core.Entities.Characters;
using STS2RitsuLib.Interop.AutoRegistration;
using STS2RitsuLib.Scaffolding.Characters;

namespace SpiritualRealmWalker.Characters;

/// <summary>
/// 可玩角色“元始天尊”，职业固定为夜游神。
/// 当前阶段复用铁甲战士资源作为占位，只验证角色与内容注册链路。
/// </summary>
[RegisterCharacter]
public sealed class YuanshiTianzunCharacter
    : ModCharacterTemplate<NightWandererCardPool, NightWandererRelicPool, NightWandererPotionPool>
{
    public static readonly Color ThemeColor = new("6657a8");
    public static readonly Color DarkThemeColor = new("211a3d");

    public override Color NameColor => ThemeColor;
    public override Color EnergyLabelOutlineColor => DarkThemeColor;
    public override Color MapDrawingColor => ThemeColor;
    public override CharacterGender Gender => CharacterGender.Masculine;
    public override int StartingHp => 75;
    public override int StartingGold => 99;
    public override float AttackAnimDelay => 0.15f;
    public override float CastAnimDelay => 0.25f;

    // 战斗特效暂沿用游戏现有的通用斩击，避免最小骨架依赖尚未制作的美术资源。
    public override List<string> GetArchitectAttackVfx() => ["vfx/vfx_attack_slash"];

    // 缺失的角色选择、战斗、商店、篝火和音效资源均暂用铁甲战士占位。
    public override string? PlaceholderCharacterId => "ironclad";

    // 第一版直接可选；剧情时间线与解锁条件以后单独设计。
    public override bool RequiresEpochAndTimeline => false;
}
