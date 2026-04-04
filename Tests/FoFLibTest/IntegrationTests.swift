import XCTest

@testable import FoFLib

final class IntegrationTests: XCTestCase {

    private var engine: ActionDeckEngine!
    private var cards: [ActionCard]!

    override func setUp() {
        super.setUp()
        cards = loadJSON(
            "realActionDeck",
            as: [ActionCard].self,
            from: .module
        )
        engine = ActionDeckEngine(cards: cards)
    }

    override func tearDown() {
        engine = nil
        cards = nil
        super.tearDown()
    }

    // MARK: - Real Deck Behavior

    func testRealDeck_combatResult_returnsValidResults() {
        let result = engine.combatResult(ncm: 0)
        XCTAssertTrue(result == .hit || result == .pin || result == .miss)
    }

    func testRealDeck_randomNumber_returnsValue() {
        let value = engine.randomNumber(5)
        let card = engine.deck.currentHand.first ?? cards[0]
        XCTAssertTrue(card.randomNumberTable.contains(value))
    }

    // MARK: - Deck State

    func testRealDeck_initialDeckHasCards() {
        XCTAssertGreaterThan(engine.deck.totalCount, 0)
        XCTAssertGreaterThan(engine.deck.drawDeckCount, 0)
    }

    func testRealDeck_drawDecreasesDeck() {
        let initial = engine.deck.drawDeckCount
        _ = engine.infiltration(count: 1)
        XCTAssertEqual(engine.deck.drawDeckCount, initial - 1)
    }

    // MARK: - Functions Return Valid Results

    func testRealDeck_hqEvent_returnsValidResult() {
        let result = engine.hqEvent()
        XCTAssertTrue(result == .success || result == .failure)
    }

    func testRealDeck_infiltration_returnsValidResult() {
        let result = engine.infiltration(count: 1)
        XCTAssertTrue(result == .success || result == .failure)
    }

    func testRealDeck_cover_returnsValidResult() {
        let result = engine.cover(count: 1)
        XCTAssertTrue(result == .success || result == .failure)
    }

    func testRealDeck_rally_returnsValidResult() {
        let result = engine.rally(count: 1)
        XCTAssertTrue(result == .success || result == .failure)
    }

    func testRealDeck_callForFire_returnsValidResult() {
        let result = engine.callForFire(count: 1, hasBnFireMission: false)
        XCTAssertTrue(result == .success || result == .failure || result == .short)
    }

    func testRealDeck_grenadeAttack_returnsValidResult() {
        let result = engine.grenadeAttack(count: 1, canJammed: true)
        XCTAssertTrue(result == .success || result == .failure || 
                     result == .jam || result == .criticalHit)
    }

    // MARK: - Hit Effects

    func testRealDeck_hitEffect_allExperienceLevels() {
        let veteranEffects = engine.hitEffect(experience: .veteran)
        let lineEffects = engine.hitEffect(experience: .line)
        let greenEffects = engine.hitEffect(experience: .green)
        
        XCTAssertNotNil(veteranEffects)
        XCTAssertNotNil(lineEffects)
        XCTAssertNotNil(greenEffects)
    }
}
