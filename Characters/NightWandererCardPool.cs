using Godot;
using STS2RitsuLib.Scaffolding.Content;

namespace SpiritualRealmWalker.Characters;

/// <summary>
/// 元始天尊绑定的夜游神专属卡池。
/// 使用三辰共用能量图标与墨蓝孔雀青、古金边及星仪底纹材质。
/// </summary>
public sealed class NightWandererCardPool : TypeListCardPoolModel
{
    public override string Title => "NightWanderer";
    public override string EnergyColorName => "NightWanderer";
    public override string? BigEnergyIconPath => ThreeLuminariesEnergyIcons.BigPath;
    public override string? TextEnergyIconPath => ThreeLuminariesEnergyIcons.TextPath;
    public override Color DeckEntryCardColor => YuanshiTianzunCharacter.ThemeColor;
    public override Color EnergyOutlineColor => YuanshiTianzunCharacter.DarkThemeColor;
    public override Material? PoolFrameMaterial => ThreeLuminariesCardStyle.Frame;
    public override bool IsColorless => false;
}
