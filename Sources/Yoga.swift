import Foundation
import CoreGraphics
import yoga

// https://yogalayout.com/docs

postfix operator %

extension Int {
    public static postfix func % (value: Int) -> YGValue {
        return YGValue(value: Float(value), unit: .percent)
    }
}

extension Float {
    public static postfix func % (value: Float) -> YGValue {
        return YGValue(value: value, unit: .percent)
    }
}

extension CGFloat {
    public static postfix func % (value: CGFloat) -> YGValue {
        return YGValue(value: Float(value), unit: .percent)
    }
}

extension YGValue: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    public init(integerLiteral value: Int) {
        self = YGValue(value: Float(value), unit: .point)
    }

    public init(floatLiteral value: Float) {
        self = YGValue(value: value, unit: .point)
    }

    public init(_ value: Float) {
        self = YGValue(value: value, unit: .point)
    }

    public init(_ value: CGFloat) {
        self = YGValue(value: Float(value), unit: .point)
    }
}

public typealias YogaLayout = (size: CGSize, frames: [Int: CGRect])

public class YogaNode {
    private struct Config {
        static let shared: YGConfigRef! = {
            var cfg = YGConfigNew()
            YGConfigSetPointScaleFactor(cfg, Float(UIScreen.main.scale))
            return cfg
        }()
    }

    fileprivate var nodeRef: YGNodeRef!

    public required init() {
        nodeRef = YGNodeNewWithConfig(Config.shared)
    }

    public convenience init(_ configure: (YogaNode) -> Void) {
        self.init()

        configure(self)
    }

    deinit {
        YGNodeFree(nodeRef)
    }

    // MARK: -

    private var children: [YogaNode] = []

    @discardableResult
    public func add(_ child: YogaNode) -> Self {
        children.append(child)

        YGNodeInsertChild(nodeRef, child.nodeRef, YGNodeGetChildCount(nodeRef))

        return self
    }

    // MARK: -

    public final func calculateLayoutWith(boundingSize: BoundingSize) -> YogaLayout {
        YGNodeCalculateLayout(nodeRef, Float(boundingSize.width), Float(boundingSize.height), .LTR)

        let frame = self.frame

        var frames: [Int: CGRect] = [:]

        collect(frames: &frames, offset: frame.origin)

        return (frame.size, frames)
    }

    private func collect(frames: inout [Int: CGRect], offset: CGPoint) {
        let frame = self.frame.offsetBy(dx: offset.x, dy: offset.y)

        if let tag = tag {
            frames[tag] = frame
        }

        children.forEach { child in
            child.collect(frames: &frames, offset: frame.origin)
        }
    }

    // MARK: -

    public final var frame: CGRect {
        return CGRect(
            x: CGFloat(YGNodeLayoutGetLeft(nodeRef)),
            y: CGFloat(YGNodeLayoutGetTop(nodeRef)),
            width: CGFloat(YGNodeLayoutGetWidth(nodeRef)),
            height: CGFloat(YGNodeLayoutGetHeight(nodeRef))
        )
    }

    public final var flexDirection: YGFlexDirection {
        get { return YGNodeStyleGetFlexDirection(nodeRef) }
        set { YGNodeStyleSetFlexDirection(nodeRef, newValue) }
    }

    public final var flex: Float {
        get { return YGNodeStyleGetFlex(nodeRef) }
        set { YGNodeStyleSetFlex(nodeRef, newValue) }
    }

    public final var flexWrap: YGWrap {
        get { return YGNodeStyleGetFlexWrap(nodeRef) }
        set { YGNodeStyleSetFlexWrap(nodeRef, newValue) }
    }

    public final var flexGrow: Float {
        get { return YGNodeStyleGetFlexGrow(nodeRef) }
        set { YGNodeStyleSetFlexGrow(nodeRef, newValue) }
    }

    public final var flexShrink: Float {
        get { return YGNodeStyleGetFlexShrink(nodeRef) }
        set { YGNodeStyleSetFlexShrink(nodeRef, newValue) }
    }

    public final var flexBasis: YGValue {
        get { return YGNodeStyleGetFlexBasis(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetFlexBasis, YGNodeStyleSetFlexBasisPercent) }
    }

