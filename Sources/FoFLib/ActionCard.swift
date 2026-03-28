// ActionCard.swift
import Foundation

// MARK: - Action Attempt Icons (2.8.2)
enum ActionIcon: String, Codable {
    case infiltrate  // Infiltrate success
    case contact  // Enemy contact during PC Evaluation
    case cover  // Seek Cover or Rally success
    case crosshairs  // Spot or Concentrate Fire success
    case grenade  // Grenade Attack success
    case burst  // Call for Fire success / triggered mine
    case tripleBurst  // Call for Fire success / Battalion Fire (if available) / triggered mine
    case short  // Call for Fire off-target / triggered mine
    case jam  // Catastrophic failure (for Grenade Attack  or Concentrated Fire)
    case hqEvent  // Higher HQ Event
}

// MARK: - Combat Resolution Results (6.4.2)
enum CombatResult: String, Codable {
    case miss
    case pin
    case hit
}

struct CombatResultEntry: Codable {
    let ncm: Int
    let result: CombatResult
}

// MARK: - Hit Effect Letters (6.4.3)
enum HitEffect: String, Codable {
    case casualty = "C"
    case paralyzed = "P"
    case litter = "L"
    case fire = "F"
    case assault = "A"
}

// MARK: - Experience Level for Hit Effects
enum HitEffectGroup: String, Codable {
    case veteran = "Veteran"
    case line = "Line"
    case green = "Green"
}

// MARK: - Hit Effects by Experience Level
struct HitEffects: Codable {
    let veteran: [HitEffect]
    let line: [HitEffect]
    let green: [HitEffect]
}

// MARK: - Random Number Section (2.8.5)
typealias RandomNumbersTable = [Int]

// MARK: - Action Card
struct ActionCard: Codable {
    let id: Int  // Номер карты в колоде
    let activatedCommands: Int
    let initiativeCommands: Int
    let icons: [ActionIcon]
    let combatResults: [CombatResultEntry]
    let hitEffects: HitEffects
    let randomNumberTable: RandomNumbersTable

    // MARK: - Вычисляемые свойства

    /// Получить случайное число для указанного количества опций
    func getRandomNumber(for options: Int) -> Int {
        return randomNumberTable[options - 2]
    }

    /// Проверить содержит ли карта указанную иконку
    func hasIcon(_ icon: ActionIcon) -> Bool {
        icons.contains(icon)
    }
}

// MARK: - Action Deck
class ActionDeck: Codable {
    var draw: [ActionCard]
    var discard: [ActionCard] = []
    var hand: [ActionCard] = []
    var reshuffleCardId: Int = 51

    init(deck: [ActionCard]) {
        draw = deck.shuffled()
    }

    private func drawOneCard() -> ActionCard {
        var card = draw.removeLast()
        if card.id == reshuffleCardId {
            reshuffleDeck(reshuffleCard: card)
            // тянем другую карту (уже гарантированно не карта перемешинвания)
            card = drawOneCard()
        }
        return card
    }

    private func reshuffleDeck(reshuffleCard: ActionCard) {
        // Кладем сброс в колоду, перемешиваем все, и помещаем карту сброса в случайное место в нижнюю половину колоды
        draw += discard
        discard.removeAll()
        draw.shuffle()
        let randomIndexBottomHalf = Int.random(in: 0..<(draw.count / 2))
        draw.insert(reshuffleCard, at: randomIndexBottomHalf)
    }

    /// Взятьtop N карт и поместить их в Руку
    func draw(count: Int) {
        for _ in (0..<count) {
            hand.append(drawOneCard())
        }
    }

    func discardHand() {
        discard += hand
        hand.removeAll()
    }
}

// MARK: - Action Draw Result (используется в игре)
struct ActionDrawResult: Codable {
    let cards: [ActionCard]
    let icons: [ActionIcon]
    let combatResult: CombatResult?
    let hitEffects: [HitEffect]
    let randomNumber: Int?

    var hasIcon: (ActionIcon) -> Bool {
        { icons.contains($0) }
    }
}

// MARK: - JSON Keys для парсинга
extension ActionCard {
    enum CodingKeys: String, CodingKey {
        case id
        case activatedCommands = "activated_commands"
        case initiativeCommands = "initiative_commands"
        case icons = "icons"
        case combatResults = "combat_results"  // было combatResolution
        case hitEffects = "hit_effects"
        case randomNumberTable = "random_number_table"
    }
}
