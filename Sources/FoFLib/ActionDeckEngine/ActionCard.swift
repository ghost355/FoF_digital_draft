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

struct HitEffectTable: Codable {
    let veteran: [HitEffect]
    let line: [HitEffect]
    let green: [HitEffect]
}
