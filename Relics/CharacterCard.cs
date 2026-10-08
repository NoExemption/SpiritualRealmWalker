using MegaCrit.Sts2.Core.Commands;
using MegaCrit.Sts2.Core.Entities.Relics;
using MegaCrit.Sts2.Core.GameActions.Multiplayer;
using MegaCrit.Sts2.Core.HoverTips;
using MegaCrit.Sts2.Core.Localization.DynamicVars;
using MegaCrit.Sts2.Core.Models.Powers;
using MegaCrit.Sts2.Core.Rooms;
using MegaCrit.Sts2.Core.Saves.Runs;
using SpiritualRealmWalker.Characters;
using SpiritualRealmWalker.Progression;
using STS2RitsuLib.Cards.DynamicVars;
using STS2RitsuLib.Interop.AutoRegistration;
using STS2RitsuLib.Scaffolding.Content;

namespace SpiritualRealmWalker.Relics;

/// <summary>元始天尊的角色卡，保存等级经验并执行夜游神成长机制。</summary>
[RegisterRelic(typeof(NightWandererRelicPool))]
[RegisterCharacterStarterRelic(typeof(YuanshiTianzunCharacter))]
public sealed class CharacterCard : ModRelicTemplate
{
    public override RelicRarity Rarity => RelicRarity.Starter;
    public override RelicAssetProfile AssetProfile => new(
        IconPath: "res://SpiritualRealmWalker/images/relics/character_card.png",
        IconOutlinePath: "res://SpiritualRealmWalker/images/relics/character_card_outline.png",
        BigIconPath: "res://SpiritualRealmWalker/images/relics/character_card_big.png");
    public override bool ShowCounter => true;
    public override int DisplayAmount => NightWandererProgression.Level(TotalExperience);
    protected override IEnumerable<IHoverTip> AdditionalHoverTips =>
        [DynamicVars["LunarSpirit"].CreateHoverTip()!];
    protected override IEnumerable<DynamicVar> CanonicalVars =>
        [
            new DynamicVar("Level", 1),
            new DynamicVar("Experience", 0),
            new DynamicVar("Healing", 3),
            new DynamicVar("Trial", 4),
            new DynamicVar("LunarSpirit", 0).WithTooltip(
                "relics", "SPIRITUAL_REALM_WALKER_RELIC_CHARACTER_CARD.lunarSpiritTitle",
                "relics", "SPIRITUAL_REALM_WALKER_RELIC_CHARACTER_CARD.lunarSpiritDescription")
        ];

    private int _totalExperience;

    [SavedProperty]
    public int TotalExperience
    {
        get => _totalExperience;
        set
        {
            _totalExperience = NightWandererProgression.Clamp(value);
            UpdateDescription();
            InvokeDisplayAmountChanged();
        }
    }

    private void UpdateDescription()
    {
        DynamicVars["Level"].BaseValue = DisplayAmount;
        DynamicVars["Experience"].BaseValue = NightWandererProgression.LevelExperience(TotalExperience);
        DynamicVars["Healing"].BaseValue = DisplayAmount + 2;
        DynamicVars["Trial"].BaseValue = NightWandererProgression.TrialTier(TotalExperience);
    }

    public override async Task BeforeCombatStart()
    {
        UpdateDescription();
        Flash();
        await CreatureCmd.Heal(Owner.Creature, DisplayAmount + 2);
        var run = Owner.RunState;
        if (run.CurrentActIndex != 0 || run.CurrentRoom is not CombatRoom room || room.RoomType != RoomType.Boss)
            return;

        // 联机只由队伍中第一张角色卡施加一次，取所有角色卡的最高试炼档。
        var cards = room.CombatState.Players.SelectMany(player => player.Relics).OfType<CharacterCard>().ToList();
        if (cards.FirstOrDefault() != this) return;
        int tier = cards.Max(card => NightWandererProgression.TrialTier(card.TotalExperience));
        if (tier == 0) return;
        var context = new ThrowingPlayerChoiceContext();
        foreach (var enemy in room.Enemies.Where(enemy => enemy.IsPrimaryEnemy).ToList())
        {
            await CreatureCmd.SetMaxAndCurrentHp(enemy, Math.Ceiling(enemy.MaxHp * (1m + tier * 0.1m)));
            await PowerCmd.Apply<StrengthPower>(context, enemy, tier, Owner.Creature, null);
        }
        Godot.GD.Print($"[SpiritualRealmWalker] Act 1 trial tier={tier}");
    }

    public override Task AfterCombatVictory(CombatRoom room)
    {
        TotalExperience = room.RoomType switch
        {
            RoomType.Boss when Owner.RunState.CurrentActIndex == 0 => Math.Max(TotalExperience, 200),
            RoomType.Boss => TotalExperience,
            RoomType.Elite => TotalExperience + 50,
            _ => TotalExperience + 30
        };
        Flash();
        Godot.GD.Print($"[SpiritualRealmWalker] Experience={TotalExperience}, level={DisplayAmount}");
        return Task.CompletedTask;
    }
}
