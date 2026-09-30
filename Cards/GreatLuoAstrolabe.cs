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
public sealed class GreatLuoAstrolabe : ModCardTemplate
{
    protected override IEnumerable<DynamicVar> CanonicalVars =>
        [new DynamicVar("Cards", 3), new DynamicVar("ItemLore", 0).WithTooltip("cards", "SPIRITUAL_REALM_WALKER_CARD_GREAT_LUO_ASTROLABE.loreTitle", "cards", "SPIRITUAL_REALM_WALKER_CARD_GREAT_LUO_ASTROLABE.loreDescription")];
    public GreatLuoAstrolabe() : base(2, CardType.Power, CardRarity.Rare, TargetType.Self, true) { }
    protected override async Task OnPlay(PlayerChoiceContext choiceContext, CardPlay cardPlay)
        => await PowerCmd.Apply<GreatLuoAstrolabePower>(choiceContext, Owner.Creature, DynamicVars["Cards"].BaseValue, Owner.Creature, this);
    protected override void OnUpgrade() => DynamicVars["Cards"].UpgradeValueBy(1);
}