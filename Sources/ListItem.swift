import Foundation
import UIKit

public protocol ListViewCellModel {
    var size: CGSize { get }

    func cell(for indexPath: IndexPath, collectionView: UICollectionView, registeredCellIds: inout Set<String>) -> UICollectionViewCell

    var canSelect: Bool { get }
    var canCopy: Bool { get }
    var canMove: Bool { get }

    func onSelect()
    func onCopy()
}

public protocol ListViewItem: Diffable {
    func makeCellModelWith(boundingSize: BoundingSize) -> ListViewCellModel
}

public struct SwipeAction {
    public let text: NSAttributedString
    public let color: UIColor
    public let toDo: () -> Void

    public init(text: NSAttributedString,
                color: UIColor,
                _ toDo: @escaping () -> Void) {

        self.text = text
        self.color = color
        self.toDo = toDo
    }
}

public struct ListItem<ModelType: Equatable, ViewType: UIView>: ListViewItem {
    public let id: String
    public let model: ModelType
    public let layoutDescription: ViewLayoutDescription<ViewType>

    public init(id: String,
                model: ModelType,
                layoutDescription: ViewLayoutDescription<ViewType>) {

        self.id = id
        self.model = model
        self.layoutDescription = layoutDescription
    }

    // MARK: -

    public var boundingSizeModifier: ((BoundingSize) -> BoundingSize)?
    
    public var canSelect: Bool = true
    public var canMove: Bool = false
    
    public var onSelect: (() -> Void)?
    public var onCopy: (() -> Void)?
    
    public var swipeActions: [SwipeAction] = []

    // MARK: - Diffable

    public var diffId: String {
        return id
    }

    public func isEqual(to object: Diffable) -> Bool {
        guard let other = object as? ListItem<ModelType, ViewType> else {
            return false
        }

        return self.model == other.model
    }

    // MARK: - ListViewItem

    public func makeCellModelWith(boundingSize: BoundingSize) -> ListViewCellModel {
        let bs = boundingSizeModifier?(boundingSize) ?? boundingSize

        let viewLayout = layoutDescription.makeViewLayoutWith(boundingSize: bs)

        return ListItemCellModel(item: self, viewLayout: viewLayout)
    }
}

struct ListItemCellModel<ModelType: Equatable, ViewType: UIView>: ListViewCellModel {
    let item: ListItem<ModelType, ViewType>
    let viewLayout: ViewLayout<ViewType>

    // MARK: - ListViewCellModel

    var size: CGSize {
        return viewLayout.size
    }

    func cell(for indexPath: IndexPath, collectionView: UICollectionView, registeredCellIds: inout Set<String>) -> UICollectionViewCell {
        if item.swipeActions.isEmpty {
            let cell: CollectionViewGenericCell<ViewType> = collectionView.dequeueReusableCell(indexPath, registeredCellIds: &registeredCellIds)

            viewLayout.configure(view: cell.internalContentView)

            return cell
        } else {
            let cell: SwipeableCollectionViewGenericCell<ViewType> = collectionView.dequeueReusableCell(indexPath, registeredCellIds: &registeredCellIds)

            cell.swipeableView.actions = item.swipeActions

            viewLayout.configure(view: cell.internalContentView)

            return cell
        }
    }

    var canSelect: Bool {
        return item.canSelect
    }

    var canCopy: Bool {
        return item.onCopy != nil
    }
    var canMove: Bool {
        return item.canMove
    }

    func onSelect() {
        item.onSelect?()
    }

    func onCopy() {
        item.onCopy?()
    }
}
