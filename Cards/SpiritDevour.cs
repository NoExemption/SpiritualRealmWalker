using MegaCrit.Sts2.Core.Commands;
using MegaCrit.Sts2.Core.Entities.Cards;
using MegaCrit.Sts2.Core.GameActions.Multiplayer;
using MegaCrit.Sts2.Core.Localization.DynamicVars;
using MegaCrit.Sts2.Core.Models.Cards;
using MegaCrit.Sts2.Core.Models.Powers;
using MegaCrit.Sts2.Core.ValueProps;
using SpiritualRealmWalker.Characters;
using STS2RitsuLib.Interop.AutoRegistration;
using STS2RitsuLib.Scaffolding.Content;

namespace SpiritualRealmWalker.Cards;

[RegisterCard(typeof(NightWandererCardPool))]
[RegisterCharacterStarterCard(typeof(YuanshiTianzunCharacter), 1, Order = 4)]
public sealed class SpiritDevour : ModCardTemplate
{
    public override int MaxUpgradeLevel => 0;
    protected override IEnumerable<DynamicVar> CanonicalVars => [new DamageVar(8, ValueProp.Move)];
    public SpiritDevour() : base(1, CardType.Attack, CardRarity.Basic, TargetType.AnyEnemy, true) { }

    protected override async Task OnPlay(PlayerChoiceContext choiceContext, CardPlay cardPlay)
    {
        ArgumentNullException.ThrowIfNull(cardPlay.Target);
        // 最后一击可能触发战斗结束，提前保留本场战斗引用用于完成牌效结算。
        var combat = CombatState ?? throw new InvalidOperationException("噬灵只能在战斗中使用。");
        var attack = await DamageCmd.Attack(DynamicVars.Damage.BaseValue)
            .FromCard(this, cardPlay).Targeting(cardPlay.Target).Execute(choiceContext);
        if (attack.Results.SelectMany(results => results).Any(result =>
                result.Receiver == cardPlay.Target && result.WasTargetKilled))
        {
            await CreatureCmd.Heal(Owner.Creature, 3);
            await PlayerCmd.GainEnergy(1, Owner);
            var dazed = combat.CreateCard<Dazed>(Owner);
            await CardPileCmd.AddGeneratedCardToCombat(dazed, PileType.Discard, Owner, CardPilePosition.Bottom);
        }
        else if (cardPlay.Target.IsAlive)
        {
            await PowerCmd.Apply<WeakPower>(choiceContext, cardPlay.Target, 1, Owner.Creature, this);
        }
    }
}
