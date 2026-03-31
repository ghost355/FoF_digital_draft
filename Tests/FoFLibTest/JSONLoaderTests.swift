import XCTest
@testable import FoFLib

final class JSONLoaderTests: XCTestCase {
    
    func testLoadJSON_validFile_returnsDecodedData() {
        let cards: [ActionCard] = loadJSON(
            "testActionDeck",
            as: [ActionCard].self,
            from: .module
        )
        
        XCTAssertFalse(cards.isEmpty)
        XCTAssertEqual(cards.count, 2)
    }
    
    func testLoadJSON_validFile_decodesAllCardFields() {
        let cards: [ActionCard] = loadJSON(
            "testActionDeck",
            as: [ActionCard].self,
            from: .module
        )
        
        guard let card = cards.first else {
            XCTFail("Expected at least one card")
            return
        }
        
        XCTAssertEqual(card.id, 1)
        XCTAssertEqual(card.activatedCommands, 3)
        XCTAssertEqual(card.initiativeCommands, 2)
        XCTAssertEqual(card.atNumber, 5)
        XCTAssertEqual(card.icons, [.burst, .contact])
        XCTAssertEqual(card.randomNumberTable.count, 11)
    }
    
    func testLoadJSON_reshuffleCardExists() {
        let cards: [ActionCard] = loadJSON(
            "testActionDeck",
            as: [ActionCard].self,
            from: .module
        )
        
        let reshuffleCard = cards.first { $0.id == 51 }
        XCTAssertNotNil(reshuffleCard)
    }
}
