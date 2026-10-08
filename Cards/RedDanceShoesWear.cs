using MegaCrit.Sts2.Core.Entities.Cards;
using MegaCrit.Sts2.Core.GameActions.Multiplayer;
using MegaCrit.Sts2.Core.Localization.DynamicVars;
using SpiritualRealmWalker.Characters;
using STS2RitsuLib.Interop.AutoRegistration;
using STS2RitsuLib.Scaffolding.Content;

namespace SpiritualRealmWalker.Cards;

[RegisterCard(typeof(NightWandererCardPool))]
public sealed class RedDanceShoesWear : ModCardTemplate
{
    public override string CustomPortraitPath =>
        "res://SpiritualRealmWalker/images/cards/red_dance_shoes_wear.png";

    protected override IEnumerable<DynamicVar> CanonicalVars => [new DynamicVar("Dexterity", 2)];

    public RedDanceShoesWear() : base(0, CardType.Skill, CardRarity.Token, TargetType.Self, true) { }
    protected override Task OnPlay(PlayerChoiceContext choiceContext, CardPlay cardPlay) => Task.CompletedTask;
    protected override void OnUpgrade() => DynamicVars["Dexterity"].UpgradeValueBy(1);
}
