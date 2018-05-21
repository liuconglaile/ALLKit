# ALLKit ![travis](https://travis-ci.org/geor-kasapidi/ALLKit.svg?branch=master)

A declarative data-driven framework for rapid development of smooth UI.

## Example

![trump](Demo/example.jpg)

```swift
import Foundation
import UIKit
import ALLKit

struct FeedItem: Equatable {
    let id = UUID().uuidString
    let avatar: UIImage?
    let title: String
    let date: Date

    static func ==(lhs: FeedItem, rhs: FeedItem) -> Bool {
        return lhs.id == rhs.id
    }
}

final class FeedItemLayoutView: UIView {}

final class FeedItemLayoutDescription: ViewLayoutDescription<FeedItemLayoutView> {
    init(item: FeedItem) {
        let title = item.title.attributed()
            .font(UIFont.boldSystemFont(ofSize: 16))
            .foregroundColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
            .make()

        let subtitle = DateFormatter.localizedString(from: item.date, dateStyle: .medium, timeStyle: .short).attributed()
            .font(UIFont.systemFont(ofSize: 12))
            .foregroundColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
            .make()

        super.init { viewFactories -> YogaNode in
            let rootNode = YogaNode({ node in
                node.paddingTop = 8
                node.paddingLeft = 8
                node.paddingRight = 8
                node.paddingBottom = 8
                node.flexDirection = .row
                node.alignItems = .center
            })

            let avatarNode = YogaNode({ node in
                node.width = 40
                node.height = 40
                node.marginRight = 8
            }).viewFactory(&viewFactories, { (imageView: UIImageView, firstTime) in
                if firstTime {
                    imageView.contentMode = .scaleAspectFill
                    imageView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    imageView.layer.cornerRadius = 20
                    imageView.layer.masksToBounds = true
                }

                imageView.image = item.avatar
            })

            let textContainerNode = YogaNode({ node in
                node.flexDirection = .column
                node.flex = 1
            })

            let titleNode = YogaTextNode({ node in
                node.marginBottom = 2
            }).labelFactory(&viewFactories, text: title)

            let subtitleNode = YogaTextNode().labelFactory(&viewFactories, text: subtitle)

            rootNode
                .add(avatarNode)
                .add(textContainerNode
                    .add(titleNode)
                    .add(subtitleNode))

            return rootNode
        }
    }
}
```
