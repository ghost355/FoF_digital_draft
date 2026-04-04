// TestActionDeckEngine.swift

public final class TestActionDeckEngine: @unchecked Sendable {
    private var engine: ActionDeckEngine
    private var cards: [ActionCard]

    public init() {
        cards = loadJSON("actionDeck", as: [ActionCard].self, from: .module)
        engine = ActionDeckEngine(cards: cards)
    }

    // MARK: - Card Info

    public func cardInfo(id: Int) -> String {
        guard let card = cards.first(where: { $0.id == id }) else {
            return "Card not found"
        }
        
        let random = card.randomNumberTable.enumerated().map { index, value in
            "\(index + 2)/\(value)"
        }.joined(separator: ", ")

        let combat = card.combatResults.enumerated().map { index, value in "\(index - 4): \(value)"
        }
        .joined(separator: ", ")

        return String(
            """
            =====================================================
            Card #\(card.id) 
            AC: \(card.activatedCommands) / IC: \(card.initiativeCommands) | AT: \(card.atNumber)
            Icons: \(card.icons.map{ icon in icon.rawValue})
            R#: \(random)
            Combat Table: \(combat)
            Vet:\(card.hitEffects.veteran.map{$0.rawValue}) Line:\(card.hitEffects.line.map{$0.rawValue}) Green:\(card.hitEffects.green.map{$0.rawValue})
            =====================================================
            """
        )
    }

    public func getHand() -> String {
        let hand = engine.deck.currentHand
        if hand.isEmpty {
            return "Hand is empty"
        }
        return hand.map { cardInfo(id: $0.id) }.joined(separator: "\n")
    }

    public func handCardIds() -> [Int] {
        return engine.deck.currentHand.map { $0.id }
    }

    // MARK: - Deck Status

    public func deckStatus() -> String {
        return """
            Deck Status:
            - Draw: \(engine.deck.drawDeckCount)
            - Hand: \(engine.deck.handCount)
            - Discard: \(engine.deck.discardPileCount)
            - Total: \(engine.deck.totalCount)
            """
    }

    // MARK: - Random Number

    public func getRandom(for option: Int) -> Int {
        engine.randomNumber(option)
    }

    // MARK: - Check Methods (return String?)

    private func resultToString(_ result: AttemptResult) -> String {
        switch result {
        case .success: return "success"
        case .failure: return "failure"
        case .jam: return "jam"
        case .short: return "short"
        case .mines: return "mines"
        case .criticalHit: return "criticalHit"
        case .bnFireMisson: return "bnFireMisson"
        }
    }

    public func checkInfiltration(count: Int) -> String? {
        let result: AttemptResult = engine.infiltration(count: count)
        return resultToString(result)
    }

    public func infiltration(count: Int) -> String? {
        return checkInfiltration(count: count)
    }

    public func cover(count: Int) -> String? {
        let result: AttemptResult = engine.cover(count: count)
        return resultToString(result)
    }

    public func rally(count: Int) -> String? {
        let result: AttemptResult = engine.rally(count: count)
        return resultToString(result)
    }

    public func spotting(count: Int) -> String? {
        let result: AttemptResult = engine.spotting(count: count)
        return resultToString(result)
    }

    public func contact(count: Int) -> String? {
        let result: AttemptResult = engine.contact(count: count)
        return resultToString(result)
    }

    public func hqEvent() -> String? {
        let result: AttemptResult = engine.hqEvent()
        return resultToString(result)
    }

    public func mines() -> String? {
        let result: AttemptResult = engine.mines()
        return resultToString(result)
    }

    public func grenadeAttack(count: Int, canJam: Bool) -> String? {
        let result: AttemptResult = engine.grenadeAttack(count: count, canJammed: canJam)
        return resultToString(result)
    }

    public func concentrateFire(count: Int, canJam: Bool) -> String? {
        let result: AttemptResult = engine.concentrateFire(count: count, canJammed: canJam)
        return resultToString(result)
    }

    public func callForFire(count: Int, hasBnFireMission: Bool) -> String? {
        let result: AttemptResult = engine.callForFire(count: count, hasBnFireMission: hasBnFireMission)
        return resultToString(result)
    }

    // MARK: - Combat Methods

    private func combatResultToString(_ result: CombatResult) -> String {
        switch result {
        case .hit: return "hit"
        case .pin: return "pin"
        case .miss: return "miss"
        }
    }

    public func combatResult(ncm: Int) -> String? {
        let result = engine.combatResult(ncm: ncm)
        return combatResultToString(result)
    }

    public func hitEffect(experience: String) -> String? {
        let exp: ExperienceLevel
        switch experience.lowercased() {
        case "veteran", "vet", "v": exp = .veteran
        case "line", "l": exp = .line
        case "green", "g": exp = .green
        default: return nil
        }
        let effects = engine.hitEffect(experience: exp)
        return effects.map { $0.rawValue }.joined(separator: ", ")
    }
}
