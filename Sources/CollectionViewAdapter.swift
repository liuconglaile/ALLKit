import Foundation
import UIKit

public final class CollectionViewAdapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public struct ScrollEvents {
        public var didScroll: ((UIScrollView) -> Void)?
        public var willBeginDragging: ((UIScrollView) -> Void)?
        public var willEndDragging: ((UIScrollView, CGPoint, CGPoint) -> Void)? // velocity, targetContentOffset
        public var didEndDragging: ((UIScrollView, Bool) -> Void)? // decelerate
        public var willBeginDecelerating: ((UIScrollView) -> Void)?
        public var didEndDecelerating: ((UIScrollView) -> Void)?
        public var didEndScrollingAnimation: ((UIScrollView) -> Void)?
    }

    public struct CollectionEvents {
        public var willDisplayCell: ((UICollectionViewCell, Int) -> Void)?
        public var didEndDisplayingCell: ((UICollectionViewCell, Int) -> Void)?
        public var didHighlightCell: ((UICollectionViewCell, Int) -> Void)?
        public var didUnhighlightCell: ((UICollectionViewCell, Int) -> Void)?
        public var moveItem: ((Int, Int) -> Void)?
    }

    public struct Behavior {
        public var deselectOnSelect: Bool
        public var allowInteractiveMovement: Bool
        public var allowMovesInBatchUpdates: Bool
    }

    // MARK: -

    public convenience init(scrollDirection: UICollectionViewScrollDirection = .vertical,
                            sectionInset: UIEdgeInsets = .zero,
                            minimumLineSpacing: CGFloat = 0,
                            minimumInteritemSpacing: CGFloat = 0) {

        let flowLayout = UICollectionViewFlowLayout()

        do {
            flowLayout.scrollDirection = scrollDirection
            flowLayout.sectionInset = sectionInset
            flowLayout.minimumLineSpacing = minimumLineSpacing
            flowLayout.minimumInteritemSpacing = minimumInteritemSpacing
            flowLayout.headerReferenceSize = .zero
            flowLayout.footerReferenceSize = .zero
        }

        self.init(layout: flowLayout)
    }

    public init(layout: UICollectionViewLayout) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        behavior = Behavior(
            deselectOnSelect: false,
            allowInteractiveMovement: false,
            allowMovesInBatchUpdates: false
        )

        super.init()

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    deinit {
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }

    // MARK: -

    private let dataSource = ListViewDataSource()

    public func set(boundingSize: BoundingSize, completion: (() -> Void)? = nil) {
        dataSource.set(newBoundingSize: boundingSize) { [weak self] in
            self?.reloadData {
                completion?()
            }
        }
    }

    public func set(items: [ListViewItem], completion: (() -> Void)? = nil) {
        let allowMovesInBatchUpdates = behavior.allowMovesInBatchUpdates

        dataSource.set(newItems: items) { [weak self] diff in
            if diff.oldCount == 0 || diff.newCount == 0 {
                self?.reloadData {
                    completion?()
                }

                return
            }

            let deletes: Set<DiffResult.Index>
            let inserts: Set<DiffResult.Index>
            let moves: [DiffResult.Move]

            if #available(iOS 11.0, *), allowMovesInBatchUpdates {
                deletes = Set(diff.deletes + diff.updates.map { $0.old })
                inserts = Set(diff.inserts + diff.updates.map { $0.new })
                moves = diff.moves.filter {
                    !deletes.contains($0.from) && !inserts.contains($0.to)
                }
            } else {
                deletes = Set(diff.deletes + diff.updates.map { $0.old } + diff.moves.map { $0.from })
                inserts = Set(diff.inserts + diff.updates.map { $0.new } + diff.moves.map { $0.to })
                moves = []
            }

            self?.performBatchUpdates(deletes: deletes, inserts: inserts, moves: moves) {
                completion?()
            }
        }
    }

    // MARK: -

    private func reloadData(completion: (() -> Void)?) {
        collectionView.performBatchUpdates({
            collectionView.deleteSections(sectionIndex)
            collectionView.insertSections(sectionIndex)
        }) { _ in completion?() }
    }

    private func performBatchUpdates(deletes: Set<DiffResult.Index>,
                                     inserts: Set<DiffResult.Index>,
                                     moves: [DiffResult.Move],
                                     completion: (() -> Void)?) {
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: deletes.map { indexPath(from: $0) })
            collectionView.insertItems(at: inserts.map { indexPath(from: $0) })

            moves.forEach {
                collectionView.moveItem(
                    at: indexPath(from: $0.from),
                    to: indexPath(from: $0.to)
                )
            }
        }) { _ in completion?() }
    }

    // MARK: -

    public let collectionView: UICollectionView

    public var scrollEvents = ScrollEvents() {
        willSet {
            assert(Thread.isMainThread)
        }
    }

    public var collectionEvents = CollectionEvents() {
        willSet {
            assert(Thread.isMainThread)
        }
    }

    public var behavior: Behavior {
        willSet {
            assert(Thread.isMainThread)
        }
    }

    public var configureCell: ((UICollectionViewCell, Int) -> Void)? = nil {
        willSet {
            assert(Thread.isMainThread)
        }
    }

    // MARK: -

    @available(iOS 9.0, *)
    public func setupMoveGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleMove(gesture:)))

        collectionView.addGestureRecognizer(gesture)
    }

    @available(iOS 9.0, *)
    @objc
    private func handleMove(gesture: UILongPressGestureRecognizer) {
        guard behavior.allowInteractiveMovement else { return }

        switch(gesture.state) {
        case .began:
            _ = collectionView.indexPathForItem(at: gesture.location(in: collectionView)).flatMap {
                collectionView.beginInteractiveMovementForItem(at: $0)
            }
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }

    // MARK: -

    private var registeredCellIds: Set<String> = []

    private lazy var sectionIndex = IndexSet(integer: 0)

    private func indexPath(from index: Int) -> IndexPath {
        return IndexPath(item: index, section: 0)
    }

    private func index(from indexPath: IndexPath) -> Int {
        return indexPath.item
    }

    private func model(at indexPath: IndexPath) -> ListViewCellModel {
        return dataSource.model(at: index(from: indexPath))
    }

    // MARK: - UICollectionViewDataSource

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.modelsCount
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = model(at: indexPath).cell(for: indexPath, collectionView: collectionView, registeredCellIds: &registeredCellIds)

        configureCell?(cell, index(from: indexPath))

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return behavior.allowInteractiveMovement && model(at: indexPath).canMove
    }

    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sourceIndex = index(from: sourceIndexPath)
        let destinationIndex = index(from: destinationIndexPath)

        dataSource.moveItem(from: sourceIndex, to: destinationIndex)

        collectionEvents.moveItem?(sourceIndex, destinationIndex)
    }

    // MARK: - UICollectionViewDelegate

    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return model(at: indexPath).canSelect
    }

    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }

        collectionEvents.didHighlightCell?(cell, index(from: indexPath))
    }

    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }

        collectionEvents.didUnhighlightCell?(cell, index(from: indexPath))
    }

    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return model(at: indexPath).canSelect
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        model(at: indexPath).onSelect()

        if behavior.deselectOnSelect {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionEvents.willDisplayCell?(cell, index(from: indexPath))
    }

    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionEvents.didEndDisplayingCell?(cell, index(from: indexPath))
    }

    public func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return model(at: indexPath).canCopy
    }

    public func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return action.description.contains("copy")
    }

    public func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        model(at: indexPath).onCopy()
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return model(at: indexPath).size
    }

    // MARK: - UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollEvents.didScroll?(scrollView)
    }

    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollEvents.willBeginDragging?(scrollView)
    }

    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollEvents.willEndDragging?(scrollView, velocity, targetContentOffset.pointee)
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollEvents.didEndDragging?(scrollView, decelerate)
    }

    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollEvents.willBeginDecelerating?(scrollView)
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollEvents.didEndDecelerating?(scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollEvents.didEndScrollingAnimation?(scrollView)
    }
}
