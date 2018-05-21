import Foundation
import UIKit

private class ContentView: UIView, UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer.view === self, let pan = gestureRecognizer as? UIPanGestureRecognizer, pan.numberOfTouches == 1 else {
            return true
        }

        let translation = pan.translation(in: self)

        return abs(translation.y) < abs(translation.x)
    }
}

final class SwipeableView: UIView {
    private struct Consts {
        static let defaultButtonWidth: CGFloat = 96
        static let defaultAnimationDuration: TimeInterval = 0.2
    }

    // MARK: -

    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = true

        backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor.white

        addSubview(buttonsContainerView)
        addSubview(contentView)

        let pan = contentView.handle { [weak self] (gesture: UIPanGestureRecognizer) in
            self?.handle(pan: gesture)
        }

        pan.delegate = contentView as? UIGestureRecognizerDelegate

        position = 0

        SwipeableView.instances.add(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: -

    let contentView: UIView = ContentView(frame: .zero)

    var actions: [SwipeAction] = [] {
        didSet {
            isButtonStackDirty = true
        }
    }

    func close(animated: Bool) {
        guard position != 0 else {
            return
        }

        UIView.animate(withDuration: animated ? Consts.defaultAnimationDuration : 0, animations: {
            self.position = 0
        })
    }

    // MARK: -

    private static let instances = NSHashTable<SwipeableView>(options: NSPointerFunctions.Options.weakMemory)

    private func closeAllButMe() {
        SwipeableView.instances.allObjects.forEach { swipeableView in
            if swipeableView !== self {
                swipeableView.close(animated: true)
            }
        }
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
        buttonsContainerView.subviews.forEach { view in
            view.removeFromSuperview()
        }

        actions.reversed().forEach { action in
            let button = UIButton(type: .system)
            button.backgroundColor = action.color
            button.setAttributedTitle(action.text, for: .normal)
            button.handle(.touchUpInside, { [weak self] in
                action.toDo()

                self?.close(animated: true)
            })

            buttonsContainerView.addSubview(button)
        }

        position = 0
    }

    // MARK: -

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

    private func handle(pan gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            closeAllButMe()
            rebuildButtonStackIfNeeded()

            location = contentView.frame.minX
        case .changed:
            translation = gesture.translation(in: contentView).x
        default:
            UIView.animate(withDuration: Consts.defaultAnimationDuration, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
                self.position = self.position > 0.5 ? 1 : 0
            }, completion: nil)
        }
    }

    // MARK: -

    private var position: CGFloat = 0 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    override func layoutSubviews() {
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
