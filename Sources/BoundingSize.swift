import Foundation
import UIKit

public struct BoundingSize: Equatable {
    public let width: CGFloat
    public let height: CGFloat

    public init(width: CGFloat = .nan, height: CGFloat = .nan) {
        self.width = width
        self.height = height
    }

    public static func == (lhs: BoundingSize, rhs: BoundingSize) -> Bool {
        func isEqual(_ x: CGFloat, _ y: CGFloat) -> Bool {
            return x.isNaN && y.isNaN || x == y
        }

        return isEqual(lhs.width, rhs.width) && isEqual(lhs.height, rhs.height)
    }
}
