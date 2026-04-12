// EnemyPackage.swift

// Протокол
protocol EnemyPackage {
    func deploy(on card: TerrainCard, context: GameContext)
}

// Фабрика
struct PackageFactory {
    let context: GameContext

    func create(packageId: Int) -> EnemyPackage {
        let recipe = context.mission.packages[packageId]!
        return SimplePackage(recipe: recipe, context: context)
    }
}

// Пакет (который тоже EnemyPackage)
struct SimplePackage: EnemyPackage {
    let components: [EnemyPackage]  // компоненты тоже EnemyPackage

    init(recipe: PackageRecipe, context: GameContext) {
        var comps: [EnemyPackage] = []
        // ... заполняем
        self.components = comps
    }

    func deploy(on card: TerrainCard, context: GameContext) {
        components.forEach { $0.deploy(on: card, context: context) }
    }
}

// Компонент
struct MinesComponent: EnemyPackage {
    func deploy(on card: TerrainCard, context: GameContext) {
        context.map.placeMines(at: card.position)
    }
}
