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
        let card = discardAndDrawCards(1)[0]
        return card.randomNumberTable[options - 2]

    }

    func activatedCommands() -> Int {
        let card = discardAndDrawCards(1)[0]
        return card.activatedCommands
    }

    func initiativeCommands() -> Int {
        let card = discardAndDrawCards(1)[0]
        return card.initiativeCommands
    }

    func atNumber() -> Int {
        let card = discardAndDrawCards(1)[0]
        return card.atNumber
    }

    func combatResult(ncm: Int) -> CombatResult {
        let card = discardAndDrawCards(1)[0]
        let clampedNCM = min(max(ncm, -4), 6)
        return card.combatResults[clampedNCM + 4]
    }

    func hitEffect(experience: ExperienceLevel) -> [HitEffect] {
        let card = discardAndDrawCards(1)[0]
        switch experience {
        case .veteran:
            return card.hitEffects.veteran
        case .line:
            return card.hitEffects.line
        case .green:
            return card.hitEffects.green
        }
    }

    func hqEvent() -> AttemptResult {
        let cards = discardAndDrawCards(1)
        let hasHqEvent = cards.contains { $0.icons.contains(.hqEvent) }
        return hasHqEvent ? .success : .failure
    }

    func infiltration(count: Int) -> AttemptResult {
        let cards = discardAndDrawCards(count)
        let hasInfiltration = cards.contains { $0.icons.contains(.infiltrate) }
        return hasInfiltration ? .success : .failure
    }
    func cover(count: Int) -> AttemptResult {
        let cards = discardAndDrawCards(count)
        let hasCover = cards.contains { $0.icons.contains(.cover) }
        return hasCover ? .success : .failure
    }

    func spotting(count: Int) -> AttemptResult {
        let cards = discardAndDrawCards(count)
        let hasCrosshairs = cards.contains { $0.icons.contains(.crosshairs) }
        return hasCrosshairs ? .success : .failure
    }

    func contact(count: Int) -> AttemptResult {
        let cards = discardAndDrawCards(count)
        let hasContact = cards.contains { $0.icons.contains(.contact) }
        return hasContact ? .success : .failure
    }

    func rally(count: Int) -> AttemptResult {
        let cards = discardAndDrawCards(count)
        let hasRally = cards.contains { $0.icons.contains(.rally) }
        return hasRally ? .success : .failure
    }

    func mines() -> AttemptResult {
        let icons: [ActionCardIcon] = [.burst, .tripleBurst, .short]
        let cards = discardAndDrawCards(3)
        let hasMine = cards.contains { $0.icons.contains { icons.contains($0) } }
        return hasMine ? .success : .failure
    }

    func grenadeAttack(count: Int, canJammed: Bool) -> AttemptResult {
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
    func concentrateFire(count: Int, canJammed: Bool) -> AttemptResult {
        let cards = discardAndDrawCards(count)

        let hasJamIcon = cards.contains { $0.icons.contains(.jam) }
        let grenadeCount = cards.filter { $0.icons.contains(.crosshairs) }.count

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

    func callForFire(count: Int, hasBnFireMission: Bool) -> AttemptResult {
        let cards = discardAndDrawCards(count)

        let hasShort = cards.contains { $0.icons.contains(.short) }
        let hasTripleBurst = cards.contains { $0.icons.contains(.tripleBurst) }
        let hasBurst = cards.contains { $0.icons.contains(.burst) }

        if hasShort {
            return .short
        }
        if hasBnFireMission && hasTripleBurst {
            return .bnFireMisson
        }
        return hasBurst || hasTripleBurst ? .success : .failure
    }
}
