import Foundation
import UIKit
import ALLKit

final class SwitcherRowLayoutSpec: LayoutSpec {
    private let title: String

    init(title: String) {
        self.title = title
    }

    override func makeNode() -> Node {
        let attributedTitle = title.attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            .make()

        let titleNode = Node(text: attributedTitle) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = attributedTitle
        }

        let switcherNode = Node(config: { node in
            node.width = 51
            node.height = 32
            node.marginLeft = 8
        }) { (switcher: UISwitch, firstTime) in
            if firstTime {
                switcher.clipsToBounds = true

                switcher.onTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)

                switcher.setOn(true, animated: false)
            }

            switcher.handle(.valueChanged, { [weak switcher] in
                guard let switcher = switcher else { return }

                switcher.superview?.viewWithTag(switcher.tag - 1)?.alpha = switcher.isOn ? 1 : 0.3
            })
        }

        let contentNode = Node(children: [titleNode, switcherNode], config: { node in
            node.flexDirection = .row
            node.margin(top: 12, left: 16, bottom: 12, right: 16)
            node.alignItems = .center
            node.justifyContent = .spaceBetween
        })

        return Node(children: [contentNode])
    }
}
