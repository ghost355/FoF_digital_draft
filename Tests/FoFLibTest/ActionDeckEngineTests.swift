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

    // MARK: - callForFire

    func testCallForFire_cardHasShortIcon_returnShort() {
        let card = makeCard(icons: [.short])
        let engine = ActionDeckEngine(cards: [card])
        let result = engine.callForFire(count: 1, hasBnFireMission: true)
        XCTAssertEqual(result, .short)
    }

    func testCallForFire_cardHasShortIcon_tripleBurstAndBnFireMission_returnShort() {
        let card1 = makeCard(icons: [.short])
        let card2 = makeCard(icons: [.tripleBurst])
        let engine = ActionDeckEngine(cards: [card1, card2])
        let result = engine.callForFire(count: 2, hasBnFireMission: true)
        XCTAssertEqual(result, .short)
    }

    func testCallForFire_hasBnFireMissionAndTripleBurst_returnBnFireMission() {
        let card = makeCard(icons: [.tripleBurst])
        let engine = ActionDeckEngine(cards: [card])
        let result = engine.callForFire(count: 1, hasBnFireMission: true)
        XCTAssertEqual(result, .bnFireMisson)
    }

    func testCallForFire_hasBnFireMissionAndBurst_returnSuccess() {
        let card = makeCard(icons: [.burst])
        let engine = ActionDeckEngine(cards: [card])
        let result = engine.callForFire(count: 1, hasBnFireMission: true)
        XCTAssertEqual(result, .success)
    }

    func testCallForFire_cardHasBurstIcon_returnSuccess() {
        let card = makeCard(icons: [.burst])
        let engine = ActionDeckEngine(cards: [card])
        let result = engine.callForFire(count: 1, hasBnFireMission: false)
        XCTAssertEqual(result, .success)
    }

    func testCallForFire_cardHasTripleBurstIcon_returnSuccess() {
        let card = makeCard(icons: [.tripleBurst])
        let engine = ActionDeckEngine(cards: [card])
        let result = engine.callForFire(count: 1, hasBnFireMission: false)
        XCTAssertEqual(result, .success)
    }

    func testCallForFire_noRelevantIcons_returnFailure() {
        let card1 = makeCard(icons: [.contact])
        let card2 = makeCard(icons: [.cover])
        let card3 = makeCard(icons: [.rally])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.callForFire(count: 3, hasBnFireMission: false)
        XCTAssertEqual(result, .failure)
    }

    func testCallForFire_multipleCards_oneHasBurstIcon_returnSuccess() {
        let card1 = makeCard(icons: [.contact])
        let card2 = makeCard(icons: [.burst])
        let card3 = makeCard(icons: [.jam])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.callForFire(count: 3, hasBnFireMission: false)
        XCTAssertEqual(result, .success)
    }

    func testCallForFire_multipleCards_oneHasTripleBurstIcon_returnSuccess() {
        let card1 = makeCard(icons: [.contact])
        let card2 = makeCard(icons: [.tripleBurst])
        let card3 = makeCard(icons: [.jam])
        let engine = ActionDeckEngine(cards: [card1, card2, card3])
        let result = engine.callForFire(count: 3, hasBnFireMission: false)
        XCTAssertEqual(result, .success)
    }

    // MARK: - exhort

    func testExhort_noPreviousFailure_returnsNil() {
        let card = makeCard(icons: [.cover])
        let engine = ActionDeckEngine(cards: [card])
        XCTAssertNil(engine.exhort())
    }

    func testExhort_afterSuccessfulInfiltration_returnsNil() {
        let card = makeCard(icons: [.infiltrate])
        let engine = ActionDeckEngine(cards: [card, card, card])
        _ = engine.infiltration(count: 1)
        XCTAssertNil(engine.exhort())
    }

    func testExhort_afterFailedInfiltration_drawsOneCard() {
        let card1 = makeCard(icons: [.cover])
        let card2 = makeCard(icons: [.infiltrate])
        let engine = ActionDeckEngine(cards: [card1, card2, card1, card2])
        let handBefore = engine.deck.handCount
        _ = engine.infiltration(count: 1)
        _ = engine.exhort()
        XCTAssertEqual(engine.deck.handCount, handBefore + 1)
    }

    func testExhort_canOnlyBeUsedOnce() {
        let failCard = makeCard(icons: [.cover])
        let successCard = makeCard(icons: [.infiltrate])
        let engine = ActionDeckEngine(cards: [failCard, successCard, successCard, successCard])
        _ = engine.infiltration(count: 1)
        _ = engine.exhort()
        XCTAssertNil(engine.exhort())
    }

    func testExhort_afterFailedCover_drawsOneCard() {
        let failCard = makeCard(icons: [.rally])
        let engine = ActionDeckEngine(cards: Array(repeating: failCard, count: 10))
        let handBefore = engine.deck.handCount
        _ = engine.cover(count: 1)
        _ = engine.exhort()
        XCTAssertEqual(engine.deck.handCount, handBefore + 1)
    }

    func testExhort_afterFailedSpotting_drawsOneCard() {
        let failCard = makeCard(icons: [.rally])
        let engine = ActionDeckEngine(cards: Array(repeating: failCard, count: 10))
        let handBefore = engine.deck.handCount
        _ = engine.spotting(count: 1)
        _ = engine.exhort()
        XCTAssertEqual(engine.deck.handCount, handBefore + 1)
    }

    func testExhort_afterFailedContact_drawsOneCard() {
        let failCard = makeCard(icons: [.rally])
        let engine = ActionDeckEngine(cards: Array(repeating: failCard, count: 10))
        let handBefore = engine.deck.handCount
        _ = engine.contact(count: 1)
        _ = engine.exhort()
        XCTAssertEqual(engine.deck.handCount, handBefore + 1)
    }

    func testExhort_afterFailedRally_drawsOneCard() {
        let failCard = makeCard(icons: [.cover])
        let engine = ActionDeckEngine(cards: [failCard, failCard, failCard, failCard])
        let handBefore = engine.deck.handCount
        _ = engine.rally(count: 1)
        _ = engine.exhort()
        XCTAssertEqual(engine.deck.handCount, handBefore + 1)
    }

    func testExhort_afterFailedGrenade_drawsOneCard() {
        let failCard = makeCard(icons: [.burst])
        let engine = ActionDeckEngine(cards: Array(repeating: failCard, count: 10))
        let handBefore = engine.deck.handCount
        _ = engine.grenadeAttack(count: 1, canJammed: false)
        _ = engine.exhort()
        XCTAssertEqual(engine.deck.handCount, handBefore + 1)
    }

    func testExhort_afterJam_cannotBeUsed() {
        let jamCard = makeCard(icons: [.jam])
        let engine = ActionDeckEngine(cards: [jamCard, jamCard, jamCard])
        _ = engine.grenadeAttack(count: 1, canJammed: true)
        XCTAssertNil(engine.exhort())
    }

    func testExhort_afterFailedConcentrateFire_drawsOneCard() {
        let failCard = makeCard(icons: [.burst])
        let engine = ActionDeckEngine(cards: Array(repeating: failCard, count: 10))
        let handBefore = engine.deck.handCount
        _ = engine.concentrateFire(count: 1, canJammed: false)
        _ = engine.exhort()
        XCTAssertEqual(engine.deck.handCount, handBefore + 1)
    }

    func testExhort_afterFailedCallForFire_drawsOneCard() {
        let failCard = makeCard(icons: [.contact])
        let engine = ActionDeckEngine(cards: Array(repeating: failCard, count: 10))
        let handBefore = engine.deck.handCount
        _ = engine.callForFire(count: 1, hasBnFireMission: false)
        _ = engine.exhort()
        XCTAssertEqual(engine.deck.handCount, handBefore + 1)
    }

    func testExhort_multipleFailsOnlyFirstAttemptSaved() {
        let failCard = makeCard(icons: [.cover])
        let engine = ActionDeckEngine(cards: Array(repeating: failCard, count: 20))
        _ = engine.infiltration(count: 1)
        _ = engine.infiltration(count: 1)
        _ = engine.exhort()
        XCTAssertNil(engine.exhort())
    }
}
