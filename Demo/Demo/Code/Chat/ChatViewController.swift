import Foundation
import UIKit
import ALLKit

struct ChatColors {
    static let incoming = #colorLiteral(red: 0.9214877486, green: 0.9216202497, blue: 0.9214588404, alpha: 1)
    static let outgoing = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
}

private struct Message: Equatable {
    let id = UUID().uuidString
    let text: String
    let date: Date

    static func ==(lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
}

final class ChatViewController: UIViewController {
    private let adapter = CollectionViewAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            view.backgroundColor = UIColor.white

            view.addSubview(adapter.collectionView)

            adapter.collectionView.backgroundColor = UIColor.white

            if #available(iOS 11.0, *) {
                adapter.collectionView.contentInsetAdjustmentBehavior = .never
            } else {
                automaticallyAdjustsScrollViewInsets = false
            }

            adapter.collectionView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)

            adapter.collectionEvents.willDisplayCell = { (cell, _) in
                UIView.performWithoutAnimation {
                    cell.contentView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                }
            }
        }

        do {
            DispatchQueue.global().async {
                let items = self.generateItems()

                DispatchQueue.main.async {
                    self.adapter.set(items: items)
                }
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        adapter.collectionView.frame = view.bounds

        adapter.set(boundingSize: BoundingSize(width: view.bounds.width, height: .nan))
    }

    private func generateItems() -> [ListViewItem] {
        let sentences = DemoContent.loremIpsum
        let emodji = DemoContent.emodjiString

        return (0..<100).flatMap { n -> [ListViewItem] in
            let firstMessageItem: ListViewItem

            do {
                let text = sentences[Int(UInt(arc4random()) % UInt(sentences.count))]
                let message = Message(text: text, date: Date())

                if n % 2 == 0 {
                    firstMessageItem = ListItem(id: message.id, model: message, layoutDescription: IncomingTextMessageLayoutDescription(text: message.text, date: message.date))
                } else {
                    firstMessageItem = ListItem(id: message.id, model: message, layoutDescription: OutgoingTextMessageLayoutDescription(text: message.text, date: message.date))
                }
            }

            let secondMessageItem: ListViewItem

            do {
                let text = String(emodji.prefix(Int(UInt(arc4random()) % UInt(emodji.count))))
                let message = Message(text: text, date: Date())

                if n % 2 == 0 {
                    secondMessageItem = ListItem(id: message.id, model: message, layoutDescription: IncomingTextMessageLayoutDescription(text: message.text, date: message.date))
                } else {
                    secondMessageItem = ListItem(id: message.id, model: message, layoutDescription: OutgoingTextMessageLayoutDescription(text: message.text, date: message.date))
                }
            }

            return [firstMessageItem, secondMessageItem]
        }
    }
}
