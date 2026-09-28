using Godot;
using MegaCrit.Sts2.Core.Modding;

namespace SpiritualRealmWalker;

// The game calls this method after loading the mod assembly.
[ModInitializer(nameof(Initialize))]
public static class ModEntry
{
    public static void Initialize()
    {
        GD.Print("[SpiritualRealmWalker] Initialized v0.1.0");
    }
}
