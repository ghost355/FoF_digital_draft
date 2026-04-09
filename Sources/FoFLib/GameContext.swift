// GameContext.swift
import Foundation

class GameContext {
    let mission: Mission
    var turn: Int = 1

    init(missionName: String) {
        if missionName == "demo" {
            self.mission = loadJSON(demoMission, as: Mission.self)
        } else {
            self.mission = loadJSON(missionName, as: Mission.self, from: .module)
        }
    }

}
