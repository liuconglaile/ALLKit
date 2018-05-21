import Foundation
import UIKit

extension UICollectionView {
    func dequeueReusableCell<CellType: UICollectionViewCell>(_ indexPath: IndexPath, registeredCellIds: inout Set<String>) -> CellType {
        let cellId = String(describing: CellType.self)

        if registeredCellIds.insert(cellId).inserted {
            register(CellType.self, forCellWithReuseIdentifier: cellId)
        }

        return dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CellType
    }
}

final class CollectionViewGenericCell<ViewType: UIView>: UICollectionViewCell {
    lazy var internalContentView: ViewType = {
        let view = ViewType(frame: .zero)

        self.contentView.addSubview(view)

        return view
    }()
}

final class SwipeableCollectionViewGenericCell<ViewType: UIView>: UICollectionViewCell {
    lazy var swipeableView: SwipeableView = {
        let view = SwipeableView(frame: .zero)

        self.contentView.addSubview(view)

        return view
    }()

    lazy var internalContentView: ViewType = {
        let view = ViewType(frame: .zero)

        self.swipeableView.contentView.addSubview(view)

        return view
    }()

    override func prepareForReuse() {
        super.prepareForReuse()

        swipeableView.close(animated: false)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        swipeableView.frame = contentView.bounds
    }
}
