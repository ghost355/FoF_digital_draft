// Mission.swfit

struct Mission: Codable {
    let name: String
    let campaign: CampaignName
    let duration: Int
    let type: MissionType
    let visibility: Visibility
    let map: Map
    let objective: Objective
    let tacticalControl: TacticalControl
    let pcPlacement: [PotentialContact]
    let enemyTactics: EnemyTactic
    let enemyExperience: ExperienceLevel
    let enemyUsingUnit: [Unit]

}

struct Map: Codable {
    let row: Row
    let column: Column
    let facedDown: [Row: Bool]
}

struct TacticalControl: Codable {
    let lineOfDeparture: Row
    let lineOfAdvance: Row
    let leftBoundary: Column
    let rightBoundary: Column

    let primaryObjective: Row
    let secondaryObjective: Row
    let attackPosition: Row

}

struct Objective: Codable {
    let target: ObjectiveTarget
    let type: ObjectiveType
}

enum ObjectiveTarget: String, Codable {
    case primaryObjective, secondaryObjective
}

enum ObjectiveType: String, Codable {
    case secure, clear
}

typealias Row = Int
typealias Column = Int
typealias Position = (Row, Column)

enum Visibility: String, Codable {
    case clear

}

enum PC: String, Codable {
    case a, b, c, unknown
}

struct PotentialContact: Codable {
    let type: PC
    let row: Row

}

enum EnemyTactic: String, Codable {
    case deliberateDefense
}

// MARK: Demo json String

let demoMission = """
    {
        "name": "DemoMission",
        "campaign": "DemoCampaign",
        "duration": 10,
        "missionType": "offensive"
    }
    """
