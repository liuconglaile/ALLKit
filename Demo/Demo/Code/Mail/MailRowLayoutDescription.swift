import Foundation
import UIKit
import ALLKit
import yoga

final class MailRowLayoutView: UIView {}

final class MailRowLayoutDescription: ViewLayoutDescription<MailRowLayoutView> {
    init(title: String, text: String) {
        let attributedTitle = title.attributed()
            .font(.boldSystemFont(ofSize: 16))
            .foregroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            .make()

        let attributedText = text.attributed()
            .font(.systemFont(ofSize: 12))
            .foregroundColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
            .make()

        super.init { viewFactories -> YogaNode in
            let rootNode = YogaNode({ node in
                node.flexDirection = .column
            })

            let contentNode = YogaNode({ node in
                node.marginLeft = 16
                node.marginTop = 12
                node.marginRight = 8
                node.marginBottom = 12
                node.flex = 1
            })

            let titleNode = YogaTextNode({ node in
                node.maxHeight = 56
                node.marginBottom = 4
            }).labelFactory(&viewFactories, text: attributedTitle)

            let textNode = YogaTextNode({ node in
                node.maxHeight = 40
            }).labelFactory(&viewFactories, text: attributedText)

            let separatorNode = YogaNode({ node in
                node.height = YGValue(1.0/UIScreen.main.scale)
                node.marginLeft = 16
            }).viewFactory(&viewFactories, { (view: UIView, firstTime) in
                if firstTime {
                    view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }
            })

            rootNode
                .add(contentNode
                    .add(titleNode)
                    .add(textNode))
                .add(separatorNode)

            return rootNode
        }
    }
}
