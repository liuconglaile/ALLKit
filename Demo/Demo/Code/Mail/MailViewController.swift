import Foundation
import UIKit
import ALLKit

private struct MailRow: Equatable {
    let id = UUID().uuidString
    let title: String
    let text: String

    static func ==(lhs: MailRow, rhs: MailRow) -> Bool {
        return lhs.id == rhs.id
    }
}

final class MailViewController: UIViewController {
    let adapter = CollectionViewAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            view.backgroundColor = UIColor.white

            view.addSubview(adapter.collectionView)

            adapter.collectionView.backgroundColor = UIColor.white
        }

        do {
            let sentences = DemoContent.loremIpsum

            rows = (0..<15).map({ _ -> MailRow in
                let text = sentences[Int(UInt(arc4random()) % UInt(sentences.count))]

                return MailRow(title: UUID().uuidString, text: text)
            })
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        adapter.collectionView.frame = view.bounds

        adapter.set(boundingSize: BoundingSize(width: view.bounds.width, height: .nan))
    }

    private var rows: [MailRow] = [] {
        didSet {
            let items = rows.map { row -> ListViewItem in
                var item = ListItem(id: row.id, model: row, layoutDescription: MailRowLayoutDescription(title: row.title, text: row.text))

                let deleteAction = SwipeAction(
                    text: "Delete".attributed().font(.boldSystemFont(ofSize: 10)).foregroundColor(.white).make(),
                    color: #colorLiteral(red: 0.7450980544, green: 0.1884698107, blue: 0.1212462212, alpha: 1), { [weak self] in
                        guard let strongSelf = self else { return }

                        _ = strongSelf.rows.index(of: row).flatMap { strongSelf.rows.remove(at: $0) }
                })

                let customAction = SwipeAction(
                    text: "Other".attributed().font(.boldSystemFont(ofSize: 10)).foregroundColor(.white).make(),
                    color: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), { [weak self] in
                        guard let strongSelf = self else { return }

                        let alert = UIAlertController(title: "WOW", message: "This is alert", preferredStyle: .alert)

                        alert.addAction(UIAlertAction(title: "Close me", style: .cancel, handler: nil))

                        strongSelf.present(alert, animated: true, completion: nil)
                })

                item.swipeActions = [deleteAction, customAction]

                return item
            }

            adapter.set(items: items)
        }
    }
}
