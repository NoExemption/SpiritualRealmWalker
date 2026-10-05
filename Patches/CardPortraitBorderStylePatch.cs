using System.Reflection;
using System.Runtime.CompilerServices;
using Godot;
using HarmonyLib;
using MegaCrit.Sts2.Core.Entities.Cards;
using MegaCrit.Sts2.Core.Nodes.Cards;
using SpiritualRealmWalker.Characters;

namespace SpiritualRealmWalker.Patches;

/// <summary>
/// 将卡池共用卡面延伸到独立的插图框、标题带及类型牌。
/// 保留原来的文字、稀有度、升级颜色和布局；节点复用到其他卡池时恢复原样式。
/// </summary>
[HarmonyPatch]
internal static class CardPortraitBorderStylePatch
{
    private static readonly ConditionalWeakTable<CanvasItem, OriginalMaterial> OriginalMaterials = new();

    [HarmonyTargetMethods]
    private static IEnumerable<MethodBase> TargetMethods()
    {
        foreach (var name in new[] { "Reload", "UpdateVisuals", "UpdateTypePlaque", "UpdateTypePlaqueSizeAndPosition" })
            yield return AccessTools.DeclaredMethod(typeof(NCard), name)
                ?? throw new MissingMethodException(typeof(NCard).FullName, name);
    }

    [HarmonyPostfix, HarmonyPriority(Priority.Last)]
    private static void Postfix(
        NCard __instance,
        TextureRect ____portraitBorder,
        TextureRect ____banner,
        Control ____ancientBanner,
        NinePatchRect ____typePlaque)
    {
        var ownCard = __instance.Model?.Pool is NightWandererCardPool;
        if (ownCard)
        {
            var model = __instance.Model!;
            var highlighted = ThreeLuminariesCardStyle.HasRarityAccent(model.Rarity);
            // 直接使用该卡的原版稀有度材质，保留原纹理的折面与高光；不写共享资源参数。
            var nativeBanner = model.BannerMaterial;
            if (highlighted)
            {
                ApplyNativeMaterial(____portraitBorder, nativeBanner);
                ApplyNativeMaterial(____banner, nativeBanner);
                ApplyNativeMaterial(____ancientBanner, nativeBanner);
            }
            else
            {
                ApplyMaterial(____portraitBorder, ThreeLuminariesCardStyle.PortraitBorder);
                ApplyMaterial(____banner, ThreeLuminariesCardStyle.Banner);
                ApplyMaterial(____ancientBanner, ThreeLuminariesCardStyle.Banner);
            }
            ApplyNativeMaterial(____typePlaque, nativeBanner);
        }
        else
        {
            RestoreMaterial(____portraitBorder);
            RestoreMaterial(____banner);
            RestoreMaterial(____ancientBanner);
            RestoreMaterial(____typePlaque);
        }
    }

    private static void ApplyNativeMaterial(CanvasItem? node, Material material)
    {
        if (node is null)
            return;
        // 原版共享材质不属于本补丁；清除旧自定义记录，避免误把别的卡池罕见牌还原为普通色。
        OriginalMaterials.Remove(node);
        node.Material = material;
    }

    private static void ApplyMaterial(CanvasItem? node, Material material)
    {
        if (node is null)
            return;
        var original = OriginalMaterials.GetValue(node, static value => new OriginalMaterial(value.Material));
        original.Applied = material;
        node.Material = material;
    }

    private static void RestoreMaterial(CanvasItem? node)
    {
        if (node is null || !OriginalMaterials.TryGetValue(node, out var original))
            return;
        // Reload可能已为其他卡牌设置了正确材质，不能再覆盖它。
        if (ReferenceEquals(node.Material, original.Applied))
            node.Material = original.Value;
        OriginalMaterials.Remove(node);
    }

    private sealed class OriginalMaterial(Material? value)
    {
        public Material? Value { get; } = value;
        public Material? Applied { get; set; }
    }
}
