import Foundation
import UIKit
import ALLKit

final class CombinedLayoutViewController: UIViewController {
    private lazy var scrollView = UIScrollView()

    private lazy var layoutView = SwitcherListLayoutView()

    private lazy var layoutDescription = SwitcherListLayoutDescription(titleList: DemoContent.NATO)

    private var currentLayout: ViewLayout<SwitcherListLayoutView>? {
        didSet {
            currentLayout?.configure(view: layoutView)
            scrollView.contentSize = currentLayout?.size ?? .zero
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            view.backgroundColor = UIColor.white

            view.addSubview(scrollView)

            scrollView.addSubview(layoutView)
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        scrollView.frame = view.bounds

        currentLayout = layoutDescription.makeViewLayoutWith(boundingSize: BoundingSize(width: view.bounds.width, height: .nan))
    }
}
