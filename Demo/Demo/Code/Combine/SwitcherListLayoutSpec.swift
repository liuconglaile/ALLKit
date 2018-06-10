import Foundation
import UIKit
import ALLKit

final class SwitcherListLayoutSpec: LayoutSpec {
    private let titleList: [String]

    init(titleList: [String]) {
        self.titleList = titleList
    }

    override func makeNode() -> Node {
        let children = titleList.flatMap({ title -> [Node] in
            let switcherNode = SwitcherRowLayoutSpec(title: title).makeNode()

            let separatorNode = SwitcherRowSeparatorLayoutSpec().makeNode()

            return [switcherNode, separatorNode]
        })

        return Node(children: children, config: { node in
            node.flexDirection = .column
        })
    }
}
