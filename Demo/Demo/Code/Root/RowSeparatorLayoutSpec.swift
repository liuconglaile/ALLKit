import Foundation
import UIKit
import ALLKit
import yoga

final class RowSeparatorLayoutSpec: LayoutSpec {
    private let paddingLeft: Float
    private let paddingRight: Float

    init(paddingLeft: Float = 16, paddingRight: Float = 0) {
        self.paddingLeft = paddingLeft
        self.paddingRight = paddingRight
    }

    override func makeNode() -> Node {
        let paddingLeft = self.paddingLeft
        let paddingRight = self.paddingRight

        let viewNode = Node(config: { node in
            node.height = YGValue(1.0/UIScreen.main.scale)
        }) { (view: UIView, firstTime) in
            if firstTime {
                view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
        }

        return Node(children: [viewNode], config: { node in
            node.paddingLeft = YGValue(paddingLeft)
            node.paddingRight = YGValue(paddingRight)
        })
    }
}
