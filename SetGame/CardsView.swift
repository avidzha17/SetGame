//
//  CardsView.swift
//  SetGame
//
//  Created by user184779 on 3/4/21.
//

import UIKit

class CardsView: UIView {
    
    var choosenCards = Set<Card>() { didSet { setNeedsLayout(); setNeedsDisplay() } }
    
    var viewForCard = Dictionary<UIView, Card>() { didSet { setNeedsLayout(); setNeedsDisplay() } }

    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        UIColor.lightGray.set()
        roundedRect.fill()
        drawViews()
    }
    
    private func drawViews() {
        
        for index in viewForCard {
            if choosenCards.contains(index.value) {
                let strokeRoundedRect = UIBezierPath(roundedRect: index.key.frame, cornerRadius: cornerRadius)
                UIColor.blue.set()
                strokeRoundedRect.lineWidth = choosenCardLineWidth
                strokeRoundedRect.stroke()
            }

            let roundedRect = UIBezierPath(roundedRect: index.key.frame, cornerRadius: cornerRadius)
            UIColor.white.set()
            roundedRect.fill()

            let rectForOneCard = index.key.frame
            drawPicture(in: rectForOneCard, with: index.value)

        }
    }
    
    private func drawPicture(in rect: CGRect, with card: Card) {
        
        var attributes = [NSAttributedString.Key: Any]()
        
        var text = card.picture.rawValue
        text.multiply(onNumber: card.parameters["numberOfPictures"]!)
        
        let colorOfPicture: UIColor
        switch card.parameters["color"] {
        case 1: colorOfPicture = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case 2: colorOfPicture = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        case 3: colorOfPicture = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        default: colorOfPicture = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
        
        switch card.parameters["texture"] {
        case 1: attributes[NSAttributedString.Key.strokeWidth] = -1
            attributes[NSAttributedString.Key.foregroundColor] = colorOfPicture
        case 2: attributes[NSAttributedString.Key.foregroundColor] = colorOfPicture.withAlphaComponent(0.5)
        case 3: attributes[NSAttributedString.Key.strokeWidth] = 10
            attributes[NSAttributedString.Key.foregroundColor] = colorOfPicture
        default: attributes[NSAttributedString.Key.strokeWidth] = -1
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        
        attributes[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: rect.fontOfPicture)
        
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        
        attributedString.draw(with: rect.offsetBy(dx: 0, dy: rect.offsetYForPicture), options: .usesLineFragmentOrigin, context: .none)
            
    }
}

extension CardsView {
    
    var cornerRadius: CGFloat {
        return 10
    }
    
    var choosenCardLineWidth: CGFloat {
        return 5
    }
}

extension CGRect {
    
    var offsetYForPicture: CGFloat {
        return self.height / 2.8
    }
    
    var fontOfPicture: CGFloat {
        switch self.height {
        case 201...1000 : return 55
        case 157...200 : return 30
        case 124...156 : return 28
        case 102...123 : return 24
        case 74...101 : return 19
        case 65...73 : return 13
        case 0...64 : return 12
        default:  return 0
        }
    }
}
