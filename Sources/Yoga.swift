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

extension YGValue: Equatable {
    public static func ==(lhs: YGValue, rhs: YGValue) -> Bool {
        return lhs.value == rhs.value && lhs.unit == rhs.unit
    }
}

public final class YogaNode {
    private struct Config {
        static let shared: YGConfigRef! = {
            var cfg = YGConfigNew()
            YGConfigSetPointScaleFactor(cfg, Float(UIScreen.main.scale))
            return cfg
        }()
    }

    private var nodeRef: YGNodeRef!

    public init(useTextSize: Bool) {
        self.useTextSize = useTextSize

        nodeRef = YGNodeNewWithConfig(Config.shared)

        guard useTextSize else { return }

        YGNodeSetNodeType(nodeRef, .text)

        YGNodeSetContext(nodeRef, Unmanaged.passUnretained(self).toOpaque())

        YGNodeSetMeasureFunc(nodeRef) { (node, width, widthMode, height, heightMode) -> YGSize in
            let textNode = Unmanaged<YogaNode>.fromOpaque(YGNodeGetContext(node)).takeUnretainedValue()

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
        }
    }

    deinit {
        YGNodeFree(nodeRef)
    }

    // MARK: -

    public let useTextSize: Bool

    public var text: NSAttributedString?

    // MARK: -

    public private(set) var children: [YogaNode] = []

    @discardableResult
    public func add(child: YogaNode) -> Self {
        assert(!useTextSize, "Text node can not have any child nodes!")

        children.append(child)

        YGNodeInsertChild(nodeRef, child.nodeRef, YGNodeGetChildCount(nodeRef))

        return self
    }

    // MARK: -

    public func calculateLayoutWith(boundingSize: BoundingSize, direction: YGDirection = .LTR) {
        YGNodeCalculateLayout(nodeRef, Float(boundingSize.width), Float(boundingSize.height), direction)
    }

    // MARK: -

    public var frame: CGRect {
        return CGRect(
            x: CGFloat(YGNodeLayoutGetLeft(nodeRef)),
            y: CGFloat(YGNodeLayoutGetTop(nodeRef)),
            width: CGFloat(YGNodeLayoutGetWidth(nodeRef)),
            height: CGFloat(YGNodeLayoutGetHeight(nodeRef))
        )
    }

    public var flexDirection: YGFlexDirection {
        get { return YGNodeStyleGetFlexDirection(nodeRef) }
        set { YGNodeStyleSetFlexDirection(nodeRef, newValue) }
    }

    public var flex: Float {
        get { return YGNodeStyleGetFlex(nodeRef) }
        set { YGNodeStyleSetFlex(nodeRef, newValue) }
    }

    public var flexWrap: YGWrap {
        get { return YGNodeStyleGetFlexWrap(nodeRef) }
        set { YGNodeStyleSetFlexWrap(nodeRef, newValue) }
    }

    public var flexGrow: Float {
        get { return YGNodeStyleGetFlexGrow(nodeRef) }
        set { YGNodeStyleSetFlexGrow(nodeRef, newValue) }
    }

    public var flexShrink: Float {
        get { return YGNodeStyleGetFlexShrink(nodeRef) }
        set { YGNodeStyleSetFlexShrink(nodeRef, newValue) }
    }

    public var flexBasis: YGValue {
        get { return YGNodeStyleGetFlexBasis(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetFlexBasis, YGNodeStyleSetFlexBasisPercent) }
    }

    public var display: YGDisplay {
        get { return YGNodeStyleGetDisplay(nodeRef) }
        set { YGNodeStyleSetDisplay(nodeRef, newValue) }
    }

    public var aspectRatio: Float {
        get { return YGNodeStyleGetAspectRatio(nodeRef) }
        set { YGNodeStyleSetAspectRatio(nodeRef, newValue) }
    }

    public var justifyContent: YGJustify {
        get { return YGNodeStyleGetJustifyContent(nodeRef) }
        set { YGNodeStyleSetJustifyContent(nodeRef, newValue) }
    }

    public var alignContent: YGAlign {
        get { return YGNodeStyleGetAlignContent(nodeRef) }
        set { YGNodeStyleSetAlignContent(nodeRef, newValue) }
    }

    public var alignItems: YGAlign {
        get { return YGNodeStyleGetAlignItems(nodeRef) }
        set { YGNodeStyleSetAlignItems(nodeRef, newValue) }
    }

    public var alignSelf: YGAlign {
        get { return YGNodeStyleGetAlignSelf(nodeRef) }
        set { YGNodeStyleSetAlignSelf(nodeRef, newValue) }
    }

