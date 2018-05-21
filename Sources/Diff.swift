import Foundation

public protocol Diffable {
    var diffId: String { get }

    func isEqual(to object: Diffable) -> Bool
}

public struct DiffResult {
    public typealias Index = Int
    public typealias Update = (old: Index, new: Index)
    public typealias Move = (from: Index, to: Index)

    public let oldCount: Int
    public let newCount: Int

    public fileprivate(set) var deletes: [Index]
    public fileprivate(set) var inserts: [Index]
    public fileprivate(set) var updates: [Update]
    public fileprivate(set) var moves: [Move]

    public var changesCount: Int {
        return deletes.count + inserts.count + updates.count + moves.count
    }
}

public final class Diff {
    private init() {}

    private class Entry {
        var newCount: Int = 0
        var oldIndexes = ArraySlice<Int>()
    }

    private struct Record {
        let entry: Entry
        var reference: Int?
    }

    private static func result<ModelType, KeyType: Hashable>(_ oldArray: [ModelType],
                                                             _ newArray: [ModelType],
                                                             hash: (ModelType) -> KeyType,
                                                             isEqual: (ModelType, ModelType) -> Bool) -> DiffResult {
        var result = DiffResult(
            oldCount: oldArray.count,
            newCount: newArray.count,
            deletes: [],
            inserts: [],
            updates: [],
            moves: []
        )

        // -------------------------------------------------------

        if oldArray.isEmpty && newArray.isEmpty {
            return result
        }

        if oldArray.isEmpty {
            result.inserts = Array(newArray.indices)

            return result
        }

        if newArray.isEmpty {
            result.deletes = Array(oldArray.indices)

            return result
        }

        // -------------------------------------------------------

        var table = [KeyType: Entry]()

        var newRecords = newArray.map { object -> Record in
            let key = hash(object)

            let entry = table[key] ?? Entry()
            entry.newCount += 1
            table[key] = entry

            return Record(entry: entry, reference: nil)
        }

        var oldRecords = oldArray.enumerated().map { (index, object) -> Record in
            let key = hash(object)

            let entry = table[key] ?? Entry()
            entry.oldIndexes.append(index)
            table[key] = entry

            return Record(entry: entry, reference: nil)
        }

        table.removeAll()

        // -------------------------------------------------------

        newRecords.enumerated().forEach { (newIndex, newRecord) in
            let entry = newRecord.entry

            guard entry.newCount > 0, let oldIndex = entry.oldIndexes.popFirst() else {
                return
            }

            newRecords[newIndex].reference = oldIndex
            oldRecords[oldIndex].reference = newIndex
        }

        // -------------------------------------------------------

        var offset = 0

        let deleteOffsets = oldRecords.enumerated().map { (oldIndex, oldRecord) -> Int in
            let deleteOffset = offset

            if oldRecord.reference == nil {
                result.deletes.append(oldIndex)

                offset += 1
            }

            return deleteOffset
        }

        // -------------------------------------------------------

        offset = 0

        newRecords.enumerated().forEach { (newIndex, newRecord) in
            guard let oldIndex = newRecord.reference else {
                result.inserts.append(newIndex)

                offset += 1

                return
            }

            let deleteOffset = deleteOffsets[oldIndex]
            let insertOffset = offset

            let moved = (oldIndex - deleteOffset + insertOffset) != newIndex
            let updated = !isEqual(newArray[newIndex], oldArray[oldIndex])

            if updated {
                result.updates.append((oldIndex, newIndex))
            }

            if moved {
                result.moves.append((oldIndex, newIndex))
            }
        }

        // -------------------------------------------------------

        return result
    }

    // MARK: -

    public static func result(_ oldArray: [Diffable], _ newArray: [Diffable]) -> DiffResult {
        return result(oldArray,
                      newArray,
                      hash: { $0.diffId },
                      isEqual: { $0.isEqual(to: $1) })
    }

    public static func result<ModelType: Hashable>(_ oldArray: [ModelType], _ newArray: [ModelType]) -> DiffResult {
        return result(oldArray,
                      newArray,
                      hash: { $0.hashValue },
                      isEqual: { $0 == $1 })
    }
}
