//
//  ViewController.swift
//  SetGame
//
//  Created by user184779 on 2/28/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var draw3CardsButton: UIButton!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var cardsView: CardsView! {
        didSet {
            let rotation = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards(_:)))
            cardsView.addGestureRecognizer(rotation)
        }
    }
    
    private var game = SetGame()
    private lazy var cardsForInit = game.playedCards
    private var viewForCard = Dictionary<UIView, Card>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newGameInit()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    private func newGameInit() {
        game = SetGame()
        
        viewForCard.removeAll()
        cardsForInit = game.playedCards
        for view in cardsView.subviews {
            view.removeFromSuperview()
        }
        viewForCard = viewForCardInit()
        updateUI()

        draw3CardsButton.isHidden = false
    }
    
    private func viewForCardInit() -> Dictionary<UIView, Card> {
        
        let cardsPerRow = makeArrayWithNumberOfCardsPerRow()
        var arrayOfRect = getArrayOfRect(byArrayOfNumbers: cardsPerRow)
        
        for _ in game.playedCards {
            if let card = cardsForInit.popFirst() {
                
                let rect = arrayOfRect.removeFirst()
                let view = UIView(frame: rect)
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnCard(_:)))
                view.addGestureRecognizer(tap)
                
                cardsView.addSubview(view)
                viewForCard[view] = card
            }
        }
        return viewForCard
    }
    
    private func updateViewForCard() -> Dictionary<UIView, Card> {
                
        let cardsPerRow = makeArrayWithNumberOfCardsPerRow()
        if !cardsPerRow.isEmpty {
            var arrayOfRect = getArrayOfRect(byArrayOfNumbers: cardsPerRow)
            
            for item in viewForCard {
                if let newRect = arrayOfRect.first {

                    item.key.frame = newRect
                    if item.key.gestureRecognizers == nil {
                        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnCard(_:)))
                        item.key.addGestureRecognizer(tap)
                    }
                    arrayOfRect.removeFirst()
                }
            }
        } else {
            viewForCard.removeAll()
        }
        return viewForCard
    }
    
    private func getArrayOfRect(byArrayOfNumbers array: [Int]) -> [CGRect] {
        
        var arrayOfRect = [CGRect]()
        
        let width = Int(cardsView.bounds.width) / array[0]
        let height = Int(cardsView.bounds.height) / array.count
        
        for columnIndex in 1...array.count {
            for rowIndex in 1...array[0] {
                let x = rowIndex * width - width
                let y = columnIndex * height - height
                let cardRect = CGRect(x: x.offsetX, y: y.offsetY, width: width.offsetWidth, height: height.offsetHeight)
                arrayOfRect.append(cardRect)
            }
        }
        return arrayOfRect
    }
    
    @objc private func tapOnCard(_ sender: UITapGestureRecognizer) {
        if let currentView = sender.view,  let card = viewForCard[currentView] {
            game.chooseCard(card: card)
            updateUI()
        }
    }
    
    @objc private func shuffleCards(_ sender: UIRotationGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended {
            var cards = viewForCard.values.shuffled()
            for (view, _) in viewForCard {
                viewForCard[view] = cards.removeFirst()
            }
            updateUI()
        }
    }
    
    @objc private func rotated() {
        updateUI()
    }
    
    private func makeArrayWithNumberOfCardsPerRow() -> [Int] {
        
        let amount = UInt(game.playedCards.count)
        var array = [Int]()
        
        switch amount {
        case 0...12 : array = makeArrayOfRows(withNumbers: 3, fromAmount: amount)
        case 13...28 : array = makeArrayOfRows(withNumbers: 4, fromAmount: amount)
        case 29...40 : array = makeArrayOfRows(withNumbers: 5, fromAmount: amount)
        case 41...54 : array = makeArrayOfRows(withNumbers: 6, fromAmount: amount)
        case 55...70 : array = makeArrayOfRows(withNumbers: 7, fromAmount: amount)
        case 71...81 : array = makeArrayOfRows(withNumbers: 8, fromAmount: amount)
        default:  break
        }
        return array
    }
    
    private func makeArrayOfRows(withNumbers number: UInt, fromAmount amount: UInt) -> [Int] {
        var array = [Int]()
        var sum = amount
        while sum > number {
            array.append(Int(number))
            sum -= number
        }
        if sum > 0 {
            array.append(Int(sum))
        }
        return array
    }

    @IBAction private func touchOnNewGameButton(_ sender: UIButton) {
        newGameInit()
        updateUI()
    }
    
    @IBAction private func touchOnDraw3CardsButton(_ sender: UIButton) {
        let newCards = game.drawThreeCards()
        for card in newCards {
            let newView = UIView()
            cardsView.addSubview(newView)
            viewForCard[newView] = card
        }
        game.score -= 5
        viewForCard = updateViewForCard()
        updateUI()
    }
    
    private func updateUI() {
    
        let score = game.score
        scoreLabel.text = "Score: \(score)"

        if game.deck.allCards.isEmpty {
            draw3CardsButton.isHidden = true
        }

        if !game.changedCards.isEmpty {
            for (view, card) in viewForCard {
                if game.changedCards.keys.contains(card) {
                    viewForCard[view] = game.changedCards[card]
                    game.changedCards.removeValue(forKey: card)
                }
            }
        }
        
        if !game.deletedCards.isEmpty {
            let dictForDeleting = viewForCard
            for item in dictForDeleting {
                if game.deletedCards.contains(item.value) {
                    viewForCard.removeValue(forKey: item.key)
                    item.key.removeFromSuperview()

                }
            }
        }
        cardsView.viewForCard = updateViewForCard()
        cardsView.choosenCards = game.choosenCards
    }
}

extension Int {
    var offsetX: Int {
        return self + 3
    }
    var offsetY: Int {
        return self + 3
    }
    var offsetWidth: Int {
        return self - 6
    }
    var offsetHeight: Int {
        return self - 6
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

