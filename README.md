# ALLKit ![travis](https://travis-ci.org/geor-kasapidi/ALLKit.svg?branch=master) [![codecov](https://codecov.io/gh/geor-kasapidi/ALLKit/branch/master/graph/badge.svg)](https://codecov.io/gh/geor-kasapidi/ALLKit)

A declarative data-driven framework for rapid development of smooth UI.

## Main features

* **Stable and safe**. Battle-tested solution, used in app with millions of users (in top of russian AppStore).
* **Fast**. Main thread is free from layout and text rendering. So, UI works as fast as possible (include views with reuse, such as UICollectionView).
* **Easy to use**. Flexbox for layout (thanks to [Yoga](https://yogalayout.com)) and swifty UIKit adapters save dev time. 

## Installation

`pod 'ALLKit', :git => 'https://github.com/geor-kasapidi/ALLKit', :tag => 'v0.0.2'`

## Example

![trump](example.jpg)

#### Component

```swift
final class FeedItemLayoutSpec: LayoutSpec {
    private let title: NSAttributedString
    private let subtitle: NSAttributedString
    private let avatar: UIImage?

    init(item: FeedItem) {
        title = item.title.attributed()
            .font(UIFont.boldSystemFont(ofSize: 16))
            .foregroundColor(UIColor.blue)
            .make()

        subtitle = DateFormatter.localizedString(from: item.date, dateStyle: .medium, timeStyle: .short).attributed()
            .font(UIFont.systemFont(ofSize: 12))
            .foregroundColor(UIColor.lightGray)
            .make()

        avatar = item.avatar
    }

    override func makeNode() -> Node {
        let title = self.title
        let subtitle = self.subtitle
        let avatar = self.avatar

        let avatarNode = Node(config: { node in
            node.width = 40
            node.height = 40
            node.marginRight = 8
        }) { (imageView: UIImageView, firstTime) in
            if firstTime {
                imageView.contentMode = .scaleAspectFill
                imageView.backgroundColor = UIColor.lightGray
                imageView.layer.cornerRadius = 20
                imageView.layer.masksToBounds = true
            }

            imageView.image = avatar
        }

        let titleNode = Node(text: title, config: { node in
            node.marginBottom = 2
        }) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = title
        }

        let subtitleNode = Node(text: subtitle) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = subtitle
        }

        let textContainerNode = Node(children: [titleNode, subtitleNode], config: { node in
            node.flexDirection = .column
            node.flex = 1
        })

        return Node(children: [avatarNode, textContainerNode], config: { node in
            node.padding(all: 8)
            node.flexDirection = .row
            node.alignItems = .center
        })
    }
}
```

#### Plain usage

```swift
let item = FeedItem(...)

let boundingSize = BoundingSize(width: view.bounds.width, height: .nan)

let layout = FeedItemLayoutSpec(item: item).makeLayoutWith(boundingSize: boundingSize)

let view = UIView()

layout.setup(in: view)
```

#### UICollectionView usage

```swift
final class FeedViewController: UIViewController {
    private let adapter = CollectionViewAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(adapter.collectionView)

        adapter.set(items: makeItems())
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        adapter.collectionView.frame = view.bounds

        adapter.set(boundingSize: BoundingSize(width: view.bounds.width, height: .nan))
    }

    private func makeItems() -> [ListViewItem] {
        return (0..<100).map { _ -> ListViewItem in
            let item = FeedItem(...)

            let listItem = ListItem(
                id: item.id,
                model: item,
                layoutSpec: FeedItemLayoutSpec(item: item)
            )

            return listItem
        }
    }
}
```
