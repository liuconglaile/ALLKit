import UIKit

public protocol Layout {
    var size: CGSize { get }
    
    func makeContentIn(view: UIView)
}

extension Layout {
    public func setup(in view: UIView, at origin: CGPoint = .zero) {
        view.frame = CGRect(origin: origin, size: size)
        
        makeContentIn(view: view)
    }
}

protocol LayoutCalculator {
    func makeLayoutBy(spec: LayoutSpec, boundingSize: BoundingSize) -> Layout
}

open class LayoutSpec {
    public init() {}
    
    open func makeNode() -> Node {
        fatalError()
    }
    
    public final func makeLayoutWith(boundingSize: BoundingSize) -> Layout {
        return FlatLayoutCalculator().makeLayoutBy(spec: self, boundingSize: boundingSize)
    }

    internal lazy var name = String(describing: type(of: self))
}

protocol ViewFactory {
    func makeView() -> UIView

    func config(view: UIView, firstTime: Bool)
}

final class ViewFactoryImp<ViewType: UIView>: ViewFactory {
    private let config: (ViewType, Bool) -> Void

    init(_ config: @escaping (ViewType, Bool) -> Void) {
        self.config = config
    }

    func makeView() -> UIView {
        return ViewType(frame: .zero)
    }

    func config(view: UIView, firstTime: Bool) {
        (view as? ViewType).flatMap { config($0, firstTime) }
    }
}

public final class Node {
    let children: [Node]
    let yoga: YogaNode
    let viewFactory: ViewFactory?

    public init<ViewType: UIView>(children: [Node] = [],
                                  config: ((YogaNode) -> Void)? = nil,
                                  view: ((ViewType, Bool) -> Void)? = nil) {
        self.children = children
        yoga = YogaNode(useTextSize: false)
        viewFactory = view.flatMap { ViewFactoryImp($0) }
        self.children.forEach { yoga.add(child: $0.yoga) }
        config?(yoga)
    }

    public init<ViewType: UIView>(text: NSAttributedString?,
                                  config: ((YogaNode) -> Void)? = nil,
                                  view: @escaping (ViewType, Bool) -> Void) {
        children = []
        yoga = YogaNode(useTextSize: true)
        viewFactory = ViewFactoryImp(view)
        yoga.text = text
        config?(yoga)
    }
}
