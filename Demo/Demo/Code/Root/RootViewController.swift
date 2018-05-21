import Foundation
import UIKit
import ALLKit

final class RootViewController: UIViewController {
    private let adapter = CollectionViewAdapter()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select demo"

        do {
            view.backgroundColor = UIColor.white

            view.addSubview(adapter.collectionView)

            adapter.collectionView.backgroundColor = UIColor.white
        }

        do {
            adapter.behavior.deselectOnSelect = true

            adapter.configureCell = { (cell, _) in
                guard cell.selectedBackgroundView == nil else {
                    return
                }

                let view = UIView()
                view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

                cell.selectedBackgroundView = view
            }
        }

        do {
            typealias MenuRow = (name: String, onSelect: () -> Void)

            let menuRows: [MenuRow] = [
                ("Feed", { [weak self] in
                    let vc = FeedViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                ("Chat", { [weak self] in
                    let vc = ChatViewController()
                    
                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                ("Mail (swipe demo)", { [weak self] in
                    let vc = MailViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                ("Combine layouts (demo with plain UIScrollView)", { [weak self] in
                    let vc = CombinedLayoutViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                ("Layout transition (different layouts for portrait and landscape orientations)", { [weak self] in
                    let vc = LayoutTransitionViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                ("Animations", { [weak self] in
                    let vc = LayoutAnimationViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                ("Diff", { [weak self] in
                    let vc = AutoDiffViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                }),
                ("Bounding size (different item sizes)", { [weak self] in
                    let vc = BoundingSizeDemoViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                })
            ]

            let items = menuRows.flatMap { row -> [ListViewItem] in
                var rowItem = ListItem(id: row.name, model: row.name, layoutDescription: SelectableRowLayoutDescription(text: row.name))

                rowItem.onSelect = row.onSelect

                let sep = row.name + "_sep"

                var rowSeparatorItem = ListItem(id: sep, model: sep, layoutDescription: RowSeparatorLayoutDescription())

                rowSeparatorItem.canSelect = false

                return [rowItem, rowSeparatorItem]
            }

            adapter.set(items: items)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setToolbarHidden(true, animated: animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        adapter.collectionView.frame = view.bounds

        adapter.set(boundingSize: BoundingSize(width: view.bounds.width, height: .nan))
    }
}
