// ActionDeckEngine.swift

enum AttemptResult {
    case success, failure
    case jam, short, mines
    case criticalHit, bnFireMisson
}

enum AttempType {
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

final class ActionDeckEngine {
    var deck: ActionDeck

    init(cards: [ActionCard]) {
        deck = ActionDeck(cards: cards)
    }
    func randomNumber(_ options: Int) -> Int {
        let card = helperDrawOneCard()
        return card.randomNumber(for: options)

    }

    func activatedCommands() -> Int {
        let card = helperDrawOneCard()
        return card.activatedCommands
    }

    func initiativeCommands() -> Int {
        let card = helperDrawOneCard()
        return card.initiativeCommands
    }

    func atNumber() -> Int {
        let card = helperDrawOneCard()
        return card.atNumber
    }

    func hqEvent() -> AttemptResult {
        let card = helperDrawOneCard()
        if card.hasIcon(.hqEvent) {
            return .success
        }
        return .failure
    }

    func mines() -> AttemptResult {
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
