using System.Reflection;
using System.Runtime.CompilerServices;
using Godot;
using HarmonyLib;
using MegaCrit.Sts2.addons.mega_text;
using MegaCrit.Sts2.Core.Nodes.Cards;
using SpiritualRealmWalker.Characters;

namespace SpiritualRealmWalker.Patches;

/// <summary>
/// 调整三辰图标内费用数字的位置、大小和普通费用配色。
/// 保存原样式，重复刷新不累加偏移，节点复用时恢复原布局。
/// </summary>
[HarmonyPatch]
internal static class EnergyCostLabelAlignmentPatch
{
    private const float VerticalCorrection = -4f;
    private const int FontSize = 26;
    private const int OutlineSize = 3;
    private const float ExtraEmbolden = 0.65f;
    private static readonly Color NormalFontColor = new("#f1deb7");
    private static readonly Color NormalOutlineColor = new("#1b1711");
    private static readonly Color ShadowColor = new("#100e0bdd");
    private static readonly ConditionalWeakTable<MegaLabel, OriginalStyle> OriginalStyles = new();
    private static readonly ConditionalWeakTable<Font, FontVariation> EmboldenedFonts = new();

    // 费用颜色可能单独刷新，因此同时处理该入口。
    [HarmonyTargetMethods]
    private static IEnumerable<MethodBase> TargetMethods()
    {
        foreach (var name in new[] { "UpdateEnergyCostVisuals", "UpdateEnergyCostColor" })
            yield return AccessTools.DeclaredMethod(typeof(NCard), name)
                ?? throw new MissingMethodException(typeof(NCard).FullName, name);
    }

    [HarmonyPostfix]
    private static void Postfix(NCard __instance, MegaLabel ____energyLabel)
    {
        var label = ____energyLabel;
        if (label is null)
            return;

        if (__instance.Model?.Pool is NightWandererCardPool)
        {
            var original = OriginalStyles.GetValue(label, static value => new OriginalStyle(value));
            label.OffsetTop = original.Top + VerticalCorrection;
            label.OffsetBottom = original.Bottom + VerticalCorrection;
            label.MinFontSize = Math.Min(original.MinFontSize, FontSize);
            label.MaxFontSize = FontSize;
            label.AddThemeFontSizeOverride("font_size", FontSize);
            // RefreshFont会做本地化字体替换，必须先刷新再应用独立字重。
            label.RefreshFont();
            label.AddThemeFontOverride("font", original.EmboldenedFont);
            label.AddThemeConstantOverride("outline_size", OutlineSize);
            label.AddThemeColorOverride("font_shadow_color", ShadowColor);
            label.AddThemeConstantOverride("shadow_offset_x", 1);
            label.AddThemeConstantOverride("shadow_offset_y", 2);
            label.AddThemeConstantOverride("shadow_outline_size", 2);

            // 仅替换普通的浅色费用，保留减费绿色、增费红色及禁用灰色。
            var color = label.GetThemeColor("font_color");
            if (color.IsEqualApprox(NormalFontColor) || IsNeutralLight(color))
            {
                label.AddThemeColorOverride("font_color", NormalFontColor);
                label.AddThemeColorOverride("font_outline_color", NormalOutlineColor);
            }
        }
        else if (OriginalStyles.TryGetValue(label, out var original))
        {
            original.Restore(label);
            OriginalStyles.Remove(label);
        }
    }

    private static bool IsNeutralLight(Color color)
        => Math.Min(color.R, Math.Min(color.G, color.B)) > 0.8f
           && Math.Max(color.R, Math.Max(color.G, color.B))
              - Math.Min(color.R, Math.Min(color.G, color.B)) < 0.2f;

    private static Font CopyForRasterization(Font font)
    {
        var copy = (Font)font.Duplicate();
        if (copy is FontFile file)
            file.MultichannelSignedDistanceField = false;
        else if (copy is FontVariation variation && variation.BaseFont is { } baseFont)
            variation.BaseFont = CopyForRasterization(baseFont);

        copy.Fallbacks = new Godot.Collections.Array<Font>(font.Fallbacks.Select(CopyForRasterization));
        return copy;
    }

