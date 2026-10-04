using MegaCrit.Sts2.Core.Commands;
using MegaCrit.Sts2.Core.Entities.Cards;
using MegaCrit.Sts2.Core.GameActions.Multiplayer;
using MegaCrit.Sts2.Core.Localization.DynamicVars;
using MegaCrit.Sts2.Core.Models.Powers;
using SpiritualRealmWalker.Characters;
using STS2RitsuLib.Cards.DynamicVars;
using STS2RitsuLib.Interop.AutoRegistration;
using STS2RitsuLib.Scaffolding.Content;

namespace SpiritualRealmWalker.Cards;

/// <summary>使战场内敌我双方中毒的群体道具牌。</summary>
[RegisterCard(typeof(NightWandererCardPool))]
public sealed class HeavenlyToadIncenseBurner : ModCardTemplate
{
    public override string CustomPortraitPath =>
        "res://SpiritualRealmWalker/images/cards/heavenly_toad_incense_burner.png";

    protected override IEnumerable<DynamicVar> CanonicalVars =>
        [
            new DynamicVar("EnemyPoison", 3),
            new DynamicVar("SelfPoison", 2),
            new DynamicVar("ItemLore", 0).WithTooltip(
                "cards", "SPIRITUAL_REALM_WALKER_CARD_HEAVENLY_TOAD_INCENSE_BURNER.loreTitle",
                "cards", "SPIRITUAL_REALM_WALKER_CARD_HEAVENLY_TOAD_INCENSE_BURNER.loreDescription")
        ];

    public HeavenlyToadIncenseBurner() : base(1, CardType.Skill, CardRarity.Common, TargetType.AllEnemies, true) { }

    protected override async Task OnPlay(PlayerChoiceContext choiceContext, CardPlay cardPlay)
    {
        var combat = CombatState ?? throw new InvalidOperationException("天蟾香炉只能在战斗中使用。");
        var livingEnemies = combat.Enemies.Where(enemy => enemy.IsAlive).ToList();
        await PowerCmd.Apply<PoisonPower>(
            choiceContext, livingEnemies, DynamicVars["EnemyPoison"].BaseValue, Owner.Creature, this);
        await PowerCmd.Apply<PoisonPower>(
            choiceContext, Owner.Creature, DynamicVars["SelfPoison"].BaseValue, Owner.Creature, this);
    }

    protected override void OnUpgrade() => DynamicVars["EnemyPoison"].UpgradeValueBy(1);
}
