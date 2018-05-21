import Foundation
import UIKit

extension UIGestureRecognizer {
    fileprivate static let handlers = NSMapTable<UIGestureRecognizer, NSObject>.weakToStrongObjects()
}

extension UIView {
    private final class Handler<GestureType: UIGestureRecognizer>: NSObject {
        private let action: (GestureType) -> Void

        init(action: @escaping (GestureType) -> Void) {
            self.action = action

            super.init()
        }

        @objc
        func invoke(gesture: UIGestureRecognizer) {
            (gesture as? GestureType).flatMap {
                action($0)
            }
        }
    }

    @discardableResult
    public func handle<GestureType: UIGestureRecognizer>(_ action: @escaping (GestureType) -> Void) -> GestureType {
        let handler = Handler(action: action)

        let gesture = GestureType(target: handler, action: #selector(Handler.invoke(gesture:)))

        UIGestureRecognizer.handlers.setObject(handler, forKey: gesture)

        addGestureRecognizer(gesture)

        return gesture
    }
}

extension UIControl {
    private static let handlers = NSMapTable<UIControl, NSMutableDictionary>.weakToStrongObjects()

    private final class Handler: NSObject {
        let action: (() -> Void)?

        init(action: (() -> Void)?) {
            self.action = action
        }

        @objc
        func invoke() {
            action?()
        }
    }

    public final func handle(_ controlEvents: UIControlEvents, _ action: (() -> Void)?) {
        let handlers = UIControl.handlers.object(forKey: self) ?? NSMutableDictionary()

        do {
            handlers[controlEvents.rawValue].flatMap {
                removeTarget($0, action: #selector(Handler.invoke), for: controlEvents)

                handlers[controlEvents.rawValue] = nil
            }
        }

        do {
            let newHandler = Handler(action: action)

            addTarget(newHandler, action: #selector(Handler.invoke), for: controlEvents)

            handlers[controlEvents.rawValue] = newHandler
        }

        UIControl.handlers.setObject(handlers, forKey: self)
    }
}
