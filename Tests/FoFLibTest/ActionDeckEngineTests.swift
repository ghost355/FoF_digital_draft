import XCTest

@testable import FoFLib

final class ActionDeckEngineTests: XCTestCase {

    private func makeCard(
        id: Int = 42,
        icons: [ActionCardIcon] = []
    ) -> ActionCard {
        ActionCard(
            id: id,
            activatedCommands: 3,
            initiativeCommands: 2,
            atNumber: -1,
            icons: icons,
            combatResults: [.hit, .hit, .hit, .hit, .pin, .pin, .pin, .pin, .miss, .miss, .miss],
            hitEffects: HitEffectTable(
                veteran: [.assault], line: [.fire, .litter], green: [.paralyzed]),
            randomNumberTable: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        )
    }

    // MARK: - hqEvent

    func testHqEvent_cardHasHqEventIcon_returnSuccess() {
        let card = makeCard(icons: [.hqEvent])
        let engine = ActionDeckEngine(cards: [card])
        let result = engine.hqEvent()
        XCTAssertEqual(result, .success)
    }

    func testHqEvent_cardLacksHqEventIcon_returnFailure() {
        let card = makeCard(icons: [.crosshairs, .rally])
        let engine = ActionDeckEngine(cards: [card])
        let result = engine.hqEvent()
        XCTAssertEqual(result, .failure)
    }

    // MARK: - mines (draws 3 cards)

    func testMines_handContainsBurstIcon_returnSuccess() {
        let card1 = makeCard(icons: [.burst])
        let card2 = makeCard(icons: [.contact])
        let card3 = makeCard(icons: [.jam])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.mines()
        XCTAssertEqual(result, .success)
    }

    func testMines_handContainsTripleBurstIcon_returnSuccess() {
        let card1 = makeCard(icons: [.tripleBurst])
        let card2 = makeCard(icons: [.contact])
        let card3 = makeCard(icons: [.jam])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.mines()
        XCTAssertEqual(result, .success)
    }

    func testMines_handContainsShortIcon_returnSuccess() {
        let card1 = makeCard(icons: [.short])
        let card2 = makeCard(icons: [.contact])
        let card3 = makeCard(icons: [.jam])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.mines()
        XCTAssertEqual(result, .success)
    }

    func testMines_handLacksBurstIcons_returnFailure() {
        let card1 = makeCard(icons: [.contact, .cover])
        let card2 = makeCard(icons: [.rally])
        let card3 = makeCard(icons: [.jam])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.mines()
        XCTAssertEqual(result, .failure)
    }

    func testMines_multipleCards_noneHasBurstIcon_returnFailure() {
        let card1 = makeCard(icons: [.contact])
        let card2 = makeCard(icons: [.jam])
        let card3 = makeCard(icons: [.rally])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.mines()
        XCTAssertEqual(result, .failure)
    }

    // MARK: - infiltration

    func testInfiltration_cardHasInfiltrateIcon_returnSuccess() {
        let card = makeCard(icons: [.infiltrate])
        let engine = ActionDeckEngine(cards: [card])
        let result = engine.infiltration(count: 1)
        XCTAssertEqual(result, .success)
    }

    func testInfiltration_cardLacksInfiltrateIcon_returnFailure() {
        let card = makeCard(icons: [.crosshairs, .rally])
        let engine = ActionDeckEngine(cards: [card])
        let result = engine.infiltration(count: 1)
        XCTAssertEqual(result, .failure)
    }

    func testInfiltration_multipleCards_oneHasInfiltrateIcon_returnSuccess() {
        let card1 = makeCard(icons: [.contact])
        let card2 = makeCard(icons: [.infiltrate])
        let card3 = makeCard(icons: [.jam])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.infiltration(count: 3)
        XCTAssertEqual(result, .success)
    }

    func testInfiltration_multipleCards_noneHasInfiltrateIcon_returnFailure() {
        let card1 = makeCard(icons: [.contact])
        let card2 = makeCard(icons: [.jam])
        let card3 = makeCard(icons: [.rally])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.infiltration(count: 3)
        XCTAssertEqual(result, .failure)
    }

    func testInfiltration_multipleCards_infiltrateAtFirstPosition_returnSuccess() {
        let card1 = makeCard(icons: [.infiltrate])
        let card2 = makeCard(icons: [.contact])
        let card3 = makeCard(icons: [.jam])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.infiltration(count: 3)
        XCTAssertEqual(result, .success)
    }

    func testInfiltration_multipleCards_infiltrateAtLastPosition_returnSuccess() {
        let card1 = makeCard(icons: [.contact])
        let card2 = makeCard(icons: [.jam])
        let card3 = makeCard(icons: [.infiltrate])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.infiltration(count: 3)
        XCTAssertEqual(result, .success)
    }

