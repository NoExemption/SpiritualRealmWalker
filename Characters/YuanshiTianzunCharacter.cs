using System.Collections.Generic;
using Godot;
using MegaCrit.Sts2.Core.Entities.Characters;
using STS2RitsuLib.Interop.AutoRegistration;
using STS2RitsuLib.Scaffolding.Characters;

namespace SpiritualRealmWalker.Characters;

/// <summary>
/// 可玩角色“元始天尊”，职业固定为夜游神。
/// 选人背景与头像使用三辰本源插画，其余尚未制作的角色资源复用铁甲战士占位。
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

    // 专用场景抵消原版动画容器的额外缩放，按实际屏幕完整显示静态插画。
    public override string? CustomCharacterSelectBgPath =>
        "res://SpiritualRealmWalker/scenes/character_select/yuanshi_tianzun_bg.tscn";

    // 选中与普通未选中状态复用同一头像，沿用游戏的调色与亮框。
    public override string? CustomCharacterSelectIconPath =>
        "res://SpiritualRealmWalker/images/character_select/yuanshi_tianzun_icon.png";

    // 缺失的战斗、商店、篝火和音效资源暂用铁甲战士占位。
    public override string? PlaceholderCharacterId => "ironclad";

    // 第一版直接可选；剧情时间线与解锁条件以后单独设计。
    public override bool RequiresEpochAndTimeline => false;
}
