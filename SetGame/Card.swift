//
//  Card.swift
//  SetGame
//
//  Created by user184779 on 2/28/21.
//

import Foundation

struct Card: Hashable {
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let picture: Picture
    let parameters: Dictionary<String, Int>
    let id: Int
    
    private static var IDFactory = 0
    
    enum Picture: String, CaseIterable {
        case triangle = "▲"
        case circle = "●"
        case square = "■"
    }
    
    static func getID() -> Int {
        IDFactory += 1
        return IDFactory
    }
    
}
