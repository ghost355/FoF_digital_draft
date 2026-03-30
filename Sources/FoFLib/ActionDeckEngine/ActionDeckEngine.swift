// ActionDeckEngine.swift

public enum AttemptResult {
    case success, failure
    case jam, short, mines
    case criticalHit, bnFireMisson
}

public enum AttempType {
    case none
    case random(for: Int)
    case activationCommands
    case initiativeCommands
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
    }
    public func randomNumber(_ options: Int) -> Int {
        let card = helperDrawOneCard()
        return card.randomNumber(for: options)

    }

    public func activatedCommands() -> Int {
        let card = helperDrawOneCard()
        return card.activatedCommands
    }

    public func initiativeCommands() -> Int {
        let card = helperDrawOneCard()
        return card.initiativeCommands
    }

    public func atNumber() -> Int {
        let card = helperDrawOneCard()
        return card.atNumber
    }

    public func hqEvent() -> AttemptResult {
        let card = helperDrawOneCard()
        if card.hasIcon(.hqEvent) {
            return .success
        }
        return .failure
    }

    public func mines() -> AttemptResult {
        deck.discardHand()
        deck.draw(count: 3)
        let icons: [ActionCardIcon] = [.burst, .tripleBurst, .short]
        let cards = deck.currentHand
        if cards.contains(where: { card in card.icons.contains { icons.contains($0) } }) {
            return .success
        }
        return .failure
    }

    private func helperDrawOneCard() -> ActionCard {
        deck.discardHand()
        deck.draw(count: 1)
        return deck.currentHand[0]
    }
}
