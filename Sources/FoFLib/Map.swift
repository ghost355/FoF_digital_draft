// Map.swift
//

struct Map {
    var cells: [[GridCell]]
    let rows: Row
    let columns: Column

    var weather: Weather
    var lightLevel: LightLevel

    init(rows: Row, columns: Column) {
        self.rows = rows
        self.columns = columns

        self.cells = (0..<rows).map { row in
            (0..<columns).map { column in
                GridCell(position: GridPosition(row: row, column: column))
            }
        }
    }
}

struct GridCell {
    let position: GridPosition
    let terrainCard: [TerrainCard] = []
    var isCardFaceDown: Bool = true
    var friendlyUnits: [Unit] = []
    var enemyUnits: [Unit] = []
    var vofMarkers: [VOFMarker] = []
    var tacticalMarkers: [TacticalMarker] = []
    var pc: PotentialContact?
    var covers: [Cover] = []
}

struct GridPosition: Codable {
    let row: Row
    let column: Column
}

enum TacticalMarker: Codable {
    // Линейные
    case lod(GridPosition)
    case loa(GridPosition)
    case mlr(GridPosition)
    case phaseLine(GridPosition)
    case leftBoundary(GridPosition)
    case rightBoundary(GridPosition)

    // Точечные
    case primaryObjective(GridPosition)
    case secondaryObjective(GridPosition)
    case attackPosition(GridPosition)
    case casualtyCollectionPoint(GridPosition)
    case landingZone(GridPosition)
    case combatOutpost(GridPosition)
    case routePoint(GridPosition)

    // FPL и FPF
    case fpl(GridPosition, Direction)
    case fpf(GridPosition, Direction)

    // NOTE: а нужено ли это свойство будет?
    var position: GridPosition {
        switch self {
        case .lod(let p), .loa(let p), .mlr(let p), .phaseLine(let p),
            .leftBoundary(let p), .rightBoundary(let p),
            .primaryObjective(let p), .secondaryObjective(let p),
            .attackPosition(let p), .casualtyCollectionPoint(let p),
            .landingZone(let p), .combatOutpost(let p), .routePoint(let p),
            .fpl(let p, _), .fpf(let p, _):
            return p
        }
    }
}

enum VOFMarker {
    case pinned, smallArms, automaticWeapons, HeavyWeapons
    case grenade, sniper, mines, incoming, airStrike
    case crossfire, concentratedFire, grenadeMiss, demoMiss
}

enum Weather {
    case clear, rain, fog, snow
}

enum LightLevel {
    case daylight, night, moon
}
