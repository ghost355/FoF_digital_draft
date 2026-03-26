// TerrainCard.swift
import Foundation

// MARK: - Terrain Types
enum TerrainType: String, Codable, CaseIterable {
    // Open Terrain
    case openField
    case orchard
    case hedgerow
    case bocage

    // Woodland/Vegetation
    case woods
    case jungle
    case bamboo
    case caneField

    // Water/Obstacles
    case ricePaddy
    case canal
    case stream

    // Urban
    case village
    case farm
    case church
    case largeInteriorBuilding
    case complexBuilding
    case compound

    // Other
    case rocky
    case dunes
    case beach
    case surfZone

    // Elevation
    case hill

    // Default for unknown
    case unknown
}

// MARK: - LOS Border Types
enum BorderType: String, Codable {
    case white  // не блокирует LOS
    case dark  // блокирует LOS
}

// MARK: - LOS Borders (по сторонам карты - 5.2.1)
struct LOSBorders: Codable, Equatable {
    let north: BorderType
    let northEast: BorderType
    let east: BorderType
    let southEast: BorderType
    let south: BorderType
    let southWest: BorderType
    let west: BorderType
    let northWest: BorderType

    static let none = LOSBorders(
        north: .white, northEast: .white, east: .white, southEast: .white,
        south: .white, southWest: .white, west: .white, northWest: .white
    )
}

// MARK: - Trafficability (5.2.4)
enum Trafficability: String, Codable {
    case normal
    case slow
    case noEntry
}

// MARK: - Cover Marker (5.3)
struct CoverMarker: Codable, Identifiable {
    let id: String
    let value: Int  // +1 Basic, +2 Field Fortifications, etc.
    let maxCapacity: Int?  // для Bunker/Pillbox/Cave
    let direction: Direction?  // направление огня для Bunker/Pillbox/Cave
    var unitIds: [String]  // ID юнитов под укрытием

    static func basic(value: Int) -> CoverMarker {
        CoverMarker(
            id: UUID().uuidString, value: value, maxCapacity: nil, direction: nil, unitIds: [])
    }
}

// MARK: - Direction
enum Direction: String, Codable, CaseIterable {
    case north, northEast, east, southEast, south, southWest, west, northWest
}

// MARK: - Urban Area Types (13.0)
enum UrbanAreaType: String, Codable {
    case streetTop
    case streetRight
    case streetBottom
    case streetLeft
    case building
    case courtyard
    case upperStory
    case rooftop
}

// MARK: - Urban Area (13.1)
struct UrbanArea: Codable, Identifiable {
    let id: String
    let type: UrbanAreaType
    let coverValue: Int  // Cover & Concealment для области
    var unitIds: [String]  // ID юнитов в области
    let hasBreach: Bool  // пролом в стене

    static func street(coverValue: Int) -> UrbanArea {
        UrbanArea(
            id: UUID().uuidString, type: .streetTop, coverValue: coverValue, unitIds: [],
            hasBreach: false)
    }

    static func building(coverValue: Int) -> UrbanArea {
        UrbanArea(
            id: UUID().uuidString, type: .building, coverValue: coverValue, unitIds: [],
            hasBreach: false)
    }
}

// MARK: - Card Status
enum CardStatus: String, Codable {
    case unoccupied
    case friendlyOccupied
    case enemyOccupied
    case jointlyOccupied
    case cleared
    case secured
}

// MARK: - Terrain Card
struct TerrainCard: Codable, Identifiable {
    // Идентификация
    let id: String
    let campaingId: String
    let terrainType: TerrainType

    // Cover & Concealment (5.2.3)
    let coverConcealmentHigh: Int
    let coverConcealmentLow: Int

    // LOS Borders (5.2.1)
    let losBorders: LOSBorders

    // Cover Potential (5.3)
    let coverPotential: Int
    let coverDrawNumber: Int

    // Elevation (5.2.2)
    var elevation: Int

    // Trafficability (5.2.4)
    let trafficability: Trafficability

    // Landing Zone (11.1.3)
    let isLandingZone: Bool

