// ActionDeckEngineTests.swift
//

import XCTest

@testable import FoFLib

final class ActionDeckEngineTests: XCTestCase {
    // MARK: - Helpers

    private func makeCard(
        id: Int = 42,
        activatedCommands: Int = 3,
        initiativeCommands: Int = 2,
        atNumber: Int = -1,
        icons: [ActionCardIcon] = [],
        combatResults: [CombatResult] = [
            .miss, .miss, .miss, .miss, .pin, .pin, .pin, .pin, .hit, .hit, .hit,
        ],
        hitEffects: HitEffectTable = HitEffectTable(
            veteran: [.assault], line: [.fire, .litter], green: [.paralyzed]
        ),
        randomNumberTable: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    ) -> ActionCard {

        let card = ActionCard(
            id: id, activatedCommands: activatedCommands, initiativeCommands: initiativeCommands,
            atNumber: atNumber, icons: icons,
            combatResults: combatResults, hitEffects: hitEffects,
            randomNumberTable: randomNumberTable
        )
        return card
    }

    func testHqEvent_cardHasHqEvetnIcon
}
