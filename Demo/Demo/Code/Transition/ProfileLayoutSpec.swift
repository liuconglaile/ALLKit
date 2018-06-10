import Foundation
import UIKit
import ALLKit
import YYWebImage

final class PortraitProfileLayoutSpec: LayoutSpec {
    private let profile: UserProfile

    init(profile: UserProfile) {
        self.profile = profile
    }

    override func makeNode() -> Node {
        let profile = self.profile

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

        let avatarNode = Node(config: { node in
            node.height = 100
            node.width = 100
            node.marginBottom = 24
        }) { (imageView: UIImageView, firstTime) in
            if firstTime {
                imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                imageView.layer.cornerRadius = 50
                imageView.layer.masksToBounds = true
                imageView.contentMode = .scaleAspectFill
            }

            imageView.yy_setImage(with: profile.avatar, options: .setImageWithFadeAnimation)
        }

        let nameNode = Node(text: attributedName, config: { node in
            node.marginBottom = 24
        }) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = attributedName
        }

        let descriptionNode = Node(text: attributedDescription) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = attributedDescription
        }

        return Node(children: [avatarNode, nameNode, descriptionNode], config: { node in
            node.flexDirection = .column
            node.padding(all: 24)
            node.alignItems = .center
        })
    }
}

final class LandscapeProfileLayoutSpec: LayoutSpec {
    private let profile: UserProfile

    init(profile: UserProfile) {
        self.profile = profile
    }

    override func makeNode() -> Node {
        let profile = self.profile
        
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

        let avatarNode = Node(config: { node in
            node.height = 100
            node.width = 100
            node.marginBottom = 24
        }) { (imageView: UIImageView, firstTime) in
            if firstTime {
                imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                imageView.layer.cornerRadius = 50
                imageView.layer.masksToBounds = true
                imageView.contentMode = .scaleAspectFill
            }

            imageView.yy_setImage(with: profile.avatar, options: .setImageWithFadeAnimation)
        }

        let nameNode = Node(text: attributedName) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = attributedName
        }

        let descriptionNode = Node(text: attributedDescription, config: { node in
            node.flex = 1
        }) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = attributedDescription
        }

        let leftNode = Node(children: [avatarNode, nameNode], config: { node in
            node.flexDirection = .column
            node.alignItems = .center
            node.marginRight = 24
        })

        return Node(children: [leftNode, descriptionNode], config: { node in
            node.flexDirection = .row
            node.padding(all: 24)
        })
    }
}
