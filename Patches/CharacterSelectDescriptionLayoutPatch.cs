using System.Runtime.CompilerServices;
using Godot;
using HarmonyLib;
using MegaCrit.Sts2.Core.Models;
using MegaCrit.Sts2.Core.Nodes.Screens.CharacterSelect;
using SpiritualRealmWalker.Characters;

namespace SpiritualRealmWalker.Patches;

/// <summary>角色介绍按显式换行显示；共享节点切换到其他角色时恢复原布局。</summary>
[HarmonyPatch(typeof(NCharacterSelectScreen), "SelectCharacter")]
internal static class CharacterSelectDescriptionLayoutPatch
{
    private const int FontSizeReduction = 3;
    private const float InfoPanelHeightIncrease = 64f;
    private const float InfoContentOffsetY = 32f;
    private static readonly ConditionalWeakTable<RichTextLabel, OriginalLayout> Originals = new();
    private static readonly ConditionalWeakTable<Control, OriginalPanelLayout> PanelOriginals = new();
    private static readonly ConditionalWeakTable<Control, OriginalContentLayout> ContentOriginals = new();

    [HarmonyPrefix]
    private static void Prefix(RichTextLabel ____description)
    {
        if (Originals.TryGetValue(____description, out var original))
        {
            ____description.AutowrapMode = original.Wrap;
            ____description.CustomMinimumSize = original.MinimumSize;
            if (original.HadNormalFontSizeOverride)
                ____description.AddThemeFontSizeOverride("normal_font_size", original.NormalFontSize);
            else
                ____description.RemoveThemeFontSizeOverride("normal_font_size");
        }

        if (GetInfoPanel(____description) is { } infoPanel &&
            PanelOriginals.TryGetValue(infoPanel, out var panelOriginal))
        {
            infoPanel.OffsetBottom = panelOriginal.OffsetBottom;
        }

        if (GetContentContainer(____description) is { } content &&
            ContentOriginals.TryGetValue(content, out var contentOriginal))
        {
            content.OffsetTop = contentOriginal.OffsetTop;
            content.OffsetBottom = contentOriginal.OffsetBottom;
        }
    }

    [HarmonyPostfix]
    private static void Postfix(CharacterModel __1, RichTextLabel ____description)
    {
        if (__1 is not YuanshiTianzunCharacter)
            return;

        Originals.GetValue(____description, label => new OriginalLayout(
            label.AutowrapMode,
            label.CustomMinimumSize,
            label.HasThemeFontSizeOverride("normal_font_size"),
            label.GetThemeFontSize("normal_font_size")));
        var font = ____description.GetThemeFont("normal_font");
        var fontSize = Mathf.Max(1,
            ____description.GetThemeFontSize("normal_font_size") - FontSizeReduction);
        var width = 0f;
        foreach (var line in ____description.GetParsedText().Split('\n'))
            width = Mathf.Max(width, font.GetStringSize(line, fontSize: fontSize).X);

        // 仅缩小本角色的介绍字号，并扩展介绍本身的最小宽度以避免截断。
        ____description.AddThemeFontSizeOverride("normal_font_size", fontSize);
        ____description.AutowrapMode = TextServer.AutowrapMode.Off;
        ____description.CustomMinimumSize = new Vector2(
            Mathf.Max(____description.CustomMinimumSize.X, Mathf.Ceil(width) + 16),
            ____description.CustomMinimumSize.Y);

        if (GetInfoPanel(____description) is not { } infoPanel)
            return;

        var panelOriginal = PanelOriginals.GetValue(
            infoPanel, panel => new OriginalPanelLayout(panel.OffsetBottom));
        // 只向下延长最外层灰色信息面板，不改变角色卡说明区域本身。
        infoPanel.OffsetBottom = panelOriginal.OffsetBottom + InfoPanelHeightIncrease;

        if (GetContentContainer(____description) is not { } content)
            return;

        var contentOriginal = ContentOriginals.GetValue(content, container =>
            new OriginalContentLayout(container.OffsetTop, container.OffsetBottom));
        // 将灰框内从角色名称到初始遗物的整组内容下移，利用新增高度重新居中。
        content.OffsetTop = contentOriginal.OffsetTop + InfoContentOffsetY;
        content.OffsetBottom = contentOriginal.OffsetBottom + InfoContentOffsetY;
    }

    private static Control? GetContentContainer(RichTextLabel description) =>
        description.GetParent() as Control;

    private static Control? GetInfoPanel(RichTextLabel description) =>
        description.GetParent()?.GetParent() as Control;

    private sealed record OriginalLayout(
        TextServer.AutowrapMode Wrap,
        Vector2 MinimumSize,
        bool HadNormalFontSizeOverride,
        int NormalFontSize);

    private sealed record OriginalPanelLayout(float OffsetBottom);
    private sealed record OriginalContentLayout(float OffsetTop, float OffsetBottom);
}
