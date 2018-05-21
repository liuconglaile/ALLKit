import XCTest
import ALLKit

private struct Model: Hashable {
    let id: String
    let value: String

    var hashValue: Int {
        return id.hashValue
    }

    static func ==(lhs: Model, rhs: Model) -> Bool {
        return lhs.id == rhs.id && lhs.value == rhs.value
    }
}

class DiffTests: XCTestCase {
    func testAllInserts() {
        let result = Diff.result(Array(""), Array("abc"))

        XCTAssert(result.deletes.isEmpty)
        XCTAssert(result.moves.isEmpty)
        XCTAssert(result.updates.isEmpty)
        XCTAssert(result.inserts == [0,1,2])
    }

    func testAllDeletes() {
        let result = Diff.result(Array("abc"), Array(""))

        XCTAssert(result.deletes == [0,1,2])
        XCTAssert(result.moves.isEmpty)
        XCTAssert(result.updates.isEmpty)
        XCTAssert(result.inserts.isEmpty)
    }

    func testNoChanges1() {
        let result = Diff.result(Array(""), Array(""))

        XCTAssert(result.changesCount == 0)
    }

    func testNoChanges2() {
        let result = Diff.result(Array("abc"), Array("abc"))

        XCTAssert(result.changesCount == 0)
    }

    func testSimpleMove() {
        let result = Diff.result(Array("abc"), Array("acb"))

        let m = result.moves

        XCTAssert(result.deletes.isEmpty)
        XCTAssert(m.count == 2 && m[0].from == 2 && m[0].to == 1 && m[1].from == 1 && m[1].to == 2)
        XCTAssert(result.updates.isEmpty)
        XCTAssert(result.inserts.isEmpty)
    }

    func testUpdates() {
        let result = Diff.result([Model(id: "1", value: "A"), Model(id: "2", value: "b")],
                                 [Model(id: "1", value: "A"), Model(id: "2", value: "B")])
        
        let u = result.updates
        
        XCTAssert(result.deletes.isEmpty)
        XCTAssert(result.moves.isEmpty)
        XCTAssert(u.count == 1 && u[0].old == 1 && u[0].new == 1)
        XCTAssert(result.inserts.isEmpty)
    }

    func testNew() {
        let result = Diff.result(Array("abc"), Array("xyz"))

        XCTAssert(result.deletes.count == 3)
        XCTAssert(result.moves.isEmpty)
        XCTAssert(result.updates.isEmpty)
        XCTAssert(result.inserts.count == 3)
    }

    func testPerfomance() {
        let a1 = (0..<1000).map { _ in arc4random() }
        let a2 = (0..<1000).map { _ in arc4random() }

        measure {
            _ = Diff.result(a1, a2)
        }
    }
}
