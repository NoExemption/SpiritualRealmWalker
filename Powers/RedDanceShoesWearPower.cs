using MegaCrit.Sts2.Core.Commands;
using MegaCrit.Sts2.Core.Combat;
using MegaCrit.Sts2.Core.Entities.Cards;
using MegaCrit.Sts2.Core.Entities.Creatures;
using MegaCrit.Sts2.Core.Entities.Powers;
using MegaCrit.Sts2.Core.GameActions.Multiplayer;
using MegaCrit.Sts2.Core.Localization.DynamicVars;
using MegaCrit.Sts2.Core.Models.Powers;
using MegaCrit.Sts2.Core.ValueProps;
using SpiritualRealmWalker.Cards;
using STS2RitsuLib.Interop.AutoRegistration;
using STS2RitsuLib.Scaffolding.Content;

namespace SpiritualRealmWalker.Powers;

[RegisterPower]
public sealed class RedDanceShoesWearPower : ModPowerTemplate
{
    public override PowerType Type => PowerType.Buff;
    public override PowerStackType StackType => PowerStackType.Counter;
    protected override IEnumerable<DynamicVar> CanonicalVars =>
        [
            new DynamicVar("Turns", 3),
            new DynamicVar("Block", 6),
            new DynamicVar("BlockTriggers", 3),
            new DynamicVar("Expires", 0)
        ];

    public override async Task BeforeSideTurnStart(
        PlayerChoiceContext choiceContext, CombatSide side,
        IReadOnlyList<Creature> creatures, ICombatState combatState)
    {
        if (side != Owner.Side || !Owner.IsAlive || Owner.Player is null)
            return;

        decimal turns = DynamicVars["Turns"].BaseValue - 1;
        if (turns <= 0)
        {
            var dance = combatState.CreateCard<DanceTogether>(Owner.Player);
            await CardPileCmd.AddGeneratedCardToCombat(
                dance, PileType.Hand, Owner.Player, CardPilePosition.Bottom);
            DynamicVars["Expires"].BaseValue = 1;
            Flash();
        }
        DynamicVars["Turns"].BaseValue = Math.Max(0, turns);
    }

    public override async Task AfterSideTurnEnd(
        PlayerChoiceContext choiceContext, CombatSide side, IEnumerable<Creature> creatures)
    {
        if (side != Owner.Side)
            return;

        if (DynamicVars["Expires"].BaseValue > 0)
        {
            await PowerCmd.Apply<DexterityPower>(
                choiceContext, Owner, -Amount, Owner, null, false);

            if (Owner.Player is not null && CombatState is not null)
            {
                var redDanceShoes = CombatState.CreateCard<RedDanceShoes>(Owner.Player);
                if (Amount >= 3)
                {
                    redDanceShoes.UpgradeInternal();
                    redDanceShoes.FinalizeUpgradeInternal();
                }
                await CardPileCmd.AddGeneratedCardToCombat(
                    redDanceShoes, PileType.Hand, Owner.Player, CardPilePosition.Bottom);
            }

            await PowerCmd.Remove(this);
            return;
        }

        if (!Owner.IsAlive || DynamicVars["BlockTriggers"].BaseValue <= 0)
            return;

        await CreatureCmd.GainBlock(
            Owner, DynamicVars["Block"].BaseValue, ValueProp.Unpowered, null, false);
        DynamicVars["BlockTriggers"].BaseValue -= 1;
        Flash();
    }
}
