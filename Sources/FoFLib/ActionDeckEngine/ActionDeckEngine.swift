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
    case combatResult(ncm: Int)
    case hitEffect
    case hqEvent
    case infiltration(cards: Int)
    case cover(cards: Int)
    case spotting(cards: Int)
    case contact(cards: Int)
    case rally(cards: Int)
    case mines
    case grenade(cards: Int, canJam: Bool)
    case concentrate(cards: Int, canJam: Bool)
    case callForFire(cards: Int, hasBnFireMission: Bool)
    // не забыть про Exhort
}

final class ActionDeckEngine {
    var deck: ActionDeck

    init(cards: [ActionCard]) {
        deck = ActionDeck(cards: cards)
    }

    private func discardAndDrawCards(_ count: Int) -> [ActionCard] {
        deck.discardHand()
        deck.draw(count: count)
        return deck.currentHand
    }

    func randomNumber(_ options: Int) -> Int {
        let cards = discardAndDrawCards(1)
        return cards[0].randomNumber(for: options)

    }

    func activatedCommands() -> Int {
        let cards = discardAndDrawCards(1)
        return cards[0].activatedCommands
    }

    func initiativeCommands() -> Int {
        let cards = discardAndDrawCards(1)
        return cards[0].initiativeCommands
    }

    func atNumber() -> Int {
        let cards = discardAndDrawCards(1)
        return cards[0].atNumber
    }

    func combatResult(ncm: Int) -> CombatResult {
        let cards = discardAndDrawCards(1)
        return cards[0].combatResult(ncm: ncm)
    }

    func hitEffect(experience: ExperienceLevel) -> [HitEffect] {
        let cards = discardAndDrawCards(1)
        return cards[0].hitEffects(experience: experience)
    }

    func hqEvent() -> AttemptResult {
        let cards = discardAndDrawCards(1)
        if cards[0].hasIcon(.hqEvent) {
            return .success
        }
        return .failure
    }

    func infiltration(count: Int) -> AttemptResult {
        let icons: [ActionCardIcon] = [.infiltrate]
        let cards = discardAndDrawCards(count)
        if cards.contains(where: { card in card.icons.contains { icons.contains($0) } }) {
            return .success
        }
        return .failure
    }
    func cover(count: Int) -> AttemptResult {
        let icons: [ActionCardIcon] = [.cover]
        let cards = discardAndDrawCards(count)
        if cards.contains(where: { card in card.icons.contains { icons.contains($0) } }) {
            return .success
        }
        return .failure
    }

    func spotting(count: Int) -> AttemptResult {
        let icons: [ActionCardIcon] = [.crosshairs]
        let cards = discardAndDrawCards(count)
        if cards.contains(where: { card in card.icons.contains { icons.contains($0) } }) {
            return .success
        }
        return .failure
    }

    func contact(count: Int) -> AttemptResult {
        let icons: [ActionCardIcon] = [.contact]
        let cards = discardAndDrawCards(count)
        if cards.contains(where: { card in card.icons.contains { icons.contains($0) } }) {
            return .success
        }
        return .failure
    }

    func rally(count: Int) -> AttemptResult {
        let icons: [ActionCardIcon] = [.rally]
        let cards = discardAndDrawCards(count)
        if cards.contains(where: { card in card.icons.contains { icons.contains($0) } }) {
            return .success
        }
        return .failure
    }

    func mines() -> AttemptResult {
        let icons: [ActionCardIcon] = [.burst, .tripleBurst, .short]
        let cards = discardAndDrawCards(3)
        if cards.contains(where: { card in card.icons.contains { icons.contains($0) } }) {
            return .success
        }
        return .failure
    }

    func grenade(count: Int, canJammed: Bool) -> AttemptResult {
        let cards = discardAndDrawCards(count)

        let hasJamIcon = cards.contains { $0.icons.contains(.jam) }
        let grenadeCount = cards.filter { $0.icons.contains(.grenade) }.count

        if canJammed && hasJamIcon {
            return .jam
        }
        switch grenadeCount {
        case 0:
            return .failure
        case 1:
            return .success
        default:
            return .criticalHit
        }
    }
}
