// GameContext.swift
import Foundation

class GameContext {
    let mission: Mission

    init(mission: String) {
        if mission == "demo" {
            self.mission = loadJSON(demoMission, as: Mission.self)
        } else {
            let bundle = Bundle.module
            self.mission = loadJSON(mission, as: Mission.self, from: bundle)
        }
    }

}
