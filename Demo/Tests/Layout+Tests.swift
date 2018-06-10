import UIKit
import XCTest

@testable
import ALLKit

private class LayoutSpec1: LayoutSpec {
    private let text: String

    init(text: String) {
        self.text = text
    }

    override func makeNode() -> Node {
        let attributedText = text.attributed()
            .font(UIFont.systemFont(ofSize: 14))
            .foregroundColor(UIColor.black)
            .make()

        let textNode = Node(text: attributedText) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = attributedText
        }

        return Node(children: [textNode])
    }
}

private class LayoutSpec2: LayoutSpec {
    override func makeNode() -> Node {
        let node1 = Node(config: { node in
            node.width = 100
            node.height = 100
        }) { (view: UIView, _) in }

        let node2 = Node(config: { node in
            node.width = 110
            node.height = 110
            node.marginLeft = 10
        }) { (view: UIView, _) in }

        return Node(children: [node1, node2], config: { node in
            node.padding(all: 10)
            node.flexDirection = .row
            node.alignItems = .center
        })
    }
}

private class LayoutSpec3: LayoutSpec {
    override func makeNode() -> Node {
        let viewNodes = (0..<100).map { _ in
            Node(config: { node in
                node.width = 100
                node.height = 100
                node.margin(all: 5)
            }) { (view: UIView, _) in }
        }

        let contentNode = Node(children: viewNodes, config: { node in
            node.flexDirection = .row
            node.padding(all: 5)
        })

        return Node(children: [contentNode])
    }
}

class LayoutTests: XCTestCase {
    func testConfigView() {
        let view = UIView()

        let ls1 = LayoutSpec1(text: "abc")
        let ls2 = LayoutSpec1(text: "xyz")

        ls1.makeLayoutWith(boundingSize: BoundingSize(width: 100)).setup(in: view)

        let lbl1 = view.subviews.first as! UILabel

        XCTAssert(lbl1.attributedText?.string == "abc")

        ls2.makeLayoutWith(boundingSize: BoundingSize(width: 100)).setup(in: view)

        let lbl2 = view.subviews.first as! UILabel

        XCTAssert(lbl1 === lbl2)

        XCTAssert(lbl2.attributedText?.string == "xyz")
    }

    func testFramesAndOrigins() {
        let view = UIView()

        LayoutSpec2().makeLayoutWith(boundingSize: BoundingSize()).setup(in: view)

        XCTAssert(view.frame.size == CGSize(width: 240, height: 130))
        XCTAssert(view.subviews[0].frame == CGRect(x: 10, y: 15, width: 100, height: 100))
        XCTAssert(view.subviews[1].frame == CGRect(x: 120, y: 10, width: 110, height: 110))
    }

    func testViewTags() {
        let view = UIView()

        LayoutSpec3().makeLayoutWith(boundingSize: BoundingSize()).setup(in: view)

        view.subviews.enumerated().forEach { (index, subview) in
            XCTAssert(subview.tag == index + 1)
        }
    }
}
