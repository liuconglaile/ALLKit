import UIKit

public struct ViewFactory {
    let makeView: () -> UIView
    let configureView: (UIView, Bool) -> Void
}

public typealias ViewFactories = [Int: ViewFactory]

public struct ViewLayout<ViewType: UIView> {
    let yogaLayout: YogaLayout
    let viewFactories: ViewFactories

    public var size: CGSize {
        return yogaLayout.size
    }

    public func configure(view: ViewType) {
        view.frame = CGRect(origin: .zero, size: yogaLayout.size)

        if view.subviews.isEmpty {
            let viewFactories: [ViewFactory] = self.viewFactories.sorted(by: { (x, y) -> Bool in
                return x.key < y.key
            }).map({ $0.value })

            viewFactories.forEach { factory in
                let subview = factory.makeView()

                view.addSubview(subview)

                subview.frame = yogaLayout.frames[subview.tag] ?? .zero

                factory.configureView(subview, true)
            }
        } else {
            view.subviews.forEach { subview in
                subview.frame = yogaLayout.frames[subview.tag] ?? .zero

                viewFactories[subview.tag]?.configureView(subview, false)
            }
        }
    }

    public func makeView() -> ViewType {
        let view = ViewType(frame: .zero)

        configure(view: view)

        return view
    }
}

open class ViewLayoutDescription<ViewType: UIView> {
    public typealias Body = (inout ViewFactories) -> YogaNode

    private let body: Body

    public init(_ body: @escaping Body) {
        self.body = body
    }

    public final func makeNode(_ viewFactories: inout ViewFactories) -> YogaNode {
        return body(&viewFactories)
    }

    public final func makeViewLayoutWith(boundingSize: BoundingSize) -> ViewLayout<ViewType> {
        return autoreleasepool {
            var viewFactories = ViewFactories()

            let yogaLayout = makeNode(&viewFactories).calculateLayoutWith(boundingSize: boundingSize)

            return ViewLayout<ViewType>(yogaLayout: yogaLayout, viewFactories: viewFactories)
        }
    }
}
