import Foundation
import UIKit
import ALLKit

final class AutoDiffViewController: UIViewController {
    private struct Consts {
        static let spacing: CGFloat = 4
    }

    private let adapter = CollectionViewAdapter(
        scrollDirection: .vertical,
        sectionInset: UIEdgeInsets(top: Consts.spacing, left: Consts.spacing, bottom: Consts.spacing, right: Consts.spacing),
        minimumLineSpacing: Consts.spacing,
        minimumInteritemSpacing: Consts.spacing
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            view.backgroundColor = UIColor.white

            view.addSubview(adapter.collectionView)

            adapter.collectionView.backgroundColor = UIColor.white
        }

        do {
            adapter.behavior.allowMovesInBatchUpdates = true
        }

        do {
            let controlsView = AdapterControlsLayoutDescription(
                delayChanged: { [weak self] delay in
                    self?.delay = delay
                },
                movesEnabledChanged: { [weak self] movesEnabled in
                    self?.adapter.behavior.allowMovesInBatchUpdates = movesEnabled
                }
            ).makeViewLayoutWith(boundingSize: BoundingSize(width: 300, height: 40)).makeView()

            setToolbarItems([UIBarButtonItem(customView: controlsView)], animated: false)
        }

        generateItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setToolbarHidden(false, animated: animated)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        adapter.collectionView.frame = view.bounds

        let numberOfColumns = 4

        let size = (view.bounds.width - CGFloat(numberOfColumns + 1) * Consts.spacing) / CGFloat(numberOfColumns) - 1

        adapter.set(boundingSize: BoundingSize(width: size, height: size))
    }

    private func generateItems() {
        let numbers = (0..<100).map { _ in Int(arc4random_uniform(100)) }

        let items = numbers.map { number -> ListViewItem in
            ListItem(id: String(number), model: number, layoutDescription: NumberLayoutDescription(number: number))
        }

        adapter.set(items: items)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.generateItems()
        }
    }

    private var delay: TimeInterval = 0.5
}