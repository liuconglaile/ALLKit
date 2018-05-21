import Foundation
import UIKit
import ALLKit
import YYWebImage

final class ProfileLayoutView: UIView {}

final class PortraitProfileLayoutDescription: ViewLayoutDescription<ProfileLayoutView> {
    init(profile: UserProfile) {
        let attributedName = profile.name.attributed()
            .font(.boldSystemFont(ofSize: 24))
            .foregroundColor(UIColor.black)
            .alignment(.center)
            .make()

        let attributedDescription = profile.description.attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(UIColor.black)
            .alignment(.justified)
            .make()

        super.init { viewFactories -> YogaNode in
            let rootNode = YogaNode({ node in
                node.flexDirection = .column
                node.paddingLeft = 24
                node.paddingTop = 24
                node.paddingRight = 24
                node.paddingBottom = 24
                node.alignItems = .center
            })

            let avatarNode = YogaNode({ node in
                node.height = 100
                node.width = 100
                node.marginBottom = 24
            }).viewFactory(&viewFactories, { (imageView: UIImageView, firstTime) in
                if firstTime {
                    imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    imageView.layer.cornerRadius = 50
                    imageView.layer.masksToBounds = true
                    imageView.contentMode = .scaleAspectFill
                }

                imageView.yy_setImage(with: profile.avatar, options: .setImageWithFadeAnimation)
            })

            let nameNode = YogaTextNode({ node in
                node.marginBottom = 24
            }).labelFactory(&viewFactories, text: attributedName)

            let descriptionNode = YogaTextNode().labelFactory(&viewFactories, text: attributedDescription)

            rootNode
                .add(avatarNode)
                .add(nameNode)
                .add(descriptionNode)

            return rootNode
        }
    }
}

final class LandscapeProfileLayoutDescription: ViewLayoutDescription<ProfileLayoutView> {
    init(profile: UserProfile) {
        let attributedName = profile.name.attributed()
            .font(.boldSystemFont(ofSize: 24))
            .foregroundColor(UIColor.black)
            .alignment(.center)
            .make()

        let attributedDescription = profile.description.attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(UIColor.black)
            .alignment(.justified)
            .make()

        super.init { viewFactories -> YogaNode in
            let rootNode = YogaNode({ node in
                node.flexDirection = .row
                node.paddingLeft = 24
                node.paddingTop = 24
                node.paddingRight = 24
                node.paddingBottom = 24
            })

            let leftNode = YogaNode({ node in
                node.flexDirection = .column
                node.alignItems = .center
                node.marginRight = 24
            })

            let avatarNode = YogaNode({ node in
                node.height = 100
                node.width = 100
                node.marginBottom = 24
            }).viewFactory(&viewFactories, { (imageView: UIImageView, firstTime) in
                if firstTime {
                    imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    imageView.layer.cornerRadius = 50
                    imageView.layer.masksToBounds = true
                    imageView.contentMode = .scaleAspectFill
                }

                imageView.yy_setImage(with: profile.avatar, options: .setImageWithFadeAnimation)
            })

            let nameNode = YogaTextNode().labelFactory(&viewFactories, text: attributedName)

            let descriptionNode = YogaTextNode({ node in
                node.flex = 1
            }).labelFactory(&viewFactories, text: attributedDescription)

            rootNode
                .add(leftNode
                    .add(avatarNode)
                    .add(nameNode))
                .add(descriptionNode)

            return rootNode
        }
    }
}
