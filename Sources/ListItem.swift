import Foundation
import UIKit

public final class ListItem: Diffable {
    private struct Model<T: Equatable>: AnyEquatable {
        let data: T
        
        func isEqual(to object: Any) -> Bool {
            return (object as? Model<T>)?.data == data
        }
    }
    
    // MARK: -
    
    public struct Settings {
        public var canMove: Bool = false
    }

    public struct Actions {
        public var onSelect: (() -> Void)?
        public var onCopy: (() -> Void)?
        public var onSwipe: [SwipeAction] = []
    }
    
    // MARK: -
    
    let id: String
    let model: AnyEquatable
    let layoutSpec: LayoutSpec
    
    public init<T: Equatable>(id: String,
                              model: T,
                              layoutSpec: LayoutSpec) {
        self.id = id
        self.model = Model(data: model)
        self.layoutSpec = layoutSpec
    }
    
    // MARK: -

    public var settings: Settings = Settings()
    public var actions: Actions = Actions()
    public var boundingSizeModifier: ((BoundingSize) -> BoundingSize)?
    
    // MARK: - Diffable
    
    public var diffId: String {
        return id
    }
    
    public func isEqual(to object: Any) -> Bool {
        guard let other = object as? ListItem else {
            return false
        }

        if self === other {
            return true
        }

        return model.isEqual(to: other.model)
    }
}
