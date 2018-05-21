import Foundation
import UIKit

public final class AsyncLabel: UIView {
    private let renderQueue = DispatchQueue(label: "")

    public var text: NSAttributedString? {
        didSet {
            let size = bounds.size

            renderQueue.async {
                guard let text = self.text else {
                    DispatchQueue.main.async {
                        self.layer.contents = nil
                    }

                    return
                }

                UIGraphicsBeginImageContextWithOptions(size, false, 0)

                text.draw(with: CGRect(origin: .zero, size: size), options: .usesLineFragmentOrigin, context: nil)

                let image = UIGraphicsGetImageFromCurrentImageContext()

                UIGraphicsEndImageContext()

                DispatchQueue.main.async {
                    self.layer.contents = image?.cgImage
                }
            }
        }
    }
}
