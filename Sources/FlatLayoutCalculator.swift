import Foundation

private final class LayoutData {
    var size: CGSize = .zero
    var frames: [Int: CGRect] = [:]
    var viewFactories: [Int: ViewFactory] = [:]
}

private final class FlatLayout: Layout {
    let data: LayoutData

    init(_ data: LayoutData) {
        self.data = data
    }

    // MARK: - Layout

    var size: CGSize {
        return data.size
    }

    func makeContentIn(view: UIView) {
        if view.subviews.isEmpty {
            let viewFactories = data.viewFactories.sorted(by: { (x, y) -> Bool in
                return x.key < y.key
            })

            viewFactories.forEach { (tag, factory) in
                let subview = factory.makeView()
                subview.tag = tag

                view.addSubview(subview)

                subview.frame = data.frames[tag] ?? .zero

                factory.config(view: subview, firstTime: true)
            }
        } else {
            view.subviews.forEach { subview in
                subview.frame = data.frames[subview.tag] ?? .zero

                data.viewFactories[subview.tag]?.config(view: subview, firstTime: false)
            }
        }
    }
}

final class FlatLayoutCalculator: LayoutCalculator {
    func makeLayoutBy(spec: LayoutSpec, boundingSize: BoundingSize) -> Layout {
        let data = autoreleasepool {
            calculateLayoutDataFrom(node: spec.makeNode(), boundingSize: boundingSize)
        }

        return FlatLayout(data)
    }

    // MARK: -

    private func calculateLayoutDataFrom(node: Node, boundingSize: BoundingSize) -> LayoutData {
        node.yoga.calculateLayoutWith(boundingSize: boundingSize)

        let frame = node.yoga.frame

        var data = LayoutData()
        data.size = frame.size

        var number = 0

        collect(data, node, &number, frame.origin)

        return data
    }

    private func collect(_ data: LayoutData,
                         _ node: Node,
                         _ number: inout Int,
                         _ offset: CGPoint) {

        let frame = node.yoga.frame.offsetBy(dx: offset.x, dy: offset.y)

        if let viewFactory = node.viewFactory {
            let viewTag = number + 1

            data.frames[viewTag] = frame
            data.viewFactories[viewTag] = viewFactory

            number = viewTag
        }

        node.children.forEach {
            collect(data, $0, &number, frame.origin)
        }
    }
}
