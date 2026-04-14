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
    let additinalAttachments: [Unit]
    let fireSupport: [FireSupport]
    let friendlyHigherHqEvents: [Event]
    let enemyHigherHqEvents: [Event]

}

enum EnemyPlacementRule: Codable {
    case maxLosRange, maxLos, maxRange
    case closeRange, longRange, veryLongRange, pointBlankRange
}

struct EnemyUnitPlacementEntry: Codable {
    let row: Row?
    let randomNumber: RandomFromToOpt
    let direction: PlaceDirection
}
enum PlaceDirection: String, Codable {
    case front, leftFront, rightFront
}

enum Cover: Codable {
    case foxhole, trenche, pillowbox, bunker, deepBunker, building
}

struct EnemyContactPackageEntry: Codable {
    let id: Int
    let pcA: RandomFromToOpt
    let pcB: RandomFromToOpt
    let pcC: RandomFromToOpt
    let randomOption: Int
}

struct RandomFromToOpt: Codable {
    let from: Int
    let to: Int
    let option: Int
}

struct EventTurnRandom: Codable {
    let startTurn: Int
    let endTurn: Int
    let randomNumber: RandomFromToOpt
}

struct Event: Codable {
    let description: String
    let randomNubmerAndTurn: [EventTurnRandom]
    let type: EventType
}

enum EventType: String, Codable {
    case situationReport, commTrouble, artilleryDisplacing, checkingUp, troubleOnFlank
    case coOnFlankAhead, btnScreamingForAction, ammoResupply
    case evacuateCasualties, displaceMtr, displaceLdr, displaceHMG, rally, fallBack, counterAttack
}

struct FireSupport: Codable {
    let agency: String
    let ammo: FireMissionAmmo
    let combatMod: Int
    let artyFoDraw: Int?
    let mtrFoDraw: Int?
    let coHqDraw: Int?
    let fireMission: Int
}

enum FireMissionAmmo: String, Codable {
    case he, ws, tot
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
