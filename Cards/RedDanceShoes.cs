using MegaCrit.Sts2.Core.Commands;
using MegaCrit.Sts2.Core.Entities.Cards;
using MegaCrit.Sts2.Core.GameActions.Multiplayer;
using MegaCrit.Sts2.Core.Localization.DynamicVars;
using MegaCrit.Sts2.Core.Models.Powers;
using SpiritualRealmWalker.Characters;
using SpiritualRealmWalker.Powers;
using STS2RitsuLib.Cards.DynamicVars;
using STS2RitsuLib.Interop.AutoRegistration;
using STS2RitsuLib.Scaffolding.Content;

namespace SpiritualRealmWalker.Cards;

[RegisterCard(typeof(NightWandererCardPool))]
public sealed class RedDanceShoes : ModCardTemplate
{
    public override string CustomPortraitPath =>
        "res://SpiritualRealmWalker/images/cards/red_dance_shoes.png";

    protected override IEnumerable<DynamicVar> CanonicalVars =>
        [
            new DynamicVar("ItemLore", 0).WithTooltip(
                "cards", "SPIRITUAL_REALM_WALKER_CARD_RED_DANCE_SHOES.loreTitle",
                "cards", "SPIRITUAL_REALM_WALKER_CARD_RED_DANCE_SHOES.loreDescription")
        ];

    public RedDanceShoes() : base(2, CardType.Power, CardRarity.Uncommon, TargetType.Self, true) { }

    protected override async Task OnPlay(PlayerChoiceContext choiceContext, CardPlay cardPlay)
    {
        var combat = CombatState ?? throw new InvalidOperationException("红舞鞋只能在战斗中使用。");
        var pursuit = combat.CreateCard<RedDanceShoesPursuit>(Owner);
        var wear = combat.CreateCard<RedDanceShoesWear>(Owner);
        if (IsUpgraded)
        {
            pursuit.UpgradeInternal();
            pursuit.FinalizeUpgradeInternal();
            wear.UpgradeInternal();
            wear.FinalizeUpgradeInternal();
        }

        var selected = await CardSelectCmd.FromChooseACardScreen(
            choiceContext, [pursuit, wear], Owner, false);
        switch (selected)
        {
            case RedDanceShoesPursuit:
                await CardPileCmd.AddGeneratedCardToCombat(
                    pursuit, PileType.Hand, Owner, CardPilePosition.Bottom);
                break;
            case RedDanceShoesWear:
                decimal dexterity = wear.DynamicVars["Dexterity"].BaseValue;
                await PowerCmd.Apply<DexterityPower>(
                    choiceContext, Owner.Creature, dexterity, Owner.Creature, this);
                await PowerCmd.Apply<RedDanceShoesWearPower>(
                    choiceContext, Owner.Creature, dexterity, Owner.Creature, this);
                break;
        }
    }

    protected override void OnUpgrade() { }
}
