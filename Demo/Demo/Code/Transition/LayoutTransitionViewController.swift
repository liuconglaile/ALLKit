import Foundation
import UIKit
import ALLKit

struct UserProfile {
    let avatar: URL?
    let name: String
    let description: String
}

final class LayoutTransitionViewController: UIViewController {
    private let userProfile = UserProfile(
        avatar: URL(string: "https://picsum.photos/100/100?random&q=\(arc4random())"),
        name: "John Smith",
        description: DemoContent.loremIpsum.joined(separator: ". ")
    )

    private lazy var scrollView = UIScrollView()

    private lazy var layoutView = ProfileLayoutView()

    private lazy var portraitLayoutDescription = PortraitProfileLayoutDescription(profile: userProfile)
    private lazy var landscapeLayoutDescription = LandscapeProfileLayoutDescription(profile: userProfile)

    private var currentLayout: ViewLayout<ProfileLayoutView>? {
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

        let size = view.bounds.size

        if size.width > size.height {
            currentLayout = landscapeLayoutDescription.makeViewLayoutWith(boundingSize: BoundingSize(width: size.width, height: .nan))
        } else {
            currentLayout = portraitLayoutDescription.makeViewLayoutWith(boundingSize: BoundingSize(width: size.width, height: .nan))
        }
    }
}