    public final var display: YGDisplay {
        get { return YGNodeStyleGetDisplay(nodeRef) }
        set { YGNodeStyleSetDisplay(nodeRef, newValue) }
    }

    public final var aspectRatio: Float {
        get { return YGNodeStyleGetAspectRatio(nodeRef) }
        set { YGNodeStyleSetAspectRatio(nodeRef, newValue) }
    }

    public final var justifyContent: YGJustify {
        get { return YGNodeStyleGetJustifyContent(nodeRef) }
        set { YGNodeStyleSetJustifyContent(nodeRef, newValue) }
    }

    public final var alignContent: YGAlign {
        get { return YGNodeStyleGetAlignContent(nodeRef) }
        set { YGNodeStyleSetAlignContent(nodeRef, newValue) }
    }

    public final var alignItems: YGAlign {
        get { return YGNodeStyleGetAlignItems(nodeRef) }
        set { YGNodeStyleSetAlignItems(nodeRef, newValue) }
    }

    public final var alignSelf: YGAlign {
        get { return YGNodeStyleGetAlignSelf(nodeRef) }
        set { YGNodeStyleSetAlignSelf(nodeRef, newValue) }
    }

    public final var positionType: YGPositionType {
        get { return YGNodeStyleGetPositionType(nodeRef) }
        set { YGNodeStyleSetPositionType(nodeRef, newValue) }
    }

    public final var width: YGValue {
        get { return YGNodeStyleGetWidth(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetWidth, YGNodeStyleSetWidthPercent) }
    }

    public final var height: YGValue {
        get { return YGNodeStyleGetHeight(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetHeight, YGNodeStyleSetHeightPercent) }
    }

    public final var minWidth: YGValue {
        get { return YGNodeStyleGetMinWidth(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetMinWidth, YGNodeStyleSetMinWidthPercent) }
    }

    public final var minHeight: YGValue {
        get { return YGNodeStyleGetMinHeight(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetMinHeight, YGNodeStyleSetMinHeightPercent) }
    }

    public final var maxWidth: YGValue {
        get { return YGNodeStyleGetMaxWidth(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetMaxWidth, YGNodeStyleSetMaxWidthPercent) }
    }

    public final var maxHeight: YGValue {
        get { return YGNodeStyleGetMaxHeight(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetMaxHeight, YGNodeStyleSetMaxHeightPercent) }
    }

