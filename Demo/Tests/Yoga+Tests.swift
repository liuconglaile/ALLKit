import XCTest
import Foundation
import UIKit
import ALLKit
import yoga

class YogaTests: XCTestCase {
    func testStability() {
        let yoga = YogaNode(useTextSize: false)

        yoga.flexDirection = .column
        XCTAssert(yoga.flexDirection == .column)

        yoga.flex = 1
        XCTAssert(yoga.flex == 1)

        yoga.flexWrap = .wrap
        XCTAssert(yoga.flexWrap == .wrap)

        yoga.flexGrow = 1
        XCTAssert(yoga.flexGrow == 1)

        yoga.flexShrink = 1
        XCTAssert(yoga.flexShrink == 1)

        yoga.flexBasis = 50%
        XCTAssert(yoga.flexBasis == 50%)

        yoga.display = .none
        XCTAssert(yoga.display == .none)

        yoga.aspectRatio = Float(4.0/3.0)
        XCTAssert(yoga.aspectRatio == Float(4.0/3.0))

        yoga.justifyContent = .center
        XCTAssert(yoga.justifyContent == .center)

        yoga.alignContent = .center
        XCTAssert(yoga.alignContent == .center)

        yoga.alignItems = .center
        XCTAssert(yoga.alignItems == .center)

        yoga.alignSelf = .stretch
        XCTAssert(yoga.alignSelf == .stretch)

        yoga.positionType = .absolute
        XCTAssert(yoga.positionType == .absolute)

        yoga.width = 100%
        XCTAssert(yoga.width == 100%)

        yoga.height = 100%
        XCTAssert(yoga.height == 100%)

        yoga.minWidth = 10
        XCTAssert(yoga.minWidth == 10)

        yoga.minHeight = 10
        XCTAssert(yoga.minHeight == 10)

        yoga.maxWidth = 1000
        XCTAssert(yoga.maxWidth == 1000)

        yoga.maxHeight = 1000
        XCTAssert(yoga.maxHeight == 1000)

        yoga.top = 5
        XCTAssert(yoga.top == 5)

        yoga.right = 5
        XCTAssert(yoga.right == 5)

        yoga.bottom = 5
        XCTAssert(yoga.bottom == 5)

        yoga.left = 5
        XCTAssert(yoga.left == 5)

        yoga.padding(all: 20)
        XCTAssert(yoga.paddingTop == 20)
        XCTAssert(yoga.paddingLeft == 20)
        XCTAssert(yoga.paddingRight == 20)
        XCTAssert(yoga.paddingBottom == 20)

        yoga.margin(all: 20)
        XCTAssert(yoga.marginTop == 20)
        XCTAssert(yoga.marginLeft == 20)
        XCTAssert(yoga.marginRight == 20)
        XCTAssert(yoga.marginBottom == 20)

        yoga.border = 1
        XCTAssert(yoga.border == 1)

        yoga.add(child: YogaNode(useTextSize: false))
            .add(child: YogaNode(useTextSize: false))

        yoga.calculateLayoutWith(boundingSize: BoundingSize(width: 500, height: 500))
    }

    func testTextNode() {
        let yoga = YogaNode(useTextSize: true)

        yoga.text = "Hello, World!".attributed()
            .font(UIFont.boldSystemFont(ofSize: 40))
            .foregroundColor(UIColor.black)
            .make()

        yoga.calculateLayoutWith(boundingSize: BoundingSize(width: 100, height: .nan))

        XCTAssert(yoga.frame.width == 100)
    }
}
