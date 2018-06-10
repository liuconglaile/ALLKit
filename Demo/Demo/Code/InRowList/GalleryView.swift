import Foundation
import UIKit
import ALLKit

final class GalleryView: UIView {
    private lazy var adapter: CollectionViewAdapter = {
        let adapter = CollectionViewAdapter(scrollDirection: .horizontal)
        adapter.collectionView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        addSubview(adapter.collectionView)
        return adapter
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        adapter.collectionView.frame = bounds

        adapter.set(boundingSize: BoundingSize(height: bounds.height))
    }

    var images: [URL] = [] {
        didSet {
            let listItems = images.map { url -> ListItem in
                ListItem(
                    id: url.absoluteString,
                    model: url,
                    layoutSpec: GalleryPhotoLayoutSpec(url: url)
                )
            }

            adapter.collectionView.setContentOffset(.zero, animated: false)

            adapter.set(items: listItems)
        }
    }
}