    public final var top: YGValue {
        get { return YGNodeStyleGetPosition(nodeRef, .top) }
        set { set(nodeRef, newValue, .top, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
    }

    public final var right: YGValue {
        get { return YGNodeStyleGetPosition(nodeRef, .right) }
        set { set(nodeRef, newValue, .right, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
    }

    public final var bottom: YGValue {
        get { return YGNodeStyleGetPosition(nodeRef, .bottom) }
        set { set(nodeRef, newValue, .bottom, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
    }

    public final var left: YGValue {
        get { return YGNodeStyleGetPosition(nodeRef, .left) }
        set { set(nodeRef, newValue, .left, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
    }

    public final var marginTop: YGValue {
        get { return YGNodeStyleGetMargin(nodeRef, .top) }
        set { set(nodeRef, newValue, .top, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
    }

    public final var marginRight: YGValue {
        get { return YGNodeStyleGetMargin(nodeRef, .right) }
        set { set(nodeRef, newValue, .right, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
    }

    public final var marginBottom: YGValue {
        get { return YGNodeStyleGetMargin(nodeRef, .bottom) }
        set { set(nodeRef, newValue, .bottom, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
    }

    public final var marginLeft: YGValue {
        get { return YGNodeStyleGetMargin(nodeRef, .left) }
        set { set(nodeRef, newValue, .left, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
    }

    public final var paddingTop: YGValue {
        get { return YGNodeStyleGetPadding(nodeRef, .top) }
        set { set(nodeRef, newValue, .top, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
    }

    public final var paddingRight: YGValue {
        get { return YGNodeStyleGetPadding(nodeRef, .right) }
        set { set(nodeRef, newValue, .right, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
    }

    public final var paddingBottom: YGValue {
        get { return YGNodeStyleGetPadding(nodeRef, .bottom) }
        set { set(nodeRef, newValue, .bottom, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
    }

    public final var paddingLeft: YGValue {
        get { return YGNodeStyleGetPadding(nodeRef, .left) }
        set { set(nodeRef, newValue, .left, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
    }

    public final var border: Float {
        get {
            return YGNodeStyleGetBorder(nodeRef, .top)
        }
        set {
            YGNodeStyleSetBorder(nodeRef, .top, newValue)
            YGNodeStyleSetBorder(nodeRef, .right, newValue)
            YGNodeStyleSetBorder(nodeRef, .bottom, newValue)
            YGNodeStyleSetBorder(nodeRef, .left, newValue)
        }
    }

    // MARK: -

    private func set(_ nodeRef: YGNodeRef, _ value: YGValue, _ pointSetter: (YGNodeRef?, Float) -> Void, _ percentSetter: (YGNodeRef?, Float) -> Void) {
        switch value.unit {
        case .point:
            pointSetter(nodeRef, value.value)
        case .percent:
            percentSetter(nodeRef, value.value)
        case .auto, .undefined:
            break
        }
    }

    private func set(_ nodeRef: YGNodeRef, _ value: YGValue, _ edge: YGEdge, _ pointSetter: (YGNodeRef?, YGEdge, Float) -> Void, _ percentSetter: (YGNodeRef?, YGEdge, Float) -> Void) {
        switch value.unit {
        case .point:
            pointSetter(nodeRef, edge, value.value)
        case .percent:
            percentSetter(nodeRef, edge, value.value)
        case .auto, .undefined:
            break
        }
    }

    // MARK: -

    public private(set) final var tag: Int?

    @discardableResult
    public final func viewFactory<ViewType: UIView>(_ factories: inout [Int: ViewFactory],
                                                    _ configure: @escaping (ViewType, Bool) -> Void) -> Self {
        assert(self.tag == nil)

        let tag = (factories.keys.max() ?? 0) + 1

        let factory = ViewFactory(makeView: {
            let view = ViewType(frame: .zero)
            view.tag = tag

            return view
        }, configureView: { view, firstTime in
            if let view = view as? ViewType {
                configure(view, firstTime)
            }
        })

        self.tag = tag

        factories[tag] = factory

        return self
    }
}

public final class YogaTextNode: YogaNode {
    public convenience init(_ configure: (YogaTextNode) -> Void) {
        self.init()

        configure(self)
    }

    public required init() {
        super.init()

        YGNodeSetNodeType(nodeRef, .text)

        YGNodeSetContext(nodeRef, Unmanaged.passUnretained(self).toOpaque())

        YGNodeSetMeasureFunc(nodeRef, { (node, width, widthMode, height, heightMode) -> YGSize in
            let textNode = Unmanaged<YogaTextNode>.fromOpaque(YGNodeGetContext(node)).takeUnretainedValue()

            guard let text = textNode.text else {
                return YGSize(width: 0, height: 0)
            }

            let textSize = text.boundingRect(
                with: CGSize(
                    width: widthMode == .undefined ? CGFloat.greatestFiniteMagnitude : CGFloat(width),
                    height: heightMode == .undefined ? CGFloat.greatestFiniteMagnitude : CGFloat(height)
                ),
                options: .usesLineFragmentOrigin,
                context: nil).size

            return YGSize(
                width: Float(textSize.width),
                height: Float(textSize.height)
            )
        })
    }

    public var text: NSAttributedString? = nil {
        didSet {
            display = text != nil ? .flex : .none
        }
    }

    @available(*, unavailable)
    public override func add(_ child: YogaNode) -> Self {
        fatalError()
    }

    @discardableResult
    public func labelFactory(_ factories: inout [Int: ViewFactory], text: NSAttributedString?) -> Self {
        self.text = text

        return viewFactory(&factories) { (label: AsyncLabel, firstTime) in
            if firstTime {
                label.isUserInteractionEnabled = false
            }

            label.text = text
            label.isHidden = text == nil
        }
    }
}
