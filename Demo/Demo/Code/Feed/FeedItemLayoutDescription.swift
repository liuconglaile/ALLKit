import Foundation
import UIKit
import ALLKit
import YYWebImage

final class FeedItemLayoutView: UIView {}

final class FeedItemLayoutDescription: ViewLayoutDescription<FeedItemLayoutView> {
    init(item: FeedItem) {
        let attributedTitleText = item.title.attributed()
            .font(.boldSystemFont(ofSize: 16))
            .foregroundColor(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))
            .make()

        let attributedDateText = DateFormatter.localizedString(from: item.date, dateStyle: .medium, timeStyle: .short).attributed()
            .font(.systemFont(ofSize: 12))
            .foregroundColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
            .make()

        let attributedLikesCountText = String(item.likesCount).attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
            .make()

        let attributedViewsCountText = String(item.viewsCount).attributed()
            .font(.systemFont(ofSize: 14))
            .foregroundColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
            .make()

        super.init { viewFactories -> YogaNode in
            let rootNode = YogaNode({ node in
                node.flexDirection = .column
            })

            // top content

            let topNode: YogaNode

            do {
                topNode = YogaNode({ node in
                    node.paddingTop = 8
                    node.paddingLeft = 16
                    node.paddingRight = 16
                    node.paddingBottom = 8
                    node.flexDirection = .row
                    node.alignItems = .center
                })

                let avatarNode = YogaNode({ node in
                    node.width = 40
                    node.height = 40
                    node.marginRight = 16
                }).viewFactory(&viewFactories, { (imageView: UIImageView, firstTime) in
                    if firstTime {
                        imageView.contentMode = .scaleAspectFill
                        imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                        imageView.layer.cornerRadius = 20
                        imageView.layer.masksToBounds = true
                    }

                    imageView.yy_setImage(with: item.avatar, options: [.setImageWithFadeAnimation])
                })

                let titleNode = YogaTextNode({ node in
                    node.marginBottom = 2
                }).labelFactory(&viewFactories, text: attributedTitleText)

                let dateNode = YogaTextNode().labelFactory(&viewFactories, text: attributedDateText)

                let textContainerNode = YogaNode({ node in
                    node.flexDirection = .column
                    node.flex = 1
                })

                topNode
                    .add(avatarNode)
                    .add(textContainerNode
                        .add(titleNode)
                        .add(dateNode))
            }

            // image

            let imageNode = YogaNode({ node in
                node.aspectRatio = 1
            }).viewFactory(&viewFactories, { (imageView: UIImageView, firstTime) in
                if firstTime {
                    imageView.contentMode = .scaleAspectFill
                    imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }

                imageView.yy_setImage(with: item.image, options: [.setImageWithFadeAnimation])
            })

            // bottom content

            let bottomNode: YogaNode

            do {
                bottomNode = YogaNode({ node in
                    node.paddingTop = 8
                    node.paddingLeft = 24
                    node.paddingRight = 24
                    node.paddingBottom = 8
                    node.flexDirection = .row
                    node.justifyContent = .spaceBetween
                })

                // likes

                let likesNode: YogaNode

                do {
                    likesNode = YogaNode({ node in
                        node.flexDirection = .row
                        node.alignItems = .center
                    })

                    let imageNode = YogaNode({ node in
                        node.width = 24
                        node.height = 24
                        node.marginRight = 4
                    }).viewFactory(&viewFactories, { (imageView: UIImageView, firstTime) in
                        if firstTime {
                            imageView.contentMode = .scaleAspectFit
                            imageView.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                            imageView.image = #imageLiteral(resourceName: "heart").withRenderingMode(.alwaysTemplate)
                        }
                    })

                    let textNode = YogaTextNode().labelFactory(&viewFactories, text: attributedLikesCountText)

                    likesNode
                        .add(imageNode)
                        .add(textNode)
                }

                // views

                let viewsNode: YogaNode

                do {
                    viewsNode = YogaNode({ node in
                        node.flexDirection = .row
                        node.alignItems = .center
                    })

                    let imageNode = YogaNode({ node in
                        node.width = 24
                        node.height = 24
                        node.marginRight = 4
                    }).viewFactory(&viewFactories, { (imageView: UIImageView, firstTime) in
                        if firstTime {
                            imageView.contentMode = .scaleAspectFit
                            imageView.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                            imageView.image = #imageLiteral(resourceName: "watched").withRenderingMode(.alwaysTemplate)
                        }
                    })

                    let textNode = YogaTextNode().labelFactory(&viewFactories, text: attributedViewsCountText)

                    viewsNode
                        .add(imageNode)
                        .add(textNode)
                }

                bottomNode
                    .add(likesNode)
                    .add(viewsNode)
            }

            rootNode
                .add(topNode)
                .add(imageNode)
                .add(bottomNode)

            return rootNode
        }
    }
}
