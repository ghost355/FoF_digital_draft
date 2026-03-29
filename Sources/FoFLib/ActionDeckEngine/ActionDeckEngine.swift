// ActionDeckEngine.swift

enum AttemptResult {
    case success, failure
    case jam, short, mines
    case criticalHit, bnFireMisson
}

final public class ActionDeckEngine {

    private var actionCardDeck: ActionDeck
    public init() {
        let cards: [ActionCard] = loadJSON(
            "actionDeck", as: [ActionCard].self, from: .module)
        let deck = ActionDeck(actionDeck: cards)
        actionCardDeck = deck
        print(actionCardDeck.count)
    }

}
