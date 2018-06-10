import Foundation
import UIKit
import ALLKit

final class GalleryItemLayoutSpec: LayoutSpec {
    private let name: String
    private let images: [URL]

    init(name: String, images: [URL]) {
        self.name = name
        self.images = images
    }

    override func makeNode() -> Node {
        let title = name.attributed()
            .font(UIFont.boldSystemFont(ofSize: 20))
            .foregroundColor(UIColor.black)
            .make()

        let images = self.images

        let titleNode = Node(text: title, config: { node in
            node.margin(all: 16)
        }) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = title
        }

        let galleryNode = Node(config: { node in
            node.height = 128
        }) { (view: GalleryView, _) in
            view.images = images
        }

        return Node(children: [titleNode, galleryNode], config: { node in
            node.flexDirection = .column
        })
    }
}
