using MegaCrit.Sts2.Core.Commands;
using MegaCrit.Sts2.Core.Entities.Cards;
using MegaCrit.Sts2.Core.GameActions.Multiplayer;
using MegaCrit.Sts2.Core.Localization.DynamicVars;
using MegaCrit.Sts2.Core.Models.Powers;
using MegaCrit.Sts2.Core.ValueProps;
using SpiritualRealmWalker.Characters;
using STS2RitsuLib.Cards.DynamicVars;
using STS2RitsuLib.Interop.AutoRegistration;
using STS2RitsuLib.Scaffolding.Content;

namespace SpiritualRealmWalker.Cards;

/// <summary>无视格挡、造成持续伤害，并在完成击杀时治疗使用者的道具牌。</summary>
[RegisterCard(typeof(NightWandererCardPool))]
public sealed class BloodthirstyBlade : ModCardTemplate
{
    public override string CustomPortraitPath =>
        "res://SpiritualRealmWalker/images/cards/bloodthirsty_blade.png";

    protected override IEnumerable<DynamicVar> CanonicalVars =>
        [
            new DamageVar(7, ValueProp.Move | ValueProp.Unblockable),
            new DynamicVar("Poison", 2),
            new DynamicVar("HpLoss", 2),
            new DynamicVar("ItemLore", 0).WithTooltip(
                "cards", "SPIRITUAL_REALM_WALKER_CARD_BLOODTHIRSTY_BLADE.loreTitle",
                "cards", "SPIRITUAL_REALM_WALKER_CARD_BLOODTHIRSTY_BLADE.loreDescription")
        ];

    public BloodthirstyBlade() : base(1, CardType.Attack, CardRarity.Common, TargetType.AnyEnemy, true) { }

    protected override async Task OnPlay(PlayerChoiceContext choiceContext, CardPlay cardPlay)
    {
        ArgumentNullException.ThrowIfNull(cardPlay.Target);
        var results = await CreatureCmd.Damage(
            choiceContext, cardPlay.Target, DynamicVars.Damage, Owner.Creature, this, cardPlay);
        bool killed = results.Any(result =>
            result.Receiver == cardPlay.Target && result.WasTargetKilled);
        if (killed)
        {
            await CreatureCmd.Heal(Owner.Creature, 3);
        }
        else if (cardPlay.Target.IsAlive)
        {
            await PowerCmd.Apply<PoisonPower>(
                choiceContext, cardPlay.Target, DynamicVars["Poison"].BaseValue, Owner.Creature, this);
        }

        await CreatureCmd.Damage(
            choiceContext, Owner.Creature, DynamicVars["HpLoss"].BaseValue,
            DamageProps.cardHpLoss, this, cardPlay);
    }

    protected override void OnUpgrade() => DynamicVars.Damage.UpgradeValueBy(3);
}