    // MARK: - cover

    func testCover_cardHasCoverIcon_returnSuccess() {
        let card = makeCard(icons: [.cover])
        let engine = ActionDeckEngine(cards: [card])
        let result = engine.cover(count: 1)
        XCTAssertEqual(result, .success)
    }

    func testCover_cardLacksCoverIcon_returnFailure() {
        let card = makeCard(icons: [.rally, .hqEvent])
        let engine = ActionDeckEngine(cards: [card])
        let result = engine.cover(count: 1)
        XCTAssertEqual(result, .failure)
    }

    func testCover_multipleCards_oneHasCoverIcon_returnSuccess() {
        let card1 = makeCard(icons: [.contact])
        let card2 = makeCard(icons: [.cover])
        let card3 = makeCard(icons: [.jam])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.cover(count: 3)
        XCTAssertEqual(result, .success)
    }

    func testCover_multipleCards_noneHasCoverIcon_returnFailure() {
        let card1 = makeCard(icons: [.contact])
        let card2 = makeCard(icons: [.jam])
        let card3 = makeCard(icons: [.rally])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.cover(count: 3)
        XCTAssertEqual(result, .failure)
    }

    func testCover_multipleCards_coverAtFirstPosition_returnSuccess() {
        let card1 = makeCard(icons: [.cover])
        let card2 = makeCard(icons: [.contact])
        let card3 = makeCard(icons: [.jam])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.cover(count: 3)
        XCTAssertEqual(result, .success)
    }

    func testCover_multipleCards_coverAtLastPosition_returnSuccess() {
        let card1 = makeCard(icons: [.contact])
        let card2 = makeCard(icons: [.jam])
        let card3 = makeCard(icons: [.cover])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.cover(count: 3)
        XCTAssertEqual(result, .success)
    }

    // MARK: - rally

    func testRally_cardHasRallyIcon_returnSuccess() {
        let card = makeCard(icons: [.rally])
        let engine = ActionDeckEngine(cards: [card])
        let result = engine.rally(count: 1)
        XCTAssertEqual(result, .success)
    }

    func testRally_cardLacksRallyIcon_returnFailure() {
        let card = makeCard(icons: [.cover, .hqEvent])
        let engine = ActionDeckEngine(cards: [card])
        let result = engine.rally(count: 1)
        XCTAssertEqual(result, .failure)
    }

    func testRally_multipleCards_oneHasRallyIcon_returnSuccess() {
        let card1 = makeCard(icons: [.contact])
        let card2 = makeCard(icons: [.rally])
        let card3 = makeCard(icons: [.jam])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.rally(count: 3)
        XCTAssertEqual(result, .success)
    }

    func testRally_multipleCards_noneHasRallyIcon_returnFailure() {
        let card1 = makeCard(icons: [.contact])
        let card2 = makeCard(icons: [.jam])
        let card3 = makeCard(icons: [.cover])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.rally(count: 3)
        XCTAssertEqual(result, .failure)
    }

    func testRally_multipleCards_rallyAtFirstPosition_returnSuccess() {
        let card1 = makeCard(icons: [.rally])
        let card2 = makeCard(icons: [.contact])
        let card3 = makeCard(icons: [.jam])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.rally(count: 3)
        XCTAssertEqual(result, .success)
    }

    func testRally_multipleCards_rallyAtLastPosition_returnSuccess() {
        let card1 = makeCard(icons: [.contact])
        let card2 = makeCard(icons: [.jam])
        let card3 = makeCard(icons: [.rally])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.rally(count: 3)
        XCTAssertEqual(result, .success)
    }
    // MARK: - combatResult

    func testCombatResult_ncmMinus4_returnsIndex0() {
        let card = makeCard()
        let engine = ActionDeckEngine(cards: [card])
        let result = engine.combatResult(ncm: -4)
        XCTAssertEqual(result, .hit)
    }

    func testCombatResult_ncm0_returnsIndex4() {
        let card = makeCard()
        let engine = ActionDeckEngine(cards: [card])
        let result = engine.combatResult(ncm: 0)
        XCTAssertEqual(result, .pin)
    }

    func testCombatResult_ncm6_returnsLastElement() {
        let card = makeCard()
        let engine = ActionDeckEngine(cards: [card])
        let result = engine.combatResult(ncm: 6)
        XCTAssertEqual(result, .miss)
    }

    func testCombatResult_ncmBelowMinus4_clampedToMinus4() {
        let card = makeCard()
        let engine = ActionDeckEngine(cards: [card])
        let result = engine.combatResult(ncm: -10)
        XCTAssertEqual(result, .hit)
    }

    func testCombatResult_ncmAbove6_clampedTo6() {
        let card = makeCard()
        let engine = ActionDeckEngine(cards: [card])
        let result = engine.combatResult(ncm: 10)
        XCTAssertEqual(result, .miss)
    }

