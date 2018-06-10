import Foundation
import UIKit
import ALLKit

final class LayoutAnimationViewController: UIViewController {
    private lazy var contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        view.addSubview(contentView)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refresh)
        )
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        refresh()
    }

    @objc
    private func refresh() {
        let boundingSize = BoundingSize(width: view.bounds.width, height: view.bounds.height)

        UIView.animate(withDuration: 1) {
            CircleAndSquareLayoutSpec().makeLayoutWith(boundingSize: boundingSize).setup(in: self.contentView)
        }
    }
}
