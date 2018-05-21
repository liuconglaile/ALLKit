import Foundation
import UIKit
import ALLKit
import yoga

final class CircleAndSquareLayoutView: UIView {}

final class CircleAndSquareLayoutDescription: ViewLayoutDescription<CircleAndSquareLayoutView> {
    init() {
        super.init { viewFactories -> YogaNode in
            let rootNode = YogaNode()

            let circleNode = YogaNode({ node in
                node.width = 80
                node.height = 80
                node.positionType = .absolute
                node.left = YGValue(value: Float(arc4random() % 70), unit: .percent)
                node.top = YGValue(value: Float(arc4random() % 70), unit: .percent)
            }).viewFactory(&viewFactories, { (view: UIView, firstTime) in
                if firstTime {
                    view.layer.cornerRadius = 40
                    view.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                }
            })

            let squareNode = YogaNode({ node in
                node.width = YGValue(Float(arc4random() % 40) + 40)
                node.height = YGValue(Float(arc4random() % 40) + 40)
                node.positionType = .absolute
                node.left = YGValue(value: Float(arc4random() % 70), unit: .percent)
                node.top = YGValue(value: Float(arc4random() % 70), unit: .percent)
            }).viewFactory(&viewFactories, { (view: UIView, firstTime) in
                if firstTime {
                    view.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                }
            })

            rootNode
                .add(circleNode)
                .add(squareNode)

            return rootNode
        }
    }
}
