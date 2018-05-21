import Foundation
import UIKit
import ALLKit

final class SelectableRowLayoutView: UIView {}

final class SelectableRowLayoutDescription: ViewLayoutDescription<SelectableRowLayoutView> {
    init(text: String) {
        let attributedText = text.attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            .make()

        super.init { viewFactories -> YogaNode in
            let rootNode = YogaNode({ node in
                node.paddingLeft = 16
                node.paddingTop = 12
                node.paddingBottom = 12
                node.paddingRight = 8
                node.flexDirection = .row
                node.alignItems = .center
                node.justifyContent = .spaceBetween
            })

            let textNode = YogaTextNode({ node in
                node.flex = 1
            }).labelFactory(&viewFactories, text: attributedText)

            let arrowNode = YogaNode({ node in
                node.width = 24
                node.height = 24
                node.marginLeft = 6
            }).viewFactory(&viewFactories, { (imageView: UIImageView, firstTime) in
                if firstTime {
                    imageView.contentMode = .scaleAspectFit
                    imageView.tintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                }

                imageView.image = #imageLiteral(resourceName: "arrow_right").withRenderingMode(.alwaysTemplate)
            })

            rootNode
                .add(textNode)
                .add(arrowNode)

            return rootNode
        }
    }
}
