import Foundation
import UIKit
import ALLKit

final class OutgoingTextMessageLayoutSpec: LayoutSpec {
    private let text: String
    private let date: Date

    init(text: String, date: Date) {
        self.text = text
        self.date = date
    }

    override func makeNode() -> Node {
        let attributedText = text.attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(UIColor.white)
            .make()

        let attributedDateText = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: DateFormatter.Style.short).attributed()
            .font(.italicSystemFont(ofSize: 10))
            .foregroundColor(UIColor.white)
            .make()

        let tailNode = Node(config: { node in
            node.positionType = .absolute
            node.width = 20
            node.height = 18
            node.bottom = 0
            node.right = -6
        }) { (imageView: UIImageView, firstTime) in
            if firstTime {
                imageView.superview?.sendSubview(toBack: imageView)
                imageView.image = #imageLiteral(resourceName: "tail").withRenderingMode(.alwaysTemplate)
                imageView.tintColor = ChatColors.outgoing
            }
        }

        let textNode = Node(text: attributedText, config: { node in
            node.flexShrink = 1
            node.marginRight = 8
        }) { (label: AsyncLabel, _) in
            label.text = attributedText
        }

        let dateNode = Node(text: attributedDateText) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = attributedDateText
        }

        let infoNode = Node(children: [dateNode], config: { node in
            node.marginBottom = 2
            node.flexDirection = .row
            node.alignItems = .center
            node.alignSelf = .flexEnd
        })

        let backgroundNode = Node(children: [tailNode, textNode, infoNode], config: { node in
            node.flexDirection = .row
            node.alignItems = .center
            node.padding(top: 8, left: 16, bottom: 8, right: 8)
            node.margin(top: nil, left: 30%, bottom: 8, right: 16)
            node.minHeight = 36
        }) { (view: UIView, firstTime) in
            if firstTime {
                view.backgroundColor = ChatColors.outgoing
                view.layer.cornerRadius = 18
            }
        }

        return Node(children: [backgroundNode], config: { node in
            node.alignItems = .center
            node.flexDirection = .rowReverse
        })
    }
}
