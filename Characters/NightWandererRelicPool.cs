using Godot;
using STS2RitsuLib.Scaffolding.Content;

namespace SpiritualRealmWalker.Characters;

/// <summary>
/// 夜游神专属遗物池骨架；当前尚未注册专属遗物。
/// </summary>
public sealed class NightWandererRelicPool : TypeListRelicPoolModel
{
    public override string EnergyColorName => "NightWanderer";
    public override Color LabOutlineColor => YuanshiTianzunCharacter.ThemeColor;
    public override string? BigEnergyIconPath => null;
    public override string? TextEnergyIconPath => null;
}
