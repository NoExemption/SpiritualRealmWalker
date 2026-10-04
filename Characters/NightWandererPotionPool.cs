using Godot;
using STS2RitsuLib.Scaffolding.Content;

namespace SpiritualRealmWalker.Characters;

/// <summary>
/// 夜游神专属药水池骨架；当前尚未注册专属药水。
/// </summary>
public sealed class NightWandererPotionPool : TypeListPotionPoolModel
{
    public override string EnergyColorName => "NightWanderer";
    public override Color LabOutlineColor => YuanshiTianzunCharacter.ThemeColor;
    public override string? BigEnergyIconPath => ThreeLuminariesEnergyIcons.BigPath;
    public override string? TextEnergyIconPath => ThreeLuminariesEnergyIcons.TextPath;
}
