// Campaign.swift

struct Campaign: Codable {
    let name: CampaignName
    let units: [Unit]
    let enemy: [Unit]
    let assets: [Asset]
    let experiencePoint: [ExperiencePoint]

    // Basic Info

    let usTakePrisoner: Bool
    let enemyTakePrisoner: Bool
    let runnerAvailiableFromStart: Bool
    let replacement: Replacements?
    let usGrenadesVOF: Int
    let enemyGrenadesVOF: Int
    // casualtyEvacuation - place 1 before each mission or during it

    //Simlifications
    let useAmmo: Bool
    let useCommunication: Bool
    let usePyrotechnic: Bool
    let useVehicles: Bool

}

enum Asset: String, Codable {
    case rifleGrenade
    case hcSmoke, wpSmoke
}

struct Replacements: Codable {
    let stepAmount: Int
    let stepExperience: ExperienceLevel
}

struct ExperiencePoint: Codable {
    let task: String
    let point: Int
}
