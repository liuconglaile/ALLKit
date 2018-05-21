import UIKit
import XCTest

@testable
import ALLKit

private class DemoLayoutDescription: ViewLayoutDescription<UIView> {
    init(text: String) {
        let attributedText = text.attributed()
            .font(UIFont.systemFont(ofSize: 14))
            .foregroundColor(UIColor.black)
            .make()

        super.init { viewFactories -> YogaNode in
            let rootNode = YogaNode()

            let textNode = YogaTextNode().viewFactory(&viewFactories, { (label: UILabel, _) in
                label.attributedText = attributedText
            })

            rootNode.add(textNode)

            return rootNode
        }
    }
}

class LayoutTests: XCTestCase {
    func testConfigView() {
        let view = UIView()

        let ld1 = DemoLayoutDescription(text: "abc")
        let ld2 = DemoLayoutDescription(text: "xyz")

        ld1.makeViewLayoutWith(boundingSize: BoundingSize(width: 100, height: .nan)).configure(view: view)

        XCTAssert(view.subviews.count == 1 && (view.subviews.first as? UILabel)?.attributedText?.string == "abc")

        ld2.makeViewLayoutWith(boundingSize: BoundingSize(width: 100, height: .nan)).configure(view: view)

        XCTAssert(view.subviews.count == 1 && (view.subviews.first as? UILabel)?.attributedText?.string == "xyz")
    }
}
