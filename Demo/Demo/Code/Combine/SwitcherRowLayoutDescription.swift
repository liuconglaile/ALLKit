import Foundation
import UIKit
import ALLKit

final class SwitcherRowLayoutView: UIView {}

final class SwitcherRowLayoutDescription: ViewLayoutDescription<SwitcherRowLayoutView> {
    init(title: String) {
        let attributedTitle = title.attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            .make()

        super.init { viewFactories -> YogaNode in
            let rootNode = YogaNode()

            let contentNode = YogaNode({ node in
                node.flexDirection = .row
                node.marginLeft = 16
                node.marginRight = 12
                node.marginTop = 12
                node.marginBottom = 12
                node.alignItems = .center
                node.justifyContent = .spaceBetween
            })

            let titleNode = YogaTextNode().labelFactory(&viewFactories, text: attributedTitle)

            let switcherNode = YogaNode({ node in
                node.width = 51
                node.height = 32
                node.marginLeft = 8
            }).viewFactory(&viewFactories, { (switcher: UISwitch, firstTime) in
                if firstTime {
                    switcher.onTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)

                    switcher.setOn(true, animated: false)
                }

                switcher.handle(.valueChanged, { [weak switcher] in
                    guard let switcher = switcher else { return }

                    switcher.superview?.viewWithTag(switcher.tag - 1)?.alpha = switcher.isOn ? 1 : 0.3
                })
            })

            rootNode
                .add(contentNode
                    .add(titleNode)
                    .add(switcherNode))

            return rootNode
        }
    }
}
