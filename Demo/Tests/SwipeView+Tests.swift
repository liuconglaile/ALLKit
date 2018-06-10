import XCTest
import Foundation
import UIKit

@testable
import ALLKit

class SwipeViewTests: XCTestCase {
    func testStability() {
        let view = SwipeView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))

        let action1 = SwipeAction(text: "1".attributed().font(UIFont.boldSystemFont(ofSize: 10)).foregroundColor(UIColor.black).make(), color: UIColor.white, {})
        let action2 = SwipeAction(text: "2".attributed().font(UIFont.boldSystemFont(ofSize: 10)).foregroundColor(UIColor.black).make(), color: UIColor.white, {})
        let action3 = SwipeAction(text: "3".attributed().font(UIFont.boldSystemFont(ofSize: 10)).foregroundColor(UIColor.black).make(), color: UIColor.white, {})

        view.actions = []
        view.open(animated: true)
        view.actions = [action1]
        view.close(animated: false)
        view.actions = []
        view.open(animated: true)

        view.closeAllButMe(animated: true)

        view.actions = [action1, action2]
        view.close(animated: false)
        view.actions = []
        view.open(animated: true)

        SwipeView.closeAll(animated: true)

        view.actions = [action1, action2, action3]
        view.close(animated: false)
        view.open(animated: false)

        let exp = XCTestExpectation()

        DispatchQueue.main.async {
            exp.fulfill()
        }

        wait(for: [exp], timeout: 0.1)

        XCTAssert(view.contentView.frame.origin.x < 0)
    }
}
