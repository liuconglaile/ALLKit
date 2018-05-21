import Foundation
import UIKit
import ALLKit

final class SwitcherListLayoutView: UIView {}

final class SwitcherListLayoutDescription: ViewLayoutDescription<SwitcherListLayoutView> {
    init(titleList: [String]) {
        super.init { viewFactories -> YogaNode in
            let rootNode = YogaNode({ node in
                node.flexDirection = .column
            })

            titleList.forEach({ title in
                let switcherNode = SwitcherRowLayoutDescription(title: title).makeNode(&viewFactories)

                let separatorNode = SwitcherRowSeparatorLayoutDescription().makeNode(&viewFactories)

                rootNode
                    .add(switcherNode)
                    .add(separatorNode)
            })

            return rootNode
        }
    }
}
