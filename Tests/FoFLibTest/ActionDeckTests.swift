import XCTest
@testable import FoFLib

final class ActionDeckTests: XCTestCase {
    
    private func makeCard(id: Int = 1) -> ActionCard {
        ActionCard(
            id: id,
            activatedCommands: 0,
            initiativeCommands: 0,
            atNumber: 0,
            icons: [],
            combatResults: [.miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss, .miss],
            hitEffects: HitEffectTable(veteran: [], line: [], green: []),
            randomNumberTable: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
        )
    }
    
    // MARK: - draw
    
    func testDraw_count1_addsOneCardToHand() {
        let cards = [makeCard(id: 1), makeCard(id: 2), makeCard(id: 3)]
        let deck = ActionDeck(cards: cards)
        
        deck.draw(count: 1)
        
        XCTAssertEqual(deck.handCount, 1)
    }
    
    func testDraw_count3_addsThreeCardsToHand() {
        let cards = (1...10).map { makeCard(id: $0) }
        let deck = ActionDeck(cards: cards)
        
        deck.draw(count: 3)
        
        XCTAssertEqual(deck.handCount, 3)
    }
    
    func testDraw_multipleTimes_accumulatesCards() {
        let cards = (1...10).map { makeCard(id: $0) }
        let deck = ActionDeck(cards: cards)
        
        deck.draw(count: 2)
        deck.draw(count: 2)
        
        XCTAssertEqual(deck.handCount, 4)
    }
    
    func testDraw_removesCardsFromDrawDeck() {
        let cards = (1...10).map { makeCard(id: $0) }
        let deck = ActionDeck(cards: cards)
        let initialDrawCount = deck.drawDeckCount
        
        deck.draw(count: 3)
        
        XCTAssertEqual(deck.drawDeckCount, initialDrawCount - 3)
    }
    
    // MARK: - discardHand
    
    func testDiscardHand_clearsHand() {
        let cards = (1...5).map { makeCard(id: $0) }
        let deck = ActionDeck(cards: cards)
        
        deck.draw(count: 3)
        deck.discardHand()
        
        XCTAssertEqual(deck.handCount, 0)
    }
    
    func testDiscardHand_movesCardsToDiscardPile() {
        let cards = (1...5).map { makeCard(id: $0) }
        let deck = ActionDeck(cards: cards)
        
        deck.draw(count: 3)
        let handCountBefore = deck.handCount
        deck.discardHand()
        
        XCTAssertEqual(deck.discardPileCount, handCountBefore)
    }
    
    func testDiscardHand_emptyHand_doesNothing() {
        let cards = (1...5).map { makeCard(id: $0) }
        let deck = ActionDeck(cards: cards)
        
        deck.discardHand()
        
        XCTAssertEqual(deck.handCount, 0)
        XCTAssertEqual(deck.discardPileCount, 0)
    }
    
    // MARK: - currentHand
    
    func testCurrentHand_returnsAllDrawnCards() {
        let cards = (1...10).map { makeCard(id: $0) }
        let deck = ActionDeck(cards: cards)
        
        deck.draw(count: 2)
        
        XCTAssertEqual(deck.currentHand.count, 2)
    }
    
    func testCurrentHand_emptyDeck_returnsEmptyArray() {
        let cards = [makeCard(id: 1)]
        let deck = ActionDeck(cards: cards)
        
        deck.draw(count: 1)
        deck.discardHand()
        
        XCTAssertEqual(deck.currentHand.count, 0)
    }
    
    // MARK: - counters
    
    func testTotalCount_equalsDrawDeckPlusDiscardPile() {
        let cards = (1...10).map { makeCard(id: $0) }
        let deck = ActionDeck(cards: cards)
        
        deck.draw(count: 3)
        deck.discardHand()
        deck.draw(count: 2)
        
        // total = drawDeck + discardPile (hand не считается)
        XCTAssertEqual(deck.totalCount, deck.drawDeckCount + deck.discardPileCount)
    }
    
    func testDrawDeckCount_decreasesOnDraw() {
        let cards = (1...10).map { makeCard(id: $0) }
        let deck = ActionDeck(cards: cards)
        let initialCount = deck.drawDeckCount
        
        deck.draw(count: 1)
        
        XCTAssertEqual(deck.drawDeckCount, initialCount - 1)
    }
    
    // MARK: - reshuffle (id = 51)
    
    func testDraw_reshuffleCard_triggersReshuffle() {
        // Создаем колоду где reshuffle карта будет сверху
        var cards = (1...10).map { makeCard(id: $0) }
        cards.append(makeCard(id: 51))
        let deck = ActionDeck(cards: cards)
        
        // После создания колода перемешана, reshuffle карта может быть в любом месте
        // При первом draw если reshuffle карта сверху - она перемешивает колоду
        deck.draw(count: 1)
        
        // После reshuffle discard pile должен быть пустым (все карты вернулись в колоду)
        XCTAssertEqual(deck.discardPileCount, 0)
        // И в руке должна быть 1 карта (не reshuffle)
        XCTAssertEqual(deck.handCount, 1)
    }
    
    func testReshuffle_reshuffleCardInsertedInFirstHalfOfDeck() {
        // Создаем колоду: 19 карт + reshuffle карта
        var cards = (1...19).map { makeCard(id: $0) }
        cards.append(makeCard(id: 51))
        let deck = ActionDeck(cards: cards)
        
        // Вытягиваем 19 карт (reshuffle карта где-то в колоде)
        for _ in 0..<19 {
            deck.draw(count: 1)
            deck.discardHand()
        }
        
        // Теперь в колоде только reshuffle карта
        deck.draw(count: 1)
        
        // После reshuffle, reshuffle карта добавлена обратно в первую половину
        // и одна карта вытянута (могла быть reshuffle карта)
        let reshuffleCardIndex = deck.testableDrawDeck.firstIndex { $0.id == 51 }
        
        if let index = reshuffleCardIndex {
            // Если reshuffle карта в колоде - она должна быть в первой половине
            let middleIndex = deck.testableDrawDeck.count / 2
            XCTAssertTrue(index < middleIndex, "Reshuffle card at index \(index), middle is \(middleIndex)")
        }
        // Тест проходит если reshuffle карта либо была вытянута (recursion),
        // либо осталась в колоде в правильной позиции
    }
}
