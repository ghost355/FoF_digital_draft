// ActionCard.swift

struct ActionCard: Codable {
    let id: Int
    let activatedCommands: Int
    let initiativeCommands: Int
    let atNumber: Int
    let icons: [ActionCardIcon]
    let combatResults: [CombatResult]
    let hitEffects: HitEffectTable
    let randomNumberTable: [Int]
}

extension ActionCard {
    func hasIcon(_ icon: ActionCardIcon) -> Bool {
        icons.contains(icon)
    }

    func randomNumber(for options: Int) -> Int {
        randomNumberTable[options - 2]
    }

    func combatResult(ncm: Int) -> CombatResult {
        let clampedNCM = min(max(ncm, -4), 6)
        return combatResults[clampedNCM + 4]
    }

    func hitEffects(experience: ExperienceLevel) -> [HitEffect] {
        switch experience {
        case .veteran:
            return hitEffects.veteran
        case .line:
            return hitEffects.line
        case .green:
            return hitEffects.green
        }
    }

    var isReshuffleCard: Bool { id == 51 }

}

enum ActionCardIcon: String, Codable {
    case infiltrate
    case contact
    case rally
    case cover
    case crosshairs
    case grenade
    case burst
    case tripleBurst
    case short
    case jam
    case hqEvent
}

enum CombatResult: String, Codable {
    case miss
    case pin
    case hit
}

enum HitEffect: String, Codable {
    case casualty = "C"
    case paralyzed = "P"
    case litter = "L"
    case fire = "F"
    case assault = "A"
}

struct HitEffectTable: Codable {
    let veteran: [HitEffect]
    let line: [HitEffect]
    let green: [HitEffect]
}
