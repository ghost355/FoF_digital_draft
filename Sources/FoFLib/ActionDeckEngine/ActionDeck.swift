// ActionDeck.swift

final class ActionDeck {
    private var drawDeck: [ActionCard]
    private var discardPile: [ActionCard] = []
    private var hand: [ActionCard] = []

    init(actionDeck: [ActionCard]) {
        drawDeck = actionDeck.shuffled()
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

    var count: Int { drawDeck.count + discardPile.count }

}

extension ActionDeck {
    private func drawOneCard() -> ActionCard {
        let reshuffleCardId = 51
        var card = drawDeck.removeLast()
        if card.id == reshuffleCardId {
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
