import Foundation
import UIKit
import ALLKit

final class SelectableRowLayoutSpec: LayoutSpec {
    private let text: String

    init(text: String) {
        self.text = text
    }

    override func makeNode() -> Node {
        let attributedText = text.attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            .make()

        let textNode = Node(text: attributedText, config: { node in
            node.flex = 1
        }) { (label: AsyncLabel, _) in
            label.text = attributedText
        }

        let arrowNode = Node(config: { node in
            node.width = 24
            node.height = 24
            node.marginLeft = 6
        }) { (imageView: UIImageView, firstTime) in
            if firstTime {
                imageView.contentMode = .scaleAspectFit
                imageView.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }

            imageView.image = #imageLiteral(resourceName: "arrow_right").withRenderingMode(.alwaysTemplate)
        }

        return Node(children: [textNode, arrowNode], config: { node in
            node.padding(top: 12, left: 16, bottom: 12, right: 8)
            node.flexDirection = .row
            node.alignItems = .center
            node.justifyContent = .spaceBetween
        })
    }
}
