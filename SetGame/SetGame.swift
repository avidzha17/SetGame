//
//  SetGame.swift
//  SetGame
//
//  Created by user184779 on 2/28/21.
//

import Foundation

struct SetGame {
    
    let emptyCard = Card(picture: Card.Picture.circle, parameters: ["numberOfCards": 0, "color": 0, "texture": 0], id: 0)
    
    private(set) var deck = Deck()
    private(set) var playedCards = Set<Card>()
    private(set) var choosenCards = Set<Card>()
    var changedCards = Dictionary<Card, Card>()
    private(set) var deletedCards = Set<Card>()
    var score = 0
    
    mutating func chooseCard(card: Card) {
        if !choosenCards.contains(card), choosenCards.count == 2 {
            var listForMatching = [Bool]()
            let firstChoosenCard = choosenCards.popFirst()!
            let secondChoosenCard = choosenCards.popFirst()!
            
            if card.picture == firstChoosenCard.picture, card.picture == secondChoosenCard.picture, firstChoosenCard.picture == secondChoosenCard.picture {
                listForMatching.append(true)
            } else if card.picture != firstChoosenCard.picture, card.picture != secondChoosenCard.picture, firstChoosenCard.picture != secondChoosenCard.picture {
                listForMatching.append(true)
            }
            
            if card.parameters["numberOfPictures"] == firstChoosenCard.parameters["numberOfPictures"], card.parameters["numberOfPictures"] == secondChoosenCard.parameters["numberOfPictures"], firstChoosenCard.parameters["numberOfPictures"] == secondChoosenCard.parameters["numberOfPictures"] {
                listForMatching.append(true)
            } else if card.parameters["numberOfPictures"] != firstChoosenCard.parameters["numberOfPictures"], card.parameters["numberOfPictures"] != secondChoosenCard.parameters["numberOfPictures"], firstChoosenCard.parameters["numberOfPictures"] != secondChoosenCard.parameters["numberOfPictures"] {
                listForMatching.append(true)
            }
            
            if card.parameters["color"] == firstChoosenCard.parameters["color"], card.parameters["color"] == secondChoosenCard.parameters["color"], firstChoosenCard.parameters["color"] == secondChoosenCard.parameters["color"] {
                listForMatching.append(true)
            } else if card.parameters["color"] != firstChoosenCard.parameters["color"], card.parameters["color"] != secondChoosenCard.parameters["color"], firstChoosenCard.parameters["color"] != secondChoosenCard.parameters["color"] {
                listForMatching.append(true)
            }
            
            if card.parameters["texture"] == firstChoosenCard.parameters["texture"], card.parameters["texture"] == secondChoosenCard.parameters["texture"], firstChoosenCard.parameters["texture"] == secondChoosenCard.parameters["texture"] {
                listForMatching.append(true)
            } else if card.parameters["texture"] != firstChoosenCard.parameters["texture"], card.parameters["texture"] != secondChoosenCard.parameters["texture"], firstChoosenCard.parameters["texture"] != secondChoosenCard.parameters["texture"] {
                listForMatching.append(true)
            }
            
            if listForMatching.count == 4 {
                score += 5
                playedCards = Set(playedCards.map { currentCard -> Card in
                    if currentCard == card || currentCard == firstChoosenCard || currentCard == secondChoosenCard {
                        if let newCard = drawOneCard() {
                            changedCards[currentCard] = newCard
                            return newCard
                        } else {
                            deletedCards.insert(currentCard)
                            return emptyCard
                        }
                    } else {
                        return currentCard
                    }
                })
                playedCards = playedCards.filter { $0 != emptyCard }
            } else {
                score -= 3
            }
            choosenCards.removeAll()
        } else if !choosenCards.contains(card) {
            choosenCards.insert(card)
        } else {
            choosenCards.remove(card)
            score -= 1
        }
    }
    
    private mutating func drawOneCard() -> Card? {
        if let randomCard = deck.allCards.randomElement() {
            deck.allCards.remove(randomCard)
            playedCards.insert(randomCard)
            return randomCard
        } else {
            return nil
        }
    }
    
    mutating func drawThreeCards() -> Set<Card> {
        var newCards = Set<Card>()
        for _ in 1...3 {
            if let newCard = drawOneCard() {
                playedCards.insert(newCard)
                newCards.insert(newCard)
            }
        }
        return newCards
    }
    
    init() {
        for _ in 1...12 {
            guard drawOneCard() != nil else {
                return
            }
        }
    }
}
