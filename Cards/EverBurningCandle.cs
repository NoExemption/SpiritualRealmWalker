using MegaCrit.Sts2.Core.Commands;
using MegaCrit.Sts2.Core.Entities.Cards;
using MegaCrit.Sts2.Core.Entities.Powers;
using MegaCrit.Sts2.Core.GameActions.Multiplayer;
using MegaCrit.Sts2.Core.Localization.DynamicVars;
using MegaCrit.Sts2.Core.Models.Powers;
using SpiritualRealmWalker.Characters;
using STS2RitsuLib.Cards.DynamicVars;
using STS2RitsuLib.Interop.AutoRegistration;
using STS2RitsuLib.Scaffolding.Content;

namespace SpiritualRealmWalker.Cards;

[RegisterCard(typeof(NightWandererCardPool))]
public sealed class EverBurningCandle : ModCardTemplate
{
    public override string CustomPortraitPath =>
        "res://SpiritualRealmWalker/images/cards/ever_burning_candle.png";

    public override IEnumerable<CardKeyword> CanonicalKeywords => [CardKeyword.Exhaust];
    protected override IEnumerable<DynamicVar> CanonicalVars =>
        [
            new DynamicVar("SelfVulnerable", 2),
            new DynamicVar("ItemLore", 0).WithTooltip(
                "cards", "SPIRITUAL_REALM_WALKER_CARD_EVER_BURNING_CANDLE.loreTitle",
                "cards", "SPIRITUAL_REALM_WALKER_CARD_EVER_BURNING_CANDLE.loreDescription")
        ];

    public EverBurningCandle() : base(0, CardType.Skill, CardRarity.Common, TargetType.Self, true) { }

    protected override async Task OnPlay(PlayerChoiceContext choiceContext, CardPlay cardPlay)
    {
        var removableDebuffs = Owner.Creature.Powers
            .Where(power => power.Type == PowerType.Debuff && power is not VulnerablePower)
            .ToList();
        foreach (var power in removableDebuffs)
            await PowerCmd.Remove(power);

        await PowerCmd.Apply<VulnerablePower>(
            choiceContext, Owner.Creature, DynamicVars["SelfVulnerable"].BaseValue,
            Owner.Creature, this);
    }

    protected override void OnUpgrade() => DynamicVars["SelfVulnerable"].UpgradeValueBy(-1);
}
