import Foundation
import UIKit

public struct SwipeAction {
    public let text: NSAttributedString
    public let color: UIColor
    public let perform: () -> Void

    public init(text: NSAttributedString,
                color: UIColor,
                _ perform: @escaping () -> Void) {

        self.text = text
        self.color = color
        self.perform = perform
    }
}

public final class SwipeView: UIView, UIGestureRecognizerDelegate {
    private struct Consts {
        static let defaultButtonWidth: CGFloat = 96
        static let defaultAnimationDuration: TimeInterval = 0.2
    }

    // MARK: -

    public override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = true

        addSubview(buttonsContainerView)
        addSubview(contentView)

        panGesture.delegate = self

        position = 0

        SwipeView.instances.add(self)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: -

    public let contentView = UIView(frame: .zero)

    public var actions: [SwipeAction] = [] {
        didSet {
            isButtonStackDirty = true
        }
    }

    public func close(animated: Bool) {
        set(position: 0, animated: animated)
    }
    
    public func open(animated: Bool) {
        set(position: 1, animated: animated)
    }

    // MARK: -

    private static let instances = NSHashTable<SwipeView>(options: NSPointerFunctions.Options.weakMemory)

    public func closeAllButMe(animated: Bool) {
        SwipeView.instances.allObjects.forEach { swipeView in
            if swipeView !== self {
                swipeView.close(animated: animated)
            }
        }
    }

    public static func closeAll(animated: Bool) {
        instances.allObjects.forEach { $0.close(animated: animated) }
    }

    // MARK: -

    private var isButtonStackDirty = true

    private func rebuildButtonStackIfNeeded() {
        guard isButtonStackDirty else {
            return
        }

        rebuildButtonStack()

        isButtonStackDirty = false
    }

    private let buttonsContainerView = UIView()

    private func rebuildButtonStack() {
        buttonsContainerView.subviews.forEach { $0.removeFromSuperview() }

        actions.reversed().forEach { action in
            let button = UIButton(type: .system)
            button.backgroundColor = action.color
            button.setAttributedTitle(action.text, for: .normal)
            button.handle(.touchUpInside, { [weak self] in
                action.perform()

                self?.close(animated: true)
            })

            buttonsContainerView.addSubview(button)
        }
    }

    // MARK: -

    private lazy var panGesture: UIPanGestureRecognizer = contentView.handle { [weak self] _ in
        self?.panGestureDidChangeState()
    }

    private var location: CGFloat = 0
    private var translation: CGFloat = 0 {
        didSet {
            let w = CGFloat(actions.count) * Consts.defaultButtonWidth

            let x = max(0, -(translation + location))

            if x < w {
                position = x/w
            } else {
                position = pow(CGFloat(M_E), 1-w/x)
            }
        }
    }

    private func panGestureDidChangeState() {
        switch panGesture.state {
        case .began:
            closeAllButMe(animated: true)

            rebuildButtonStackIfNeeded()

            location = contentView.frame.minX
        case .changed:
            translation = panGesture.translation(in: contentView).x
        default:
            let newPosition: CGFloat = position > 1 ? 1 : (translation > 0 ? 0 : 1)

            set(position: newPosition, animated: true)
        }
    }

    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer === panGesture, panGesture.numberOfTouches == 1 else {
            return true
        }

        let translation = panGesture.translation(in: contentView)

        return abs(translation.y) < abs(translation.x)
    }

    // MARK: -

    private func set(position value: CGFloat, animated: Bool) {
        guard position != value else {
            return
        }

        UIView.animate(withDuration: animated ? Consts.defaultAnimationDuration : 0, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: { [weak self] in
            self?.position = value
        })
    }

    private var position: CGFloat = .nan {
        didSet {
            guard position != oldValue else {
                return
            }

            if position > 0 {
                rebuildButtonStackIfNeeded()
            }
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let B = bounds

        buttonsContainerView.frame = B

        let position = self.position

        guard !position.isNaN else {
            contentView.frame = B

            return
        }

        let buttons = buttonsContainerView.subviews

        let count = buttons.count

        let W = B.width
        let H = B.height

        let w = CGFloat(count) * Consts.defaultButtonWidth

        let x = w * position

        contentView.frame = CGRect(x: -x, y: 0, width: W, height: H)

        let overflow = max(0, x - w)

        let buttonWidth = Consts.defaultButtonWidth + overflow / CGFloat(count)

        buttons.enumerated().forEach { (index, button) in
            let x = (W - CGFloat(count - index) * Consts.defaultButtonWidth * position)

            button.frame = CGRect(x: x, y: 0, width: buttonWidth, height: H)
        }
    }
}
