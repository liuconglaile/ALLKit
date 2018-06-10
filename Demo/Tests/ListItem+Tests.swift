import XCTest
import Foundation
import UIKit

@testable
import ALLKit

private class TestLayoutSpec: LayoutSpec {
    override func makeNode() -> Node {
        return Node()
    }
}

private struct TestModel: Equatable {
    let id: String
    let value: Int

    static func ==(lhs: TestModel, rhs: TestModel) -> Bool {
        return lhs.id == rhs.id && lhs.value == rhs.value
    }
}

class ListItemTests: XCTestCase {
    func testEquality() {
        let m1 = TestModel(id: "1", value: 100)
        let m2 = TestModel(id: "2", value: 200)
        let m3 = TestModel(id: "1", value: 100)

        let item1 = ListItem(id: m1.id, model: m1, layoutSpec: TestLayoutSpec())
        let item2 = ListItem(id: m2.id, model: m2, layoutSpec: TestLayoutSpec())
        let item3 = ListItem(id: m3.id, model: m3, layoutSpec: TestLayoutSpec())

        XCTAssert(item1.isEqual(to: item3))
        XCTAssert(item3.isEqual(to: item1))
        XCTAssert(!item1.isEqual(to: item2))
        XCTAssert(!item3.isEqual(to: item2))
    }
}
