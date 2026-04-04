import XCTest

@testable import FoFLib

final class ActionCardTests: XCTestCase {

    private func makeCard(
        id: Int = 1,
        icons: [ActionCardIcon] = []
    ) -> ActionCard {
        ActionCard(
            id: id,
            activatedCommands: 0,
            initiativeCommands: 0,
            atNumber: 0,
            icons: icons,
            combatResults: [.miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss],
            hitEffects: HitEffectTable(veteran: [], line: [], green: []),
            randomNumberTable: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
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
