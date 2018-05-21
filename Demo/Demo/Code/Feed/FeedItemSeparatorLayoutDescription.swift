import Foundation
import UIKit
import ALLKit
import yoga

final class FeedItemSeparatorLayoutView: UIView {}

final class FeedItemSeparatorLayoutDescription: ViewLayoutDescription<FeedItemSeparatorLayoutView> {
    init() {
        super.init { viewFactories -> YogaNode in
            let rootNode = YogaNode()

            let backgroundNode = YogaNode({ node in
                node.flexDirection = .column
                node.justifyContent = .spaceBetween
                node.height = 8
            }).viewFactory(&viewFactories, { (view: UIView, firstTime) in
                if firstTime {
                    view.backgroundColor = #colorLiteral(red: 0.9398509844, green: 0.9398509844, blue: 0.9398509844, alpha: 1)
                }
            })

            let topLineNode = YogaNode({ node in
                node.height = YGValue(1.0/UIScreen.main.scale)
            }).viewFactory(&viewFactories, { (view: UIView, firstTime) in
                if firstTime {
                    view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }
            })

            let bottomLineNode = YogaNode({ node in
                node.height = YGValue(1.0/UIScreen.main.scale)
            }).viewFactory(&viewFactories, { (view: UIView, firstTime) in
                if firstTime {
                    view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }
            })

            rootNode
                .add(backgroundNode
                    .add(topLineNode)
                    .add(bottomLineNode))

            return rootNode
        }
    }
}
