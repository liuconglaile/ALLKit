import Foundation
import UIKit
import ALLKit
import YYWebImage

final class FeedItemLayoutSpec: LayoutSpec {
    private let item: FeedItem

    init(item: FeedItem) {
        self.item = item
    }

    override func makeNode() -> Node {
        let topNode = makeTopNode()

        let image = item.image

        let imageNode = Node(config: { node in
            node.aspectRatio = 1
        }) { (imageView: UIImageView, firstTime) in
            if firstTime {
                imageView.contentMode = .scaleAspectFill
                imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }

            imageView.yy_setImage(with: image, options: [.setImageWithFadeAnimation])
        }

        let bottomNode = Node(children: [makeLikesNode(), makeViewsNode()], config: { node in
            node.padding(top: 8, left: 24, bottom: 8, right: 24)
            node.flexDirection = .row
            node.justifyContent = .spaceBetween
        })

        return Node(children: [topNode, imageNode, bottomNode], config: { node in
            node.flexDirection = .column
        })
    }

    private func makeTopNode() -> Node {
        let attributedTitleText = item.title.attributed()
            .font(.boldSystemFont(ofSize: 16))
            .foregroundColor(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
            .make()

        let attributedDateText = DateFormatter.localizedString(from: item.date, dateStyle: .medium, timeStyle: .short).attributed()
            .font(.systemFont(ofSize: 12))
            .foregroundColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
            .make()

        let avatar = item.avatar

        let avatarNode = Node(config: { node in
            node.width = 40
            node.height = 40
            node.marginRight = 16
        }) { (imageView: UIImageView, firstTime) in
            if firstTime {
                imageView.contentMode = .scaleAspectFill
                imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                imageView.layer.cornerRadius = 20
                imageView.layer.masksToBounds = true
            }

            imageView.yy_setImage(with: avatar, options: [.setImageWithFadeAnimation])
        }

        let titleNode = Node(text: attributedTitleText, config: { node in
            node.marginBottom = 2
        }) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = attributedTitleText
        }

        let dateNode = Node(text: attributedDateText) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = attributedDateText
        }

        let textContainerNode = Node(children: [titleNode, dateNode], config: { node in
            node.flexDirection = .column
            node.flex = 1
        })

        return Node(children: [avatarNode, textContainerNode], config: { node in
            node.padding(top: 8, left: 16, bottom: 8, right: 16)
            node.flexDirection = .row
            node.alignItems = .center
        })
    }

    private func makeLikesNode() -> Node {
        let attributedLikesCountText = String(item.likesCount).attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
            .make()

        let imageNode = Node(config: { node in
            node.width = 24
            node.height = 24
            node.marginRight = 4
        }) { (imageView: UIImageView, firstTime) in
            if firstTime {
                imageView.contentMode = .scaleAspectFit
                imageView.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                imageView.image = #imageLiteral(resourceName: "heart").withRenderingMode(.alwaysTemplate)
            }
        }

        let textNode = Node(text: attributedLikesCountText) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = attributedLikesCountText
        }

        return Node(children: [imageNode, textNode], config: { node in
            node.flexDirection = .row
            node.alignItems = .center
        })
    }

    private func makeViewsNode() -> Node {
        let attributedViewsCountText = String(item.viewsCount).attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
            .make()

        let imageNode = Node(config: { node in
            node.width = 24
            node.height = 24
            node.marginRight = 4
        }) { (imageView: UIImageView, firstTime) in
            if firstTime {
                imageView.contentMode = .scaleAspectFit
                imageView.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                imageView.image = #imageLiteral(resourceName: "watched").withRenderingMode(.alwaysTemplate)
            }
        }

        let textNode = Node(text: attributedViewsCountText) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = attributedViewsCountText
        }

        return Node(children: [imageNode, textNode], config: { node in
            node.flexDirection = .row
            node.alignItems = .center
        })
    }
}
