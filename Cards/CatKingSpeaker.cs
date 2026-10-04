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
public sealed class CatKingSpeaker : ModCardTemplate
{
    public override string CustomPortraitPath =>
        "res://SpiritualRealmWalker/images/cards/cat_king_speaker.png";

    public override IEnumerable<CardKeyword> CanonicalKeywords => [CardKeyword.Exhaust];
    protected override IEnumerable<DynamicVar> CanonicalVars =>
        [new DynamicVar("ItemLore", 0).WithTooltip("cards", "SPIRITUAL_REALM_WALKER_CARD_CAT_KING_SPEAKER.loreTitle", "cards", "SPIRITUAL_REALM_WALKER_CARD_CAT_KING_SPEAKER.loreDescription")];
    public CatKingSpeaker() : base(1, CardType.Skill, CardRarity.Uncommon, TargetType.Self, true) { }
    protected override async Task OnPlay(PlayerChoiceContext choiceContext, CardPlay cardPlay)
    {
        var combat = CombatState ?? throw new InvalidOperationException("猫王音箱只能在战斗中使用。");
        var drum = combat.CreateCard<CatKingSpeakerDrum>(Owner);
        var suona = combat.CreateCard<CatKingSpeakerSuona>(Owner);
        if (IsUpgraded)
        {
            drum.UpgradeInternal(); drum.FinalizeUpgradeInternal();
            suona.UpgradeInternal(); suona.FinalizeUpgradeInternal();
        }
        var selected = await CardSelectCmd.FromChooseACardScreen(choiceContext, [drum, suona], Owner, false);
        await PowerCmd.Apply<StrengthPower>(choiceContext, Owner.Creature, (selected ?? throw new InvalidOperationException("必须选择一种音频。")).DynamicVars["Strength"].BaseValue, Owner.Creature, this);
        if (selected is CatKingSpeakerDrum)
            await PowerCmd.Apply<WeakPower>(choiceContext, combat.Enemies.Where(enemy => enemy.IsAlive), 1, Owner.Creature, this);
        else
            await PowerCmd.Apply<CatKingSpeakerSuonaPower>(choiceContext, Owner.Creature, 3, Owner.Creature, this);
    }
    protected override void OnUpgrade() { }
}
