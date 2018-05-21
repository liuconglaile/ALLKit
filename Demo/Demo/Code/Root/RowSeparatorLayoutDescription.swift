import Foundation
import UIKit
import ALLKit
import yoga

final class RowSeparatorLayoutView: UIView {}

final class RowSeparatorLayoutDescription: ViewLayoutDescription<RowSeparatorLayoutView> {
    init(paddingLeft: Float = 16, paddingRight: Float = 0) {
        super.init { viewFactories -> YogaNode in
            let rootNode = YogaNode({ node in
                node.paddingLeft = YGValue(paddingLeft)
                node.paddingRight = YGValue(paddingRight)
            })

            let viewNode = YogaNode({ node in
                node.height = YGValue(1.0/UIScreen.main.scale)
            }).viewFactory(&viewFactories, { (view: UIView, firstTime) in
                if firstTime {
                    view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                }
            })

            rootNode.add(viewNode)

            return rootNode
        }
    }
}
