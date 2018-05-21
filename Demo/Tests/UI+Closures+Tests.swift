import XCTest
import ALLKit

class UIClosuresTests: XCTestCase {
    func testSimpleEvent() {
        var result = false

        let btn = UIButton()

        btn.handle(.touchUpInside) { result = true }
        btn.sendActions(for: .touchUpInside)

        XCTAssert(result)
    }

    func testOverrideEvent() {
        var result = ""

        let btn = UIButton()

        btn.handle(.touchUpInside) { result.append("a") }
        btn.sendActions(for: .touchUpInside)

        btn.handle(.touchUpInside) { result.append("b") }
        btn.sendActions(for: .touchUpInside)

        XCTAssert(result == "ab")
    }

    func testCombinedEvents() {
        var result = ""

        let btn = UIButton()

        btn.handle(.touchUpInside) { result.append("a") }
        btn.handle(.touchUpOutside) { result.append("b") }
        btn.handle([.touchUpInside, .touchUpOutside]) { result.append("c") }

        btn.sendActions(for: .touchUpInside)
        btn.sendActions(for: .touchUpOutside)

        XCTAssert(result == "acbc")
    }
}
