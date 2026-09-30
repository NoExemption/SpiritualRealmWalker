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
public sealed class CatKingSpeakerSuona : ModCardTemplate
{
    protected override IEnumerable<DynamicVar> CanonicalVars => [new DynamicVar("Strength", 4)];
    public CatKingSpeakerSuona() : base(0, CardType.Skill, CardRarity.Token, TargetType.Self, true) { }
    protected override Task OnPlay(PlayerChoiceContext choiceContext, CardPlay cardPlay) => Task.CompletedTask;
    protected override void OnUpgrade() => DynamicVars["Strength"].UpgradeValueBy(1);
}