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
    private lazy var contentView = UIView()

    private lazy var portraitLayoutSpec = PortraitProfileLayoutSpec(profile: userProfile)
    private lazy var landscapeLayoutSpec = LandscapeProfileLayoutSpec(profile: userProfile)

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            view.backgroundColor = UIColor.white

            view.addSubview(scrollView)

            scrollView.addSubview(contentView)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        scrollView.frame = view.bounds

        let size = view.bounds.size

        let layoutSpec = size.width > size.height ? landscapeLayoutSpec : portraitLayoutSpec

        let layout = layoutSpec.makeLayoutWith(boundingSize: BoundingSize(width: size.width))

        scrollView.contentSize = layout.size
        layout.setup(in: contentView)
    }
}
