//
//  ViewController.swift
//  SetGame
//
//  Created by user184779 on 2/28/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var draw3CardsButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGameInit()
    }
    
    private var game = SetGame()
    private var buttonForCardFromPlayedCards =  Dictionary<UIButton, Card>()
    private var amountOfActiveButtons = 12
    
    private func newGameInit() {
        game = SetGame()
        amountOfActiveButtons = 12
        buttonForCardFromPlayedCards.removeAll()
        draw3CardsButton.isHidden = false
        var cardsForInit = game.playedCards
        
        cardButtons.shuffle()
        for index in cardButtons.indices {
            let button = cardButtons[index]
            if index > amountOfActiveButtons - 1 {
                button.setTitle(nil, for: .normal)
                button.setAttributedTitle(nil, for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            } else {
                if let randomCard = cardsForInit.randomElement() {
                    buttonForCardFromPlayedCards[button] = randomCard
                    button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    button.setAttributedTitle(setUIForText(ofCard: randomCard), for: .normal)
                    cardsForInit.remove(randomCard)
                }
            }
        }
    }

    @IBAction private func tauchOnCardButton(_ sender: UIButton) {
        game.chooseCard(card: buttonForCardFromPlayedCards[sender] ?? game.emptyCard)
        updateUI()
    }
    
    @IBAction private func tauchOnNewGameButton(_ sender: UIButton) {
        newGameInit()
        updateUI()
    }
    
    @IBAction private func tauchOnDraw3CardsButton(_ sender: UIButton) {
        var newCards = game.drawThreeCards()
        for _ in 1...3 {
            let button = cardButtons[amountOfActiveButtons]
            buttonForCardFromPlayedCards[button] = newCards.popFirst()!
            button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            amountOfActiveButtons += 1
        }
        game.score -= 5
        updateUI()
    }
    
    private func updateUI() {
        let score = game.score
        scoreLabel.text = "Score: \(score)"
        
        if amountOfActiveButtons == 24 {
            draw3CardsButton.isHidden = true
        }
        
        if !game.changedCards.isEmpty {
            for (button, card) in buttonForCardFromPlayedCards {
                if game.changedCards.keys.contains(card) {
                    buttonForCardFromPlayedCards[button] = game.changedCards[card]
                    game.changedCards.removeValue(forKey: card)
                }
            }
        }
        
        for (button, card) in buttonForCardFromPlayedCards {
            if game.choosenCards.contains(card) {
                button.layer.borderWidth = 3
                button.layer.borderColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
                button.layer.cornerRadius = 10
            } else {
                button.layer.borderWidth = 0
                button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                button.layer.cornerRadius = 0
            }
            button.setAttributedTitle(setUIForText(ofCard: card), for: .normal)
        }
        
        if !game.deletedCards.isEmpty {
            for (button, card) in buttonForCardFromPlayedCards {
                if game.deletedCards.contains(card) {
                    button.setTitle(nil, for: .normal)
                    button.setAttributedTitle(nil, for: .normal)
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
                }
            }
        }
    }
    
    private func setUIForText(ofCard card: Card) -> NSAttributedString {
        
        var text = card.picture.rawValue
        text.multiply(onNumber: card.parameters["numberOfPictures"]!)
        
        var attributes = [NSAttributedString.Key: Any]()
        
        let color: UIColor
        if card.parameters["color"] == 1 {
            color = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        } else if card.parameters["color"] == 2 {
            color = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        } else {
            color = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
        
        if card.parameters["texture"] == 1 {
            attributes[NSAttributedString.Key.strokeWidth] = -1
            attributes[NSAttributedString.Key.foregroundColor] = color
        } else if card.parameters["texture"] == 2 {
            attributes[NSAttributedString.Key.foregroundColor] = color.withAlphaComponent(0.3)
        } else {
            attributes[NSAttributedString.Key.strokeWidth] = 5
            attributes[NSAttributedString.Key.foregroundColor] = color
        }
        
        let UIString = NSMutableAttributedString(string: text, attributes: attributes)
        return UIString
    }
    
}

extension String {
    mutating func multiply(onNumber number: Int) {
        var result = self
        if number > 1 {
            for _ in (1..<number).reversed() {
                result += self
            }
            self = result
        }
    }
}

