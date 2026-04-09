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

enum Side: String, Codable {
    case us, german, northKorean, vietcong, nva, katusa, chinese
}

enum UnitType: String, Codable {
    case squad, hq, fo, weaponsTeam, sniper, leader, spotter, vehicle, aircraft, staff, runner,
        aboveHQ
}

enum ExperienceLevel: String, Codable {
    case green, line, veteran
}
