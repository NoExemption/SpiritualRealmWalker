using MegaCrit.Sts2.Core.Commands;
using MegaCrit.Sts2.Core.Entities.Cards;
using MegaCrit.Sts2.Core.GameActions.Multiplayer;
using MegaCrit.Sts2.Core.Localization.DynamicVars;
using MegaCrit.Sts2.Core.Models.Cards;
using MegaCrit.Sts2.Core.ValueProps;
using SpiritualRealmWalker.Characters;
using STS2RitsuLib.Cards.DynamicVars;
using STS2RitsuLib.Interop.AutoRegistration;
using STS2RitsuLib.Scaffolding.Content;

namespace SpiritualRealmWalker.Cards;

/// <summary>以向牌组加入碎屑为代价提供高额防御的道具牌。</summary>
[RegisterCard(typeof(NightWandererCardPool))]
public sealed class SteadfastOrb : ModCardTemplate
{
    public override string CustomPortraitPath =>
        "res://SpiritualRealmWalker/images/cards/steadfast_orb.png";

    public override bool GainsBlock => true;
    protected override IEnumerable<DynamicVar> CanonicalVars =>
        [
            new BlockVar(9, ValueProp.Move),
            new DynamicVar("ItemLore", 0).WithTooltip(
                "cards", "SPIRITUAL_REALM_WALKER_CARD_STEADFAST_ORB.loreTitle",
                "cards", "SPIRITUAL_REALM_WALKER_CARD_STEADFAST_ORB.loreDescription")
        ];

    public SteadfastOrb() : base(1, CardType.Skill, CardRarity.Common, TargetType.Self, true) { }

    protected override async Task OnPlay(PlayerChoiceContext choiceContext, CardPlay cardPlay)
    {
        await CreatureCmd.GainBlock(Owner.Creature, DynamicVars.Block, cardPlay);
        var combat = CombatState ?? throw new InvalidOperationException("沉稳者宝珠只能在战斗中使用。");
        var debris = combat.CreateCard<Debris>(Owner);
        await CardPileCmd.AddGeneratedCardToCombat(
            debris, PileType.Discard, Owner, CardPilePosition.Bottom);
    }

    protected override void OnUpgrade() => DynamicVars.Block.UpgradeValueBy(3);
}
