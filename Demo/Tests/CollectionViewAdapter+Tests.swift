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

class CollectionViewAdapterTests: XCTestCase {
    func testStability() {
        let adapter = CollectionViewAdapter()

        let n = 1000

        let exp = XCTestExpectation()

        (0..<n).forEach { i in
            if i < n - 1 {
                if i % 5 == 0 {
                    let bs = BoundingSize(width: CGFloat(drand48() * 1000), height: CGFloat(drand48() * 1000))

                    adapter.set(boundingSize: bs)
                } else {
                    let items = (0..<arc4random() % 20).map({ _ -> ListItem in
                        ListItem(
                            id: UUID().uuidString,
                            model: UUID().uuidString,
                            layoutSpec: TestLayoutSpec()
                        )
                    })

                    adapter.set(items: items)
                }
            } else {
                adapter.set(boundingSize: BoundingSize(width: 500, height: 500), completion: {
                    exp.fulfill()
                })
            }
        }

        wait(for: [exp], timeout: 60)
    }
}