    public var positionType: YGPositionType {
        get { return YGNodeStyleGetPositionType(nodeRef) }
        set { YGNodeStyleSetPositionType(nodeRef, newValue) }
    }

    public var width: YGValue {
        get { return YGNodeStyleGetWidth(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetWidth, YGNodeStyleSetWidthPercent) }
    }

    public var height: YGValue {
        get { return YGNodeStyleGetHeight(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetHeight, YGNodeStyleSetHeightPercent) }
    }

    public var minWidth: YGValue {
        get { return YGNodeStyleGetMinWidth(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetMinWidth, YGNodeStyleSetMinWidthPercent) }
    }

    public var minHeight: YGValue {
        get { return YGNodeStyleGetMinHeight(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetMinHeight, YGNodeStyleSetMinHeightPercent) }
    }

    public var maxWidth: YGValue {
        get { return YGNodeStyleGetMaxWidth(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetMaxWidth, YGNodeStyleSetMaxWidthPercent) }
    }

    public var maxHeight: YGValue {
        get { return YGNodeStyleGetMaxHeight(nodeRef) }
        set { set(nodeRef, newValue, YGNodeStyleSetMaxHeight, YGNodeStyleSetMaxHeightPercent) }
    }

    public var top: YGValue {
        get { return YGNodeStyleGetPosition(nodeRef, .top) }
        set { set(nodeRef, newValue, .top, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
    }

    public var right: YGValue {
        get { return YGNodeStyleGetPosition(nodeRef, .right) }
        set { set(nodeRef, newValue, .right, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
    }

    public var bottom: YGValue {
        get { return YGNodeStyleGetPosition(nodeRef, .bottom) }
        set { set(nodeRef, newValue, .bottom, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
    }

    public var left: YGValue {
        get { return YGNodeStyleGetPosition(nodeRef, .left) }
        set { set(nodeRef, newValue, .left, YGNodeStyleSetPosition, YGNodeStyleSetPositionPercent) }
    }

    public var marginTop: YGValue {
        get { return YGNodeStyleGetMargin(nodeRef, .top) }
        set { set(nodeRef, newValue, .top, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
    }

    public var marginRight: YGValue {
        get { return YGNodeStyleGetMargin(nodeRef, .right) }
        set { set(nodeRef, newValue, .right, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
    }

    public var marginBottom: YGValue {
        get { return YGNodeStyleGetMargin(nodeRef, .bottom) }
        set { set(nodeRef, newValue, .bottom, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
    }

    public var marginLeft: YGValue {
        get { return YGNodeStyleGetMargin(nodeRef, .left) }
        set { set(nodeRef, newValue, .left, YGNodeStyleSetMargin, YGNodeStyleSetMarginPercent) }
    }

    public var paddingTop: YGValue {
        get { return YGNodeStyleGetPadding(nodeRef, .top) }
        set { set(nodeRef, newValue, .top, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
    }

    public var paddingRight: YGValue {
        get { return YGNodeStyleGetPadding(nodeRef, .right) }
        set { set(nodeRef, newValue, .right, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
    }

    public var paddingBottom: YGValue {
        get { return YGNodeStyleGetPadding(nodeRef, .bottom) }
        set { set(nodeRef, newValue, .bottom, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
    }

    public var paddingLeft: YGValue {
        get { return YGNodeStyleGetPadding(nodeRef, .left) }
        set { set(nodeRef, newValue, .left, YGNodeStyleSetPadding, YGNodeStyleSetPaddingPercent) }
    }

    public var border: Float {
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
}

extension YogaNode {
    public func padding(top: YGValue?, left: YGValue?, bottom: YGValue?, right: YGValue?) {
        top.flatMap { paddingTop = $0 }
        left.flatMap { paddingLeft = $0 }
        bottom.flatMap { paddingBottom = $0 }
        right.flatMap { paddingRight = $0 }
    }

    public func padding(all: YGValue) {
        paddingTop = all
        paddingLeft = all
        paddingBottom = all
        paddingRight = all
    }

    public func margin(top: YGValue?, left: YGValue?, bottom: YGValue?, right: YGValue?) {
        top.flatMap { marginTop = $0 }
        left.flatMap { marginLeft = $0 }
        bottom.flatMap { marginBottom = $0 }
        right.flatMap { marginRight = $0 }
    }

    public func margin(all: YGValue) {
        marginTop = all
        marginLeft = all
        marginBottom = all
        marginRight = all
    }
}
