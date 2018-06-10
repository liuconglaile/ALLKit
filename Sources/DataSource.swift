import Foundation
import UIKit

public struct CellModel {
    public let settings: ListItem.Settings
    public let actions: ListItem.Actions
    public let layout: Layout
    public let layoutSpecName: String
}

extension ListItem {
    func makeCellModel(_ boundingSize: BoundingSize) -> CellModel {
        let bs = boundingSizeModifier?(boundingSize) ?? boundingSize
        
        let layout = layoutSpec.makeLayoutWith(boundingSize: bs)

        return CellModel(
            settings: settings,
            actions: actions,
            layout: layout,
            layoutSpecName: layoutSpec.name
        )
    }
}

public final class ListViewDataSource {
    public init() {}

    // MARK: -

    private let internalQueue = DispatchQueue(label: "")

    private var modelsCache: [String: CellModel] = [:] // access only from internal queue
    private var models: [CellModel] = [] // access only from main queue

    private var boundingSize: BoundingSize?
    private var items: [ListItem] = []

    // MARK: -

    public func set(newBoundingSize: BoundingSize, completion: (() -> Void)?) {
        assert(Thread.isMainThread)

        guard newBoundingSize != boundingSize else {
            return
        }

        boundingSize = newBoundingSize

        let items = self.items

        internalQueue.async {
            self.modelsCache.removeAll()

            let models = items.map { item -> CellModel in
                let model = item.makeCellModel(newBoundingSize)

                self.modelsCache[item.diffId] = model

                return model
            }

            DispatchQueue.main.sync {
                self.models = models

                completion?()
            }
        }
    }

    public func set(newItems: [ListItem], completion: ((DiffResult) -> Void)?) {
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

            let models = newItems.map { item -> CellModel in
                let model = self.modelsCache[item.diffId] ?? item.makeCellModel(boundingSize)

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

        do {
            var models = self.models
            models.insert(models.remove(at: sourceIndex), at: destinationIndex)
            self.models = models
        }

        do {
            var items = self.items
            items.insert(items.remove(at: sourceIndex), at: destinationIndex)
            set(newItems: items, completion: nil)
        }
    }

    // MARK: -

    public var modelsCount: Int {
        assert(Thread.isMainThread)

        return models.count
    }

    public func model(at index: Int) -> CellModel {
        assert(Thread.isMainThread)

        return models[index]
    }
}
