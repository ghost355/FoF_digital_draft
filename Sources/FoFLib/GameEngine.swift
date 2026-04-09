// GameEngine.swift

class GameEngine {
    var context: GameContext
    private var phaseProcessor: PhaseProcessor

    init(missionName: missionName) {
        self.context = GameContext(missionName: missionName)
        self.phaseProcessor = phaseProcessor(context: context)
    }

    func start() {
        phaseProcessor.start()
    }
}
