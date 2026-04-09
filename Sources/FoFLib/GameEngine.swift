// GameEngine.swift

class GameEngine {
    var context: GameContext
    private var phaseProcessor: PhaseProcessor

    init(missionName: String) {
        self.context = GameContext(missionName: missionName)
        self.phaseProcessor = PhaseProcessor(context: context)
    }

    func start() {
        phaseProcessor.start()
    }
}
