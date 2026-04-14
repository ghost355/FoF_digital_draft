// GameContext.swift
import Foundation

class GameContext {
    let campaign: Campaign
    let mission: Mission
    let map: Map
    let tables: GameTable
    let usUnits: [Unit]
    let enemyUnits: [Unit]
    var turn: Int = 1

    init(missionName: String) {
        if missionName == "demo" {
            self.mission = loadJSON(demoMission, as: Mission.self)
        } else {
            self.mission = loadJSON(missionName, as: Mission.self, from: .module)
        }
    }

}

struct GameTable {
    let x: String
}
