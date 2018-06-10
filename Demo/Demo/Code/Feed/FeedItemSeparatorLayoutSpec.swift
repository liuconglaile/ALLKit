import Foundation
import UIKit
import ALLKit
import yoga

final class FeedItemSeparatorLayoutSpec: LayoutSpec {
    override func makeNode() -> Node {
        let topLineNode = Node(config: { node in
            node.height = YGValue(1.0/UIScreen.main.scale)
        }) { (view: UIView, firstTime) in
            if firstTime {
                view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        }

        let bottomLineCode = Node(config: { node in
            node.height = YGValue(1.0/UIScreen.main.scale)
        }) { (view: UIView, firstTime) in
            if firstTime {
                view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        }

        let backgroundNode = Node(children: [topLineNode, bottomLineCode], config: { node in
            node.flexDirection = .column
            node.justifyContent = .spaceBetween
            node.height = 8
        }) { (view: UIView, firstTime) in
            if firstTime {
                view.backgroundColor = #colorLiteral(red: 0.9398509844, green: 0.9398509844, blue: 0.9398509844, alpha: 1)
            }
        }

        return Node(children: [backgroundNode])
    }
}
