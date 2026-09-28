using Godot;
using STS2RitsuLib.Scaffolding.Content;

namespace SpiritualRealmWalker.Characters;

/// <summary>
/// 元始天尊绑定的夜游神专属卡池。
/// 当前只定义卡池身份与配色，正式能量图标和卡框稍后替换。
/// </summary>
public sealed class NightWandererCardPool : TypeListCardPoolModel
{
    public override string Title => "NightWanderer";
    public override string EnergyColorName => "NightWanderer";
    public override string? BigEnergyIconPath => null;
    public override string? TextEnergyIconPath => null;
    public override Color DeckEntryCardColor => YuanshiTianzunCharacter.ThemeColor;
    public override Color EnergyOutlineColor => YuanshiTianzunCharacter.DarkThemeColor;
    public override Material? PoolFrameMaterial => null;
    public override bool IsColorless => false;
}