    // Urban Terrain (13.0)
    let isUrban: Bool
    let isMultiStory: Bool
    let isChurch: Bool
    let isCompound: Bool

    // Burst Modifier (6.2.3)
    let burstModifier: Int?

    // Urban Areas (только для городских карт)
    var urbanAreas: [UrbanArea]

    // Cover Markers (5.3)
    var coverMarkers: [CoverMarker]

    // Статус карты (runtime state)
    var status: CardStatus
    var isFaceUp: Bool
    var hasPCMarker: Bool
    var units: [String]

    // Позиция на карте
    let gridPosition: GridPosition

    // MARK: - Вычисляемые свойства

    /// Effective Cover & Concealment для стрельбы через указанную границу
    func effectiveCoverConcealment(throughDarkBorders: Bool) -> Int {
        throughDarkBorders ? coverConcealmentHigh : coverConcealmentLow
    }

    /// Сколько ещё укрытий можно добавить
    var availableCoverSlots: Int {
        coverPotential - coverMarkers.count
    }

    /// Может ли юнит войти в укрытие
    var canSeekCover: Bool {
        availableCoverSlots > 0 && coverMarkers.isEmpty == false
    }

    /// Все юниты на карте (из urban areas или из units)
    var allUnitIds: [String] {
        if isUrban {
            return urbanAreas.flatMap { $0.unitIds }
        }
        return units
    }

    /// Проверка LOS через границу (5.2.1)
    func canTraceLOS(through direction: Direction) -> Bool {
        switch direction {
        case .north: return losBorders.north == .white
        case .northEast: return losBorders.northEast == .white
        case .east: return losBorders.east == .white
        case .southEast: return losBorders.southEast == .white
        case .south: return losBorders.south == .white
        case .southWest: return losBorders.southWest == .white
        case .west: return losBorders.west == .white
        case .northWest: return losBorders.northWest == .white
        }
    }

    /// Проверка LOS между двумя картами (5.2.1)
    static func canTraceLOS(
        from origin: TerrainCard, to target: TerrainCard, through directions: [Direction]
    ) -> Bool {
        for direction in directions {
            if !origin.canTraceLOS(through: direction) {
                return false
            }
        }
        return true
    }

    // MARK: - Mutations

    mutating func addUnit(_ unitId: String) {
        if !units.contains(unitId) {
            units.append(unitId)
        }
        status = .friendlyOccupied
    }

    mutating func removeUnit(_ unitId: String) {
        units.removeAll { $0 == unitId }
        if units.isEmpty {
            status = .unoccupied
        }
    }

    mutating func addCoverMarker(_ marker: CoverMarker) {
        guard coverMarkers.count < coverPotential else { return }
        coverMarkers.append(marker)
    }

    mutating func clearCoverMarker(id: String) {
        coverMarkers.removeAll { $0.id == id }
    }

    mutating func reveal() {
        isFaceUp = true
    }

    mutating func flip() {
        isFaceUp.toggle()
    }
}

// MARK: - Terrain Card Extension для тестирования
#if DEBUG
    extension TerrainCard {
        static func sample() -> TerrainCard {
            TerrainCard(
                id: "sample",
                terrainType: .hedgerow,
                coverConcealmentHigh: 2,
                coverConcealmentLow: 0,
                losBorders: LOSBorders(
                    north: .white, northEast: .dark, east: .dark, southEast: .dark,
                    south: .dark, southWest: .dark, west: .dark, northWest: .white),
                coverPotential: 1,
                coverDrawNumber: 3,
                elevation: 1,
                trafficability: .normal,
                isLandingZone: false,
                isUrban: false,
                isMultiStory: false,
                isChurch: false,
                isCompound: false,
                burstModifier: nil,
                urbanAreas: [],
                coverMarkers: [
                    CoverMarker(
                        id: "cover1", value: 1, maxCapacity: nil, direction: nil, unitIds: [])
                ],
                status: .unoccupied,
                isFaceUp: true,
                hasPCMarker: false,
                units: [],
                gridPosition: GridPosition(row: 1, column: 1)
            )
        }
    }
#endif

