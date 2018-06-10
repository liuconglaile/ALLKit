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
            adapter.settings.deselectOnSelect = true

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
                }),
                ("Horizontal list in row", { [weak self] in
                    let vc = MultiGalleriesViewController()

                    self?.navigationController?.pushViewController(vc, animated: true)
                })
            ]

            let items = menuRows.enumerated().flatMap { (index, row) -> [ListItem] in
                let rowItem = ListItem(
                    id: row.name,
                    model: row.name,
                    layoutSpec: SelectableRowLayoutSpec(text: row.name)
                )

                if index % 2 == 0 {
                    let swipeAction = SwipeAction(text: "💥".attributed().font(UIFont.systemFont(ofSize: 40)).make(), color: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), {})

                    rowItem.actions.onSwipe = [swipeAction]
                }

                rowItem.actions.onSelect = row.onSelect
                rowItem.actions.onCopy = {
                    print(row.name)
                }

                let sep = row.name + "_sep"

                let rowSeparatorItem = ListItem(
                    id: sep,
                    model: sep,
                    layoutSpec: RowSeparatorLayoutSpec()
                )

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

        adapter.set(boundingSize: BoundingSize(width: view.bounds.width))
    }
}
