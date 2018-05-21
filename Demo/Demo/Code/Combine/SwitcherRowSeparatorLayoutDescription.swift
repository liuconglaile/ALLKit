import Foundation
import UIKit
import ALLKit
import yoga

final class SwitcherRowSeparatorLayoutView: UIView {}

final class SwitcherRowSeparatorLayoutDescription: ViewLayoutDescription<SwitcherRowSeparatorLayoutView> {
    init() {
        super.init { viewFactories -> YogaNode in
            let rootNode = YogaNode({ node in
                node.paddingLeft = 16
                node.paddingRight = 0
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
