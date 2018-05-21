import Foundation
import UIKit
import ALLKit
import yoga

final class IncomingTextMessageLayoutView: UIView {}

final class IncomingTextMessageLayoutDescription: ViewLayoutDescription<IncomingTextMessageLayoutView> {
    init(text: String, date: Date) {
        let attributedText = text.attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(UIColor.black)
            .make()

        let attributedDateText = DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: DateFormatter.Style.short).attributed()
            .font(.italicSystemFont(ofSize: 10))
            .foregroundColor(UIColor.black.withAlphaComponent(0.6))
            .make()

        super.init { viewFactories -> YogaNode in
            let root = YogaNode({ node in
                node.alignItems = .center
                node.flexDirection = .row
            })

            let backgroundNode = YogaNode({ node in
                node.flexDirection = .row
                node.alignItems = .center
                node.paddingTop = 8
                node.paddingBottom = 8
                node.paddingLeft = 12
                node.paddingRight = 12
                node.marginLeft = 16
                node.marginRight = 30%
                node.marginBottom = 8
                node.minHeight = 36
            }).viewFactory(&viewFactories, { (view: UIView, firstTime) in
                if firstTime {
                    view.backgroundColor = ChatColors.incoming
                    view.layer.cornerRadius = 18
                }
            })

            let tailNode = YogaNode({ node in
                node.positionType = .absolute
                node.width = 20
                node.height = 18
                node.bottom = 0
                node.left = -6
            }).viewFactory(&viewFactories, { (imageView: UIImageView, firstTime) in
                if firstTime {
                    imageView.image = #imageLiteral(resourceName: "tail").withRenderingMode(.alwaysTemplate)
                    imageView.tintColor = ChatColors.incoming
                    imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
                }
            })

            let textNode = YogaTextNode({ node in
                node.flexShrink = 1
                node.marginRight = 8
            }).labelFactory(&viewFactories, text: attributedText)

            let infoNode = YogaNode({ node in
                node.marginBottom = 2
                node.flexDirection = .row
                node.alignItems = .center
                node.alignSelf = .flexEnd
            })

            let dateNode = YogaTextNode().labelFactory(&viewFactories, text: attributedDateText)

            root
                .add(backgroundNode
                    .add(textNode)
                    .add(tailNode)
                    .add(infoNode
                        .add(dateNode)))

            return root
        }
    }
}
