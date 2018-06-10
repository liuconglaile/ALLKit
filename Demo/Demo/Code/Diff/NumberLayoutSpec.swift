import Foundation
import UIKit
import ALLKit

final class NumberLayoutSpec: LayoutSpec {
    private let number: Int

    init(number: Int) {
        self.number = number
    }

    override func makeNode() -> Node {
        let attributedText = String(number).attributed()
            .font(.boldSystemFont(ofSize: 36))
            .foregroundColor(UIColor.white)
            .make()

        let numberNode = Node(text: attributedText) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = attributedText
        }

        return Node(children: [numberNode], config: { node in
            node.alignItems = .center
            node.justifyContent = .center
        }) { (view: UIView, firstTime) in
            if firstTime {
                view.layer.cornerRadius = 4
                view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            }
        }
    }
}
