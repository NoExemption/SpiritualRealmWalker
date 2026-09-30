using MegaCrit.Sts2.Core.Commands;
using MegaCrit.Sts2.Core.CardSelection;
using MegaCrit.Sts2.Core.Combat;
using MegaCrit.Sts2.Core.Entities.Cards;
using MegaCrit.Sts2.Core.Entities.Players;
using MegaCrit.Sts2.Core.Entities.Powers;
using MegaCrit.Sts2.Core.GameActions.Multiplayer;
using MegaCrit.Sts2.Core.Localization;
using STS2RitsuLib.Interop.AutoRegistration;
using STS2RitsuLib.Scaffolding.Content;
namespace SpiritualRealmWalker.Powers;

[RegisterPower]
public sealed class GreatLuoAstrolabePower : ModPowerTemplate
{
    public override PowerType Type => PowerType.Buff;
    public override PowerStackType StackType => PowerStackType.Counter;
    public override PowerInstanceType InstanceType => PowerInstanceType.Instanced;

    public override async Task BeforeHandDraw(Player player, PlayerChoiceContext choiceContext, ICombatState combatState)
    {
        if (player != Owner.Player || !Owner.IsAlive)
            return;
        // 原版抽牌堆列表从顶部开始；只查看现有牌，不触发洗牌。
        var cards = CardPile.Get(PileType.Draw, player)?.Cards.Take(Amount).ToList();
        if (cards is null || cards.Count == 0)
            return;
        Flash();
        var prefs = new CardSelectorPrefs(
            new LocString("powers", "SPIRITUAL_REALM_WALKER_POWER_GREAT_LUO_ASTROLABE_POWER.selectionPrompt"), 1);
        var chosen = (await CardSelectCmd.FromSimpleGrid(choiceContext, cards, player, prefs)).Single();
        await CardPileCmd.Add(chosen, PileType.Hand, CardPilePosition.Bottom, this, false);
        await CardPileCmd.Add(cards.Where(card => card != chosen), PileType.Discard, CardPilePosition.Bottom, this, false);
    }
}