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
public sealed class SpiritCrystal : ModCardTemplate
{
    public override IEnumerable<CardKeyword> CanonicalKeywords => [CardKeyword.Exhaust];
    protected override IEnumerable<DynamicVar> CanonicalVars =>
        [new EnergyVar(2),
         new DynamicVar("ItemLore", 0).WithTooltip("cards", "SPIRITUAL_REALM_WALKER_CARD_SPIRIT_CRYSTAL.loreTitle", "cards", "SPIRITUAL_REALM_WALKER_CARD_SPIRIT_CRYSTAL.loreDescription")];
    public SpiritCrystal() : base(0, CardType.Skill, CardRarity.Common, TargetType.Self, true) { }
    protected override async Task OnPlay(PlayerChoiceContext choiceContext, CardPlay cardPlay)
        => await PlayerCmd.GainEnergy(DynamicVars.Energy.BaseValue, Owner);
    protected override void OnUpgrade() => AddKeyword(CardKeyword.Retain);
}
