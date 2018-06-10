import Foundation
import UIKit
import ALLKit
import yoga

final class MailRowLayoutSpec: LayoutSpec {
    private let title: String
    private let text: String

    init(title: String, text: String) {
        self.title = title
        self.text = text
    }

    override func makeNode() -> Node {
        let attributedTitle = title.attributed()
            .font(.boldSystemFont(ofSize: 16))
            .foregroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            .make()

        let attributedText = text.attributed()
            .font(.systemFont(ofSize: 12))
            .foregroundColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
            .make()

        let titleNode = Node(text: attributedTitle, config: { node in
            node.maxHeight = 56
            node.marginBottom = 4
        }) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = attributedTitle
        }

        let textNode = Node(text: attributedText, config: { node in
            node.maxHeight = 40
        }) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = attributedText
        }

        let contentNode = Node(children: [titleNode, textNode], config: { node in
            node.margin(top: 12, left: 16, bottom: 12, right: 8)
            node.flex = 1
        })

        let separatorNode = Node(config: { node in
            node.height = YGValue(1.0/UIScreen.main.scale)
            node.marginLeft = 16
        }) { (view: UIView, firstTime) in
            if firstTime {
                view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        }

        return Node(children: [contentNode, separatorNode], config: { node in
            node.flexDirection = .column
        })
    }
}
