using Godot;
using STS2RitsuLib.Scaffolding.Content;

namespace SpiritualRealmWalker.Characters;

/// <summary>
/// 夜游神专属遗物池，使用三辰共用能量图标。
/// </summary>
public sealed class NightWandererRelicPool : TypeListRelicPoolModel
{
    public override string EnergyColorName => "NightWanderer";
    public override Color LabOutlineColor => YuanshiTianzunCharacter.ThemeColor;
    public override string? BigEnergyIconPath => ThreeLuminariesEnergyIcons.BigPath;
    public override string? TextEnergyIconPath => ThreeLuminariesEnergyIcons.TextPath;
}
