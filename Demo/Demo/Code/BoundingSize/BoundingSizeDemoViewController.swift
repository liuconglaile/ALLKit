import Foundation
import UIKit
import ALLKit

final class BoundingSizeDemoViewController: UIViewController {
    private let adapter = CollectionViewAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            view.backgroundColor = UIColor.white
            
            view.addSubview(adapter.collectionView)
            
            adapter.collectionView.backgroundColor = UIColor.white
        }
        
        do {
            adapter.set(items: generateItems())
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        adapter.collectionView.frame = view.bounds

        adapter.set(boundingSize: BoundingSize(width: view.bounds.width))
    }

    private func generateItems() -> [ListItem] {
        var items = [ListItem]()

        (0..<100).forEach { _ in
            let n = Int(arc4random_uniform(5))

            (0..<n).forEach { _ in
                let id = UUID().uuidString

                let listItem = ListItem(
                    id: id,
                    model: id,
                    layoutSpec: ColorViewLayoutSpec()
                )

                listItem.boundingSizeModifier = { bs in
                    BoundingSize(width: (bs.width / CGFloat(n)).rounded(.down))
                }

                items.append(listItem)
            }
        }

        return items
    }
}
