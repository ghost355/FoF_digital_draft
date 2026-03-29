// Unit.swift
import Foundation

// MARK: - Основные перечисления

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

enum MovementType: String, Codable {
    case wheeled, tracked, halfTrack, helicopter, fixedWing
}

// MARK: - Состояния

enum UnitStatus: String, Codable {
    case goodOrder
    case pinned
    case assaultTeam
    case fireTeam
    case litterTeam
    case paralyzedTeam
    case casualty
}

enum VOF: Codable {
    case small
    case auto
    /// heavy has OverheadFire
    case heavy
    // tripod has GrasingFire, OverheadFire, FPL
    case autoTripod
    case heavyTripod

    case sniper
    case grenade
    case autoSmall
    case smallGrenade
    case autoSmallGrenade

    case flamethrower
    case demolition

    case wp
}

enum Range: String, Codable {
    case pointBlank, close, long, veryLong
}

// MARK: - Индивидуальные VOF эффекты

enum ReceivedVOFType: String, Codable {
    case sniper
    case concentratedFire
    case grenade
    case demo
    case flame
    case mine
}

struct ReceivedVOF: Codable {
    let type: ReceivedVOFType
    let value: Int
    let sourceId: String?
    let ignoreCover: Bool
}

// MARK: - Боеприпасы и снаряжение

enum AmmoType: String, Codable {
    case mg, mortar, rcl, rocket, flamethrower, demolition, rifleGrenade
}

typealias EquipmentID = String  // временно для прототипа

enum SmokeType: String, Codable {
    case hc, wp, colored
}

enum SmokeColor: String, Codable {
    case red, green, yellow, purple
}

// MARK: - Вспомогательные структуры

struct VehicleStats: Codable {
    let armorValue: Int
    let passengerCapacity: Int
    let movementType: MovementType
    let atGunneryTable: String?
}

struct GridPosition: Codable {
    let row: Int
    let column: Int
}

// MARK: - Fire Mission (глобальный VOF на карту)

struct FireMission: Codable {
    let type: FireMissionType
    let value: Int
    var turnsRemaining: Int
}

enum FireMissionType: String, Codable {
    case he, wp, airStrike, attackHelicopter
}

// MARK: - Unit Breakdown

struct UnitBreakdown: Codable {
    let fromSteps: Int
    let result: [BreakdownResult]
}

struct BreakdownResult: Codable {
    let type: UnitType
    let steps: Int
    let vof: VOF
    let range: Range
    let experience: ExperienceLevel?
    let transferAmmo: Bool
}

// MARK: - Unit

struct Unit: Codable, Identifiable {
    // Идентификация
    let id: UUID
    let name: String
    let side: Side
    let type: UnitType
    let vof: VOF
    let range: Range

    // Состояние

    var status: UnitStatus {
        didSet {
            updateExpirienceByStatus()
        }
    }

    var steps: Int
    var position: GridPosition?
    var experience: ExperienceLevel
    var isExposed: Bool
    var ammo: [AmmoType: Int]
    var equipment: [EquipmentID]
    var assignedTo: String?
    /// Правила разделения
    let breakdown: [UnitBreakdown]?

    /// Опционально
    let vehicleStats: VehicleStats?

    // Визуальные
    let imageFileFace: String
    let imageFileBack: String
    let notes: String
}

// MARK: - Вычисляемые свойства

extension Unit {
    var isGoodOrder: Bool {
        status == .goodOrder && !isPinned
    }

    var isPinned: Bool {
        status == .pinned
    }

    var isLAT: Bool {
        switch status {
        case .assaultTeam, .fireTeam, .litterTeam, .paralyzedTeam:
            return true
        default:
            return false
        }
    }

    var isCasualty: Bool {
        status == .casualty
    }

    private mutating func updateExpirienceByStatus() {
        switch status {
        case .assaultTeam:
            experience = .line
        case .fireTeam, .litterTeam, .paralyzedTeam:
            experience = .green
        default:
            // goodOrder, pinned, casualty — опыт не меняем
            break
        }
    }
}
