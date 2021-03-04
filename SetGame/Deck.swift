//
//  Deck.swift
//  SetGame
//
//  Created by user184779 on 2/28/21.
//

import Foundation

struct Deck {
    
    var allCards = Set<Card>()
    
    init() {
        for picture in Card.Picture.allCases {
            for numberOfPictures in 1...3 {
                for color in 1...3 {
                    for texture in 1...3 {
                        allCards.insert(Card(picture: picture, parameters: ["numberOfPictures": numberOfPictures, "color": color, "texture": texture], id: Card.getID()))

                    }
                }
            }
        }
    }
}
