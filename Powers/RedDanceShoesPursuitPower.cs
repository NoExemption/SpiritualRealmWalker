using MegaCrit.Sts2.Core.Commands;
using MegaCrit.Sts2.Core.Combat;
using MegaCrit.Sts2.Core.Entities.Cards;
using MegaCrit.Sts2.Core.Entities.Creatures;
using MegaCrit.Sts2.Core.Entities.Powers;
using MegaCrit.Sts2.Core.GameActions.Multiplayer;
using MegaCrit.Sts2.Core.Localization.DynamicVars;
using MegaCrit.Sts2.Core.ValueProps;
using SpiritualRealmWalker.Cards;
using STS2RitsuLib.Interop.AutoRegistration;
using STS2RitsuLib.Scaffolding.Content;

namespace SpiritualRealmWalker.Powers;

[RegisterPower]
public sealed class RedDanceShoesPursuitPower : ModPowerTemplate
{
    public override PowerType Type => PowerType.Debuff;
    public override PowerStackType StackType => PowerStackType.Counter;
    protected override IEnumerable<DynamicVar> CanonicalVars => [new DynamicVar("Turns", 3)];

    public override async Task BeforeSideTurnStart(
        PlayerChoiceContext choiceContext, CombatSide side,
        IReadOnlyList<Creature> creatures, ICombatState combatState)
    {
        if (Applier is null || side != Applier.Side || !Owner.IsAlive || Applier.Player is null)
            return;

        decimal turns = DynamicVars["Turns"].BaseValue - 1;
        if (turns <= 0)
        {
            var dance = combatState.CreateCard<DanceTogether>(Applier.Player);
            await CardPileCmd.AddGeneratedCardToCombat(
                dance, PileType.Hand, Applier.Player, CardPilePosition.Bottom);
            turns = 3;
            Flash();
        }
        DynamicVars["Turns"].BaseValue = turns;
    }

    public override async Task AfterSideTurnEnd(
        PlayerChoiceContext choiceContext, CombatSide side, IEnumerable<Creature> creatures)
    {
        if (Applier is null || side != Applier.Side || !Owner.IsAlive)
            return;

        Flash();
        await CreatureCmd.Damage(
            choiceContext, Owner, Amount, DamageProps.nonCardHpLoss, Applier);
    }

    public override async Task AfterDeath(
        PlayerChoiceContext choiceContext, Creature creature, bool wasUnblocked, float deathAnimDelay)
    {
        if (creature != Owner || Applier?.Player is null || CombatState is null)
            return;

        var redDanceShoes = CombatState.CreateCard<RedDanceShoes>(Applier.Player);
        if (Amount >= 8)
        {
            redDanceShoes.UpgradeInternal();
            redDanceShoes.FinalizeUpgradeInternal();
        }
        await CardPileCmd.AddGeneratedCardToCombat(
            redDanceShoes, PileType.Hand, Applier.Player, CardPilePosition.Bottom);
    }
}
