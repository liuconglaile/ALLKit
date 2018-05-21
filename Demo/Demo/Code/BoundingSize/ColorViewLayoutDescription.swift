import Foundation
import UIKit
import ALLKit

final class ColorViewLayoutView: UIView {}

final class ColorViewLayoutDescription: ViewLayoutDescription<ColorViewLayoutView> {
    init() {
        super.init { viewFactories -> YogaNode in
            let rootNode = YogaNode()

            let viewNode = YogaNode({ node in
                node.height = 64
            }).viewFactory(&viewFactories, { (view: UIView, firstTime) in
                let color = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)

                view.backgroundColor = color
            })

            rootNode.add(viewNode)

            return rootNode
        }
    }
}
