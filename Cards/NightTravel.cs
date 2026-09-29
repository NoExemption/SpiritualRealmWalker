using MegaCrit.Sts2.Core.Commands;
using MegaCrit.Sts2.Core.Entities.Cards;
using MegaCrit.Sts2.Core.GameActions.Multiplayer;
using MegaCrit.Sts2.Core.Models.Powers;
using SpiritualRealmWalker.Characters;
using STS2RitsuLib.Interop.AutoRegistration;
using STS2RitsuLib.Scaffolding.Content;

namespace SpiritualRealmWalker.Cards;

[RegisterCard(typeof(NightWandererCardPool))]
[RegisterCharacterStarterCard(typeof(YuanshiTianzunCharacter), 1, Order = 3)]
public sealed class NightTravel : ModCardTemplate
{
    // 升级方案尚未确定，避免出现没有效果的升级选项。
    public override int MaxUpgradeLevel => 0;
    public override IEnumerable<CardKeyword> CanonicalKeywords => [CardKeyword.Retain, CardKeyword.Exhaust];
    public NightTravel() : base(1, CardType.Skill, CardRarity.Basic, TargetType.Self, true) { }

    protected override async Task OnPlay(PlayerChoiceContext choiceContext, CardPlay cardPlay)
    {
        await PowerCmd.Apply<IntangiblePower>(choiceContext, Owner.Creature, 1, Owner.Creature, this);
    }
}
