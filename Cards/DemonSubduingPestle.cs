using MegaCrit.Sts2.Core.Commands;
using MegaCrit.Sts2.Core.Entities.Cards;
using MegaCrit.Sts2.Core.Entities.Powers;
using MegaCrit.Sts2.Core.GameActions.Multiplayer;
using MegaCrit.Sts2.Core.Localization.DynamicVars;
using MegaCrit.Sts2.Core.ValueProps;
using SpiritualRealmWalker.Characters;
using STS2RitsuLib.Cards.DynamicVars;
using STS2RitsuLib.Interop.AutoRegistration;
using STS2RitsuLib.Scaffolding.Content;

namespace SpiritualRealmWalker.Cards;

[RegisterCard(typeof(NightWandererCardPool))]
public sealed class DemonSubduingPestle : ModCardTemplate
{
    protected override IEnumerable<DynamicVar> CanonicalVars =>
        [
            new DamageVar(30, ValueProp.Move),
            new DynamicVar("HpLoss", 6),
            new DynamicVar("ItemLore", 0).WithTooltip(
                "cards", "SPIRITUAL_REALM_WALKER_CARD_DEMON_SUBDUING_PESTLE.loreTitle",
                "cards", "SPIRITUAL_REALM_WALKER_CARD_DEMON_SUBDUING_PESTLE.loreDescription")
        ];

    public DemonSubduingPestle() : base(3, CardType.Attack, CardRarity.Uncommon, TargetType.AnyEnemy, true) { }

    protected override async Task OnPlay(PlayerChoiceContext choiceContext, CardPlay cardPlay)
    {
        ArgumentNullException.ThrowIfNull(cardPlay.Target);
        await CreatureCmd.Damage(
            choiceContext, Owner.Creature, DynamicVars["HpLoss"].BaseValue,
            DamageProps.cardHpLoss, this, cardPlay);
        if (!Owner.Creature.IsAlive)
            return;

        await DamageCmd.Attack(DynamicVars.Damage.BaseValue)
            .FromCard(this, cardPlay).Targeting(cardPlay.Target).Execute(choiceContext);

        var removableDebuffs = Owner.Creature.Powers
            .Where(power => power.Type == PowerType.Debuff)
            .ToList();
        foreach (var power in removableDebuffs)
            await PowerCmd.Remove(power);
    }

    protected override void OnUpgrade() => DynamicVars.Damage.UpgradeValueBy(3);
}
