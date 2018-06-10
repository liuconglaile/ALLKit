import Foundation
import UIKit
import ALLKit

final class AdapterControlsLayoutSpec: LayoutSpec {
    private let delayChanged: (TimeInterval) -> Void
    private let movesEnabledChanged: (Bool) -> Void

    init(delayChanged: @escaping (TimeInterval) -> Void,
         movesEnabledChanged: @escaping (Bool) -> Void) {

        self.delayChanged = delayChanged
        self.movesEnabledChanged = movesEnabledChanged
    }

    override func makeNode() -> Node {
        let delayChanged = self.delayChanged
        let movesEnabledChanged = self.movesEnabledChanged

        let sliderTitle = "Reload delay".attributed()
            .font(.systemFont(ofSize: 8))
            .foregroundColor(UIColor.black)
            .make()

        let switcherTitle = "Moves enabled".attributed()
            .font(.systemFont(ofSize: 8))
            .foregroundColor(UIColor.black)
            .make()

        let sliderTitleNode = Node(text: sliderTitle, config: { node in
            node.width = 40
        }) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = sliderTitle
        }

        let sliderNode = Node(config: { node in
            node.marginLeft = 8
            node.height = 24
            node.width = 80
        }) { (slider: UISlider, firstTime) in
            if firstTime {
                slider.minimumValue = 0.05
                slider.maximumValue = 2.0
                slider.value = 0.5
            }

            slider.handle(.valueChanged, { [weak slider] in
                guard let slider = slider else { return }

                delayChanged(TimeInterval(slider.value))
            })
        }

        guard #available(iOS 11.0, *) else {
            return Node(children: [sliderTitleNode, sliderNode], config: { node in
                node.flexDirection = .row
                node.alignItems = .center
            })
        }

        let swicherTitleNode = Node(text: switcherTitle, config: { node in
            node.marginLeft = 40
            node.width = 40
        }) { (label: UILabel, _) in
            label.numberOfLines = 0
            label.attributedText = switcherTitle
        }

        let switcherNode = Node(config: { node in
            node.marginLeft = 8
            node.width = 51
            node.height = 32
        }) { (switcher: UISwitch, firstTime) in
            if firstTime {
                switcher.setOn(true, animated: false)
            }

            switcher.handle(.valueChanged, { [weak switcher] in
                guard let switcher = switcher else { return }

                movesEnabledChanged(switcher.isOn)
            })
        }

        return Node(children: [sliderTitleNode, sliderNode, swicherTitleNode, switcherNode], config: { node in
            node.flexDirection = .row
            node.alignItems = .center
        })
    }
}
