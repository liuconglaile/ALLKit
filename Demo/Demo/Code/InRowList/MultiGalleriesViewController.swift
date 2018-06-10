import Foundation
import UIKit
import ALLKit

final class MultiGalleriesViewController: UIViewController {
    private let adapter = CollectionViewAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            view.backgroundColor = UIColor.white

            view.addSubview(adapter.collectionView)

            adapter.collectionView.backgroundColor = UIColor.white
        }

        do {
            let listItems = DemoContent.NATO.map { name -> ListItem in
                let images = (0..<100).map { _ in URL(string: "https://picsum.photos/400/300?random&q=\(arc4random())")! }

                let listItem = ListItem(
                    id: name,
                    model: name,
                    layoutSpec: GalleryItemLayoutSpec(name: name, images: images)
                )

                return listItem
            }

            adapter.set(items: listItems)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        adapter.collectionView.frame = view.bounds

        adapter.set(boundingSize: BoundingSize(width: view.bounds.width))
    }
}
