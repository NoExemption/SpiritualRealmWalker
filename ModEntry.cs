using System.Reflection;
using Godot;
using MegaCrit.Sts2.Core.Modding;
using STS2RitsuLib.Interop;

namespace SpiritualRealmWalker;

// The game calls this method after loading the mod assembly.
[ModInitializer(nameof(Initialize))]
public static class ModEntry
{
    public const string ModId = "SpiritualRealmWalker";

    public static void Initialize()
    {
        ModTypeDiscoveryHub.RegisterModAssembly(ModId, Assembly.GetExecutingAssembly());
        GD.Print("[SpiritualRealmWalker] Initialized v0.1.0");
    }
}
