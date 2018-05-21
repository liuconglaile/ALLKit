import Foundation
import UIKit
import ALLKit

final class NumberLayoutView: UIView {}

final class NumberLayoutDescription: ViewLayoutDescription<NumberLayoutView> {
    init(number: Int) {
        let attributedText = String(number).attributed()
            .font(.boldSystemFont(ofSize: 36))
            .foregroundColor(UIColor.white)
            .make()

        super.init { viewFactories -> YogaNode in
            let rootNode = YogaNode({ node in
                node.alignItems = .center
                node.justifyContent = .center
            }).viewFactory(&viewFactories, { (view: UIView, firstTime) in
                if firstTime {
                    view.layer.cornerRadius = 4
                    view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                }
            })

            let numberNode = YogaTextNode().labelFactory(&viewFactories, text: attributedText)

            rootNode.add(numberNode)

            return rootNode
        }
    }
}