    private sealed class OriginalStyle(MegaLabel label)
    {
        public float Top { get; } = label.OffsetTop;
        public float Bottom { get; } = label.OffsetBottom;
        public int MinFontSize { get; } = label.MinFontSize;
        public int MaxFontSize { get; } = label.MaxFontSize;
        private readonly bool _hadFont = label.HasThemeFontOverride("font");
        private readonly Font _font = label.GetThemeFont("font");
        public FontVariation EmboldenedFont { get; } = EmboldenedFonts.GetValue(
            label.GetThemeFont("font"), static font =>
            {
                // 人工加粗可能使轮廓相交；仅在独立副本上关闭MSDF，避免黑色针孔。
                var copy = CopyForRasterization(font);
                var variation = copy as FontVariation ?? new FontVariation { BaseFont = copy };
                variation.VariationEmbolden += ExtraEmbolden;
                return variation;
            });
        private readonly bool _hadFontSize = label.HasThemeFontSizeOverride("font_size");
        private readonly int _fontSize = label.GetThemeFontSize("font_size");
        private readonly bool _hadOutlineSize = label.HasThemeConstantOverride("outline_size");
        private readonly int _outlineSize = label.GetThemeConstant("outline_size");
        private readonly bool _hadFontColor = label.HasThemeColorOverride("font_color");
        private readonly Color _fontColor = label.GetThemeColor("font_color");
        private readonly bool _hadOutlineColor = label.HasThemeColorOverride("font_outline_color");
        private readonly Color _outlineColor = label.GetThemeColor("font_outline_color");
        private readonly bool _hadShadowColor = label.HasThemeColorOverride("font_shadow_color");
        private readonly Color _shadowColor = label.GetThemeColor("font_shadow_color");
        private readonly Dictionary<string, (bool HadOverride, int Value)> _shadowConstants =
            new[] { "shadow_offset_x", "shadow_offset_y", "shadow_outline_size" }.ToDictionary(
                name => name,
                name => (label.HasThemeConstantOverride(name), label.GetThemeConstant(name)));

        public void Restore(MegaLabel label)
        {
            label.OffsetTop = Top;
            label.OffsetBottom = Bottom;
            label.MinFontSize = MinFontSize;
            label.MaxFontSize = MaxFontSize;
            if (_hadFont) label.AddThemeFontOverride("font", _font);
            else label.RemoveThemeFontOverride("font");
            if (_hadFontSize) label.AddThemeFontSizeOverride("font_size", _fontSize);
            else label.RemoveThemeFontSizeOverride("font_size");
            if (_hadOutlineSize) label.AddThemeConstantOverride("outline_size", _outlineSize);
            else label.RemoveThemeConstantOverride("outline_size");
            if (_hadShadowColor) label.AddThemeColorOverride("font_shadow_color", _shadowColor);
            else label.RemoveThemeColorOverride("font_shadow_color");
            foreach (var (name, value) in _shadowConstants)
            {
                if (value.HadOverride) label.AddThemeConstantOverride(name, value.Value);
                else label.RemoveThemeConstantOverride(name);
            }

            // 原版可能刚计算过新的费用颜色，只清理仍属于本补丁的颜色。
            if (label.GetThemeColor("font_color").IsEqualApprox(NormalFontColor))
            {
                if (_hadFontColor) label.AddThemeColorOverride("font_color", _fontColor);
                else label.RemoveThemeColorOverride("font_color");
            }
            if (label.GetThemeColor("font_outline_color").IsEqualApprox(NormalOutlineColor))
            {
                if (_hadOutlineColor) label.AddThemeColorOverride("font_outline_color", _outlineColor);
                else label.RemoveThemeColorOverride("font_outline_color");
            }
            label.RefreshFont();
        }
    }
}
