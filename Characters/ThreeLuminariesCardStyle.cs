using Godot;
using MegaCrit.Sts2.Core.Entities.Cards;

namespace SpiritualRealmWalker.Characters;

/// <summary>三个职业阶段共用的卡身、插图框、标题带及类型牌材质。</summary>
internal static class ThreeLuminariesCardStyle
{
    private static ShaderMaterial? _frame;
    private static ShaderMaterial? _portraitBorder;
    private static ShaderMaterial? _banner;

    public static ShaderMaterial Frame => _frame ??= Load("three_luminaries_card_frame");
    public static ShaderMaterial PortraitBorder => _portraitBorder ??= Load("three_luminaries_portrait_border");

    public static bool HasRarityAccent(CardRarity rarity)
        => rarity is CardRarity.Uncommon or CardRarity.Rare or CardRarity.Ancient;

    // 此处只加载普通卡牌的三辰标题带；彩色标题、框和全部类型牌由原版提供。
    public static ShaderMaterial Banner
    {
        get
        {
            if (_banner is not null)
                return _banner;
            _banner = Load("three_luminaries_banner");
            _banner.SetShaderParameter("rarity_color", new Color("#879da6"));
            _banner.SetShaderParameter("rarity_strength", 0.35f);
            return _banner;
        }
    }

    private static ShaderMaterial Load(string name)
        => ResourceLoader.Load<ShaderMaterial>($"res://SpiritualRealmWalker/materials/{name}.tres")
           ?? throw new InvalidOperationException($"Missing card style material: {name}");
}
