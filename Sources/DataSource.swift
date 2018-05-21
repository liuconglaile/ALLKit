import Foundation
import UIKit

public final class ListViewDataSource {
    public init() {}

    // MARK: -

    private var boundingSize: BoundingSize?
    private var items: [ListViewItem] = []

    public func set(newBoundingSize: BoundingSize, completion: (() -> Void)?) {
        assert(Thread.isMainThread)

        guard newBoundingSize != boundingSize else {
            return
        }

        boundingSize = newBoundingSize

        let items = self.items

        internalQueue.async {
            self.modelsCache.removeAll()

            let models = items.map { item -> ListViewCellModel in
                let model = item.makeCellModelWith(boundingSize: newBoundingSize)

                self.modelsCache[item.diffId] = model

                return model
            }

            DispatchQueue.main.sync {
                self.models = models

                completion?()
            }
        }
    }

    public func set(newItems: [ListViewItem], completion: ((DiffResult) -> Void)?) {
        assert(Thread.isMainThread)

        let oldItems = self.items
        self.items = newItems

        guard let boundingSize = boundingSize else {
            return
        }

        internalQueue.async {
            let diff = Diff.result(oldItems, newItems)

            guard diff.changesCount > 0 else {
                return
            }

            let invalidations = diff.deletes + diff.updates.map { $0.old }

            invalidations.forEach { index in
                let item = oldItems[index]

                self.modelsCache[item.diffId] = nil
            }

            let models = newItems.map { item -> ListViewCellModel in
                let model = self.modelsCache[item.diffId] ?? item.makeCellModelWith(boundingSize: boundingSize)

                self.modelsCache[item.diffId] = model

                return model
            }

            DispatchQueue.main.sync {
                self.models = models

                completion?(diff)
            }
        }
    }

    public func moveItem(from sourceIndex: Int, to destinationIndex: Int) {
        assert(Thread.isMainThread)

        // 1

        do {
            var models = self.models
            models.insert(models.remove(at: sourceIndex), at: destinationIndex)
            self.models = models
        }

        // 2

        do {
            var items = self.items
            items.insert(items.remove(at: sourceIndex), at: destinationIndex)
            set(newItems: items, completion: nil)
        }
    }

    // MARK: -

    private let internalQueue = DispatchQueue(label: "")

    private var modelsCache: [String: ListViewCellModel] = [:] // access only from internal queue
    private var models: [ListViewCellModel] = [] // access only from main queue

    // MARK: -

    public var modelsCount: Int {
        assert(Thread.isMainThread)

        return models.count
    }

    public func model(at index: Int) -> ListViewCellModel {
        assert(Thread.isMainThread)

        return models[index]
    }
}
