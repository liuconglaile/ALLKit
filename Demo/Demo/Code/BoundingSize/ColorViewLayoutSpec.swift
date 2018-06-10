import Foundation
import UIKit
import ALLKit

final class ColorViewLayoutSpec: LayoutSpec {
    override func makeNode() -> Node {
        let viewNode = Node(config: { node in
            node.height = 64
        }) { (view: UIView, firstTime) in
            let color = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)

            view.backgroundColor = color
        }

        return Node(children: [viewNode])
    }
}
