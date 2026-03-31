// ActionDeck.swift

final class ActionDeck {
    private var drawDeck: [ActionCard]
    private var discardPile: [ActionCard] = []
    private var hand: [ActionCard] = []

    init(cards: [ActionCard]) {
        drawDeck = cards.shuffled()
    }

    func draw(count: Int) {
        for _ in (0..<count) {
            hand.append(drawOneCard())
        }
    }

    func discardHand() {
        discardPile += hand
        hand.removeAll()
    }

    var currentHand: [ActionCard] { hand }

    var totalCount: Int { drawDeck.count + discardPile.count }
    var drawDeckCount: Int { drawDeck.count }
    var discardPileCount: Int { discardPile.count }
    var handCount: Int { hand.count }
    
    var testableDrawDeck: [ActionCard] { drawDeck }

}

extension ActionDeck {
    private func drawOneCard() -> ActionCard {
        var card = drawDeck.removeLast()
        if card.isReshuffleCard {
            reshuffleDeck(reshuffleCard: card)
            card = drawOneCard()
        }
        return card
    }

    private func reshuffleDeck(reshuffleCard: ActionCard) {
        drawDeck += discardPile
        discardPile.removeAll()
        drawDeck.shuffle()
        let middeDeck = drawDeck.count / 2
        let randomIndex = Int.random(in: 0..<middeDeck)
        drawDeck.insert(reshuffleCard, at: randomIndex)
    }
}
