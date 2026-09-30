using MegaCrit.Sts2.Core.Commands;
using MegaCrit.Sts2.Core.Combat;
using MegaCrit.Sts2.Core.Entities.Creatures;
using MegaCrit.Sts2.Core.Entities.Powers;
using MegaCrit.Sts2.Core.GameActions.Multiplayer;
using MegaCrit.Sts2.Core.ValueProps;
using STS2RitsuLib.Interop.AutoRegistration;
using STS2RitsuLib.Scaffolding.Content;
namespace SpiritualRealmWalker.Powers;

[RegisterPower]
public sealed class CatKingSpeakerSuonaPower : ModPowerTemplate
{
    public override PowerType Type => PowerType.Debuff;
    public override PowerStackType StackType => PowerStackType.Counter;
    public override PowerInstanceType InstanceType => PowerInstanceType.Instanced;

    public override async Task AfterSideTurnEnd(
        PlayerChoiceContext choiceContext, CombatSide side, IEnumerable<Creature> creatures)
    {
        if (side != Owner.Side || !Owner.IsAlive)
            return;
        // 使用当回合的回合结束也消耗一次计时，共计三个玩家回合。
        if (Amount > 1)
        {
            await PowerCmd.ModifyAmount(choiceContext, this, -1, Owner, null, false);
            return;
        }
        await PowerCmd.Remove(this);
        if (CombatState?.Enemies.Any(enemy => enemy.IsAlive) == true)
            await CreatureCmd.Damage(choiceContext, Owner, 10, DamageProps.nonCardHpLoss, Owner);
    }
}