    // MARK: - Grenade Tests

    func testGrenade_anyCardHasGrenadeIcon_returnSuccess() {
        let card1 = makeCard(icons: [.grenade, .cover])
        let card2 = makeCard(icons: [.rally])
        let card3 = makeCard(icons: [.hqEvent])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.grenadeAttack(count: 3, canJammed: false)
        XCTAssertEqual(result, .success)
    }

    // MARK: - Failure Tests

    func testGrenade_noGrenadeIcon_noJamIcon_returnFailure() {
        let card1 = makeCard(icons: [.cover])
        let card2 = makeCard(icons: [.rally])
        let card3 = makeCard(icons: [.hqEvent])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.grenadeAttack(count: 3, canJammed: false)
        XCTAssertEqual(result, .failure)
    }

    func testGrenade_noGrenadeIcon_hasJamIcon_canJammedFalse_returnFailure() {
        let card1 = makeCard(icons: [.jam])
        let card2 = makeCard(icons: [.rally])
        let card3 = makeCard(icons: [.cover])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.grenadeAttack(count: 3, canJammed: false)
        XCTAssertEqual(result, .failure)
    }

    // MARK: - Jam Tests

    func testGrenade_hasJamIcon_canJammedTrue_returnJam() {
        let card1 = makeCard(icons: [.jam])
        let card2 = makeCard(icons: [.grenade])
        let card3 = makeCard(icons: [.cover])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.grenadeAttack(count: 3, canJammed: true)
        XCTAssertEqual(result, .jam)
    }

    func testGrenade_hasJamIcon_hasGrenadeIcon_canJammedTrue_returnJam() {
        let card1 = makeCard(icons: [.jam, .grenade])
        let card2 = makeCard(icons: [.rally])
        let card3 = makeCard(icons: [.cover])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.grenadeAttack(count: 3, canJammed: true)
        XCTAssertEqual(result, .jam)
    }

    func testGrenade_hasJamIcon_canJammedFalse_returnSuccess() {
        let card1 = makeCard(icons: [.jam])
        let card2 = makeCard(icons: [.grenade])
        let card3 = makeCard(icons: [.cover])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.grenadeAttack(count: 3, canJammed: false)
        XCTAssertEqual(result, .success)
    }

    // MARK: - Critical Hit Tests

    func testGrenade_twoGrenadeIcons_returnCriticalHit() {
        let card1 = makeCard(icons: [.grenade])
        let card2 = makeCard(icons: [.grenade])
        let card3 = makeCard(icons: [.cover])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.grenadeAttack(count: 3, canJammed: false)
        XCTAssertEqual(result, .criticalHit)
    }

    func testGrenade_threeGrenadeIcons_returnCriticalHit() {
        let card1 = makeCard(icons: [.grenade])
        let card2 = makeCard(icons: [.grenade])
        let card3 = makeCard(icons: [.grenade])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.grenadeAttack(count: 3, canJammed: false)
        XCTAssertEqual(result, .criticalHit)
    }

    // MARK: - Critical Hit with Jam Priority

    func testGrenade_twoGrenadeIcons_hasJamIcon_canJammedTrue_returnJam() {
        let card1 = makeCard(icons: [.grenade])
        let card2 = makeCard(icons: [.grenade])
        let card3 = makeCard(icons: [.jam])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.grenadeAttack(count: 3, canJammed: true)
        XCTAssertEqual(result, .jam)  // Jam имеет приоритет над criticalHit
    }

    func testGrenade_twoGrenadeIcons_hasJamIcon_canJammedFalse_returnCriticalHit() {
        let card1 = makeCard(icons: [.grenade])
        let card2 = makeCard(icons: [.grenade])
        let card3 = makeCard(icons: [.jam])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.grenadeAttack(count: 3, canJammed: false)
        XCTAssertEqual(result, .criticalHit)  // Jam игнорируется, считаем гранаты
    }

    // MARK: - Complex Combinations

    func testGrenade_multipleIcons_oneGrenade_returnSuccess() {
        let card1 = makeCard(icons: [.grenade, .jam, .cover])
        let card2 = makeCard(icons: [.rally, .hqEvent])
        let engine = ActionDeckEngine(cards: [card1, card2])
        let result = engine.grenadeAttack(count: 2, canJammed: false)
        XCTAssertEqual(result, .success)
    }

    func testGrenade_multipleIcons_twoGrenades_returnCriticalHit() {
        let card1 = makeCard(icons: [.grenade, .jam])
        let card2 = makeCard(icons: [.grenade, .cover])
        let engine = ActionDeckEngine(cards: [card1, card2])
        let result = engine.grenadeAttack(count: 2, canJammed: false)
        XCTAssertEqual(result, .criticalHit)
    }
}
