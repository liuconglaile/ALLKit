import Foundation
import UIKit
import ALLKit

final class FeedViewController: UIViewController {
    private let adapter = CollectionViewAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            view.backgroundColor = UIColor.white

            view.addSubview(adapter.collectionView)

            adapter.collectionView.backgroundColor = UIColor.white
        }

        do {
            DispatchQueue.global().async {
                let items = self.generateItems()

                DispatchQueue.main.async {
                    self.adapter.set(items: items)
                }
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        adapter.collectionView.frame = view.bounds

        adapter.set(boundingSize: BoundingSize(width: view.bounds.width, height: .nan))
    }

    private func generateItems() -> [ListViewItem] {
        return (0..<100).flatMap { _ -> [ListViewItem] in
            let item = FeedItem(
                avatar: URL(string: "https://picsum.photos/100/100?random&q=\(arc4random())"),
                title: UUID().uuidString,
                date: Date(),
                image: URL(string: "https://picsum.photos/600/600?random&q=\(arc4random())"),
                likesCount: UInt(arc4random() % 100),
                viewsCount: UInt(arc4random() % 1000)
            )

            let listItem = ListItem(id: item.id, model: item, layoutDescription: FeedItemLayoutDescription(item: item))

            let sep = item.id + "_sep"

            let sepListItem = ListItem(id: sep, model: sep, layoutDescription: FeedItemSeparatorLayoutDescription())

            return [listItem, sepListItem]
        }
    }
}
