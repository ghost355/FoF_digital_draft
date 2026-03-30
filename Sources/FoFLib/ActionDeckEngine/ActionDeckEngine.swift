// ActionDeckEngine.swift

public enum AttemptResult {
    case success, failure
    case jam, short, mines
    case criticalHit, bnFireMisson
}

public enum AttempType {
    case none
    case random(for: Int)
    case activated
    case initiative
    case atNumber
    case combatResult
    case hitResult
    case hqEvent
    case infiltration(cards: Int)
    case cover(cards: Int)
    case spotting(cards: Int)
    case contact(cards: Int)
    case grenade(cards: Int, canJam: Bool)
    case concentrate(cards: Int, canJam: Bool)
    case callForFire(cards: Int, hasBnFireMission: Bool)
    case mines
}

public final class ActionDeckEngine {
    private var deck: ActionDeck

    public init() {
        let cards: [ActionCard] = loadJSON(
            "actionDeck", as: [ActionCard].self, from: .module
        )
        let actionDeck = ActionDeck(cards: cards)
        deck = actionDeck
        print(deck.count)
    }

}
