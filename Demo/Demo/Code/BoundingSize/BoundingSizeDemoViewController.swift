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

        adapter.set(boundingSize: BoundingSize(width: view.bounds.width, height: .nan))
    }

    private func generateItems() -> [ListViewItem] {
        var items = [ListViewItem]()

        (0..<100).forEach { _ in
            let n = Int(arc4random_uniform(5))

            (0..<n).forEach { _ in
                let layoutDescription = ColorViewLayoutDescription()

                let id = UUID().uuidString

                var listItem = ListItem(id: id, model: id, layoutDescription: layoutDescription)

                listItem.boundingSizeModifier = { bs in
                    BoundingSize(width: (bs.width / CGFloat(n)).rounded(.down), height: .nan)
                }

                items.append(listItem)
            }
        }

        return items
    }
}
