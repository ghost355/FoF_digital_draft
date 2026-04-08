// ActionDeckEngine.swift

enum AttemptResult: String {

    case success, failure
    case jam, short, mines
    case criticalHit, bnFireMisson
}

enum AttemptType {
    case none
    case random(for: Int)
    case activationCommands
    case initiativeCommands
    case atNumber
    case combatResult(ncm: Int)
    case hitEffect(experience: ExperienceLevel)
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
}

final class ActionDeckEngine {
    var deck: ActionDeck

    var exhortAvailable = false

    var lastAttempt: AttemptType?

    func exhort() -> AttemptResult? {
        guard exhortAvailable, let attempt = lastAttempt else { return nil }
        defer {
            exhortAvailable = false
            lastAttempt = nil
        }
        switch attempt {
        case .infiltration:
            return infiltration(count: 1)
        case .cover:
            return cover(count: 1)
        case .spotting:
            return spotting(count: 1)
        case .contact:
            return contact(count: 1)
        case .rally:
            return rally(count: 1)
        case .grenade(_, let canJam):
            return grenadeAttack(count: 1, canJammed: canJam)
        case .concentrate(_, let canJam):
            return concentrateFire(count: 1, canJammed: canJam)
        case .callForFire(_, let bnFireMission):
            return callForFire(count: 1, hasBnFireMission: bnFireMission)
        default:
            return nil
        }
    }

    private func saveForExhort(_ attempt: AttemptType) {
        guard !exhortAvailable else { return }
        lastAttempt = attempt
        exhortAvailable = true
    }

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
        let result: AttemptResult = hasInfiltration ? .success : .failure
        if result == .failure {
            saveForExhort(.infiltration(cards: count))
        }
        return result
    }

    func cover(count: Int) -> AttemptResult {
        let cards = discardAndDrawCards(count)
        let hasCover = cards.contains { $0.icons.contains(.cover) }
        let result: AttemptResult = hasCover ? .success : .failure
        if result == .failure {
            saveForExhort(.cover(cards: count))
        }
        return result
    }

    func spotting(count: Int) -> AttemptResult {
        let cards = discardAndDrawCards(count)
        let hasCrosshairs = cards.contains { $0.icons.contains(.crosshairs) }
        let result: AttemptResult = hasCrosshairs ? .success : .failure
        if result == .failure {
            saveForExhort(.spotting(cards: count))
        }
        return result
    }

    func contact(count: Int) -> AttemptResult {
        let cards = discardAndDrawCards(count)
        let hasContact = cards.contains { $0.icons.contains(.contact) }
        let result: AttemptResult = hasContact ? .success : .failure
        if result == .failure {
            saveForExhort(.contact(cards: count))
        }
        return result
    }

    func rally(count: Int) -> AttemptResult {
        let cards = discardAndDrawCards(count)
        let hasRally = cards.contains { $0.icons.contains(.rally) }
        let result: AttemptResult = hasRally ? .success : .failure
        if result == .failure {
            saveForExhort(.rally(cards: count))
        }
        return result
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
        let result: AttemptResult
        switch grenadeCount {
        case 0:
            result = .failure
        case 1:
            result = .success
        default:
            result = .criticalHit
        }

        if result == .failure {
            saveForExhort(.grenade(cards: count, canJam: canJammed))
        }

        return result

    }

    func concentrateFire(count: Int, canJammed: Bool) -> AttemptResult {
        let cards = discardAndDrawCards(count)

        let hasJamIcon = cards.contains { $0.icons.contains(.jam) }
        let grenadeCount = cards.filter { $0.icons.contains(.crosshairs) }.count

        if canJammed && hasJamIcon {
            return .jam
        }
        let result: AttemptResult
        switch grenadeCount {
        case 0:
            result = .failure
        case 1:
            result = .success
        default:
            result = .criticalHit
        }
        if result == .failure {
            saveForExhort(.concentrate(cards: count, canJam: canJammed))
        }

        return result
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
        let result: AttemptResult = hasBurst || hasTripleBurst ? .success : .failure
        if result == .failure {
            saveForExhort(.callForFire(cards: count, hasBnFireMission: hasBnFireMission))
        }
        return result
    }
}
