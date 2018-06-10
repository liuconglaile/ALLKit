import XCTest
import ALLKit

class BoundingSizeTests: XCTestCase {
    func test1() {
        let x = BoundingSize(width: 100)
        let y = BoundingSize(width: 100)

        XCTAssert(x == y)
    }

    func test2() {
        let x = BoundingSize(height: 100)
        let y = BoundingSize(height: 100)

        XCTAssert(x == y)
    }

    func test3() {
        let x = BoundingSize(width: 100, height: 100)
        let y = BoundingSize(width: 100, height: 100)

        XCTAssert(x == y)
    }
}
