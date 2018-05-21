import Foundation
import UIKit
import ALLKit

final class LayoutAnimationViewController: UIViewController {
    private lazy var layoutView = CircleAndSquareLayoutView()

    private let layoutDescription = CircleAndSquareLayoutDescription()

    private var currentLayout: ViewLayout<CircleAndSquareLayoutView>? {
        didSet {
            UIView.animate(withDuration: 1) {
                self.currentLayout?.configure(view: self.layoutView)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            view.backgroundColor = UIColor.white

            view.addSubview(layoutView)
        }

        do {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        layoutView.frame = view.bounds

        refresh()
    }

    @objc
    private func refresh() {
        currentLayout = layoutDescription.makeViewLayoutWith(boundingSize: BoundingSize(width: view.bounds.width, height: view.bounds.height))
    }
}
