// PhaseProcessor.swift

class PhaseProcessor {
    private let context: GameContext
    private var currentPhaseIndex = 0
    private let phases: [TurnPhase]

    init(context: GameContext) {
        self.context = context
        self.phases = [
            .friendlyHigherHQEvent,
            .enemyActivity(.defensive),
            .friendlyCommandActivation,
            .friendlyCommandInitiative,
            .enemyActivity(.offensive),
            .mutualCaptureAndRetreat,
            .atCombatAndVehicleMovement,
            .mutualCombat(.fireMissionUpdate),
            .mutualCombat(.potentialContactEvaluation),
            .mutualCombat(.pinnedRecovery),
            .mutualCombat(.combatEffects),
            .cleanup,
        ]
    }

    func start() {
        print("=== Миссия: \(context.mission.name) ===")
        print("Тип: \(context.mission.missionType)")
        print("Ходов: \(context.mission.turns)")
        nextPhase()
    }

    func nextPhase() {
        let phase = phases[currentPhaseIndex]
        execute(phase)

        currentPhaseIndex += 1
        if currentPhaseIndex >= phases.count {
            currentPhaseIndex = 0
            context.turn += 1
            if context.turn > context.mission.turns {
                print("=== Миссия завершена ===")
                return
            }
            print("\n=== Ход \(context.turn) ===")
        }

        // Для пошагового режима (опционально)
        // print("Нажмите Enter для следующей фазы...")
        // _ = readLine()
        nextPhase()  // автоматический переход (убрать для ручного)
    }

    private func execute(_ phase: TurnPhase) {
        switch phase {
        case .friendlyHigherHQEvent:
            print("📡 Фаза 3.1: События вышестоящего командования")
        // логика

        case .enemyActivity(let type):
            print("👥 Фаза 3.\(type == .defensive ? "2" : "4"): Активность противника (\(type))")
        // логика

        case .friendlyCommandActivation:
            print("🎖️ Фаза 3.3.1: Активация командования")
        // логика

        case .friendlyCommandInitiative:
            print("🎖️ Фаза 3.3.2: Инициатива")
        // логика

        case .mutualCaptureAndRetreat:
            print("🏃 Фаза 3.5: Захват и отступление")
        // логика

        case .atCombatAndVehicleMovement:
            print("🚗 Фаза 3.6: ПТ-бой и движение техники")
        // логика

        case .mutualCombat(let subphase):
            print("⚔️ Фаза 3.7: \(subphase)")
        // логика

        case .cleanup:
            print("🧹 Фаза 3.8: Очистка")
        // логика
        }
    }
}
