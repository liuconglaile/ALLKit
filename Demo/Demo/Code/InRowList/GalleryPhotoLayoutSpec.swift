import Foundation
import UIKit
import ALLKit
import YYWebImage

final class GalleryPhotoLayoutSpec: LayoutSpec {
    private let url: URL

    init(url: URL) {
        self.url = url
    }

    override func makeNode() -> Node {
        let url = self.url
        
        let imageNode = Node(config: { node in
            node.aspectRatio = Float(4.0/3.0)
        }) { (imageView: UIImageView, firstTime) in
            if firstTime {
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFill
            }

            imageView.yy_setImage(with: url, options: .setImageWithFadeAnimation)
        }

        return Node(children: [imageNode], config: { node in
            node.flexDirection = .row
            node.alignItems = .stretch
        })
    }
}
