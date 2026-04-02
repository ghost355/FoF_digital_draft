import XCTest

@testable import FoFLib

final class ActionCardTests: XCTestCase {

    private func makeCard(
        id: Int = 1,
        activatedCommands: Int = 0,
        initiativeCommands: Int = 0,
        atNumber: Int = 0,
        icons: [ActionCardIcon] = [],
        combatResults: [CombatResult] = [
            .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss,
        ],
        hitEffects: HitEffectTable = HitEffectTable(veteran: [], line: [], green: []),
        randomNumberTable: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    ) -> ActionCard {
        ActionCard(
            id: id,
            activatedCommands: activatedCommands,
            initiativeCommands: initiativeCommands,
            atNumber: atNumber,
            icons: icons,
            combatResults: combatResults,
            hitEffects: hitEffects,
            randomNumberTable: randomNumberTable
        )
    }

    // MARK: - hasIcon

    func testHasIcon_cardContainsIcon_returnsTrue() {
        let card = makeCard(icons: [.burst, .contact])
        XCTAssertTrue(card.hasIcon(.burst))
        XCTAssertTrue(card.hasIcon(.contact))
    }

    func testHasIcon_cardDoesNotContainIcon_returnsFalse() {
        let card = makeCard(icons: [.burst])
        XCTAssertFalse(card.hasIcon(.jam))
        XCTAssertFalse(card.hasIcon(.hqEvent))
    }

    func testHasIcon_emptyIcons_returnsFalse() {
        let card = makeCard(icons: [])
        XCTAssertFalse(card.hasIcon(.burst))
    }

    // MARK: - randomNumber

    func testRandomNumber_options2_returnsTableIndex0() {
        let card = makeCard(randomNumberTable: [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110])
        XCTAssertEqual(card.randomNumber(for: 2), 10)
    }

    func testRandomNumber_options3_returnsTableIndex1() {
        let card = makeCard(randomNumberTable: [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110])
        XCTAssertEqual(card.randomNumber(for: 3), 20)
    }

    func testRandomNumber_options7_returnsTableIndex5() {
        let card = makeCard(randomNumberTable: [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110])
        XCTAssertEqual(card.randomNumber(for: 7), 60)
    }

    func testRandomNumber_options12_returnsTableIndex10() {
        let card = makeCard(randomNumberTable: [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110])
        XCTAssertEqual(card.randomNumber(for: 12), 110)
    }

    // MARK: - combatResult

    func testCombatResult_ncmMinus4_returnsFirstElement() {
        let card = makeCard(combatResults: [
            .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss, .hit,
        ])
        XCTAssertEqual(card.combatResult(ncm: -4), .miss)
    }

    func testCombatResult_ncm0_returnsFifthElement() {
        // ncm + 4 = 0 + 4 = index 4
        let card = makeCard(combatResults: [
            .miss, .miss, .miss, .miss, .hit, .miss, .miss, .miss, .miss, .miss, .miss,
        ])
        XCTAssertEqual(card.combatResult(ncm: 0), .hit)
    }

    func testCombatResult_ncm6_returnsLastElement() {
        let card = makeCard(combatResults: [
            .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss, .hit,
        ])
        XCTAssertEqual(card.combatResult(ncm: 6), .hit)
    }

    func testCombatResult_ncmBelowMinus4_clampedToMinus4() {
        let card = makeCard(combatResults: [
            .miss, .hit, .hit, .hit, .hit, .hit, .hit, .hit, .hit, .hit, .hit,
        ])
        XCTAssertEqual(card.combatResult(ncm: -10), .miss)
    }

    func testCombatResult_ncmAbove6_clampedTo6() {
        let card = makeCard(combatResults: [
            .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss, .hit,
        ])
        XCTAssertEqual(card.combatResult(ncm: 10), .hit)
    }

    // MARK: - isReshuffleCard

    func testIsReshuffleCard_id51_returnsTrue() {
        let card = makeCard(id: 51)
        XCTAssertTrue(card.isReshuffleCard)
    }

    func testIsReshuffleCard_id50_returnsFalse() {
        let card = makeCard(id: 50)
        XCTAssertFalse(card.isReshuffleCard)
    }

    func testIsReshuffleCard_id1_returnsFalse() {
        let card = makeCard(id: 1)
        XCTAssertFalse(card.isReshuffleCard)
    }
}
