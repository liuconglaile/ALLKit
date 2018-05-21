import Foundation
import UIKit
import ALLKit

final class AdapterControlsLayoutView: UIView {}

final class AdapterControlsLayoutDescription: ViewLayoutDescription<AdapterControlsLayoutView> {
    init(delayChanged: @escaping (TimeInterval) -> Void,
         movesEnabledChanged: @escaping (Bool) -> Void) {

        let sliderTitle = "Reload delay".attributed()
            .font(.systemFont(ofSize: 8))
            .foregroundColor(UIColor.black)
            .make()

        let switcherTitle = "Moves enabled".attributed()
            .font(.systemFont(ofSize: 8))
            .foregroundColor(UIColor.black)
            .make()

        super.init { viewFactories -> YogaNode in
            let rootNode = YogaNode({ node in
                node.flexDirection = .row
                node.alignItems = .center
            })

            let sliderTitleNode = YogaTextNode({ node in
                node.width = 40
            }).labelFactory(&viewFactories, text: sliderTitle)

            let sliderNode = YogaNode({ node in
                node.marginLeft = 8
                node.height = 24
                node.width = 80
            }).viewFactory(&viewFactories, { (slider: UISlider, firstTime) in
                if firstTime {
                    slider.minimumValue = 0.05
                    slider.maximumValue = 2.0
                    slider.value = 0.5
                }

                slider.handle(.valueChanged, { [weak slider] in
                    guard let slider = slider else { return }

                    delayChanged(TimeInterval(slider.value))
                })
            })

            rootNode
                .add(sliderTitleNode)
                .add(sliderNode)

            if #available(iOS 11.0, *) {
                let swicherTitleNode = YogaTextNode({ node in
                    node.marginLeft = 40
                    node.width = 40
                }).labelFactory(&viewFactories, text: switcherTitle)

                let switcherNode = YogaNode({ node in
                    node.marginLeft = 8
                    node.width = 51
                    node.height = 32
                }).viewFactory(&viewFactories, { (switcher: UISwitch, firstTime) in
                    if firstTime {
                        switcher.setOn(true, animated: false)
                    }

                    switcher.handle(.valueChanged, { [weak switcher] in
                        guard let switcher = switcher else { return }

                        movesEnabledChanged(switcher.isOn)
                    })
                })

                rootNode
                    .add(swicherTitleNode)
                    .add(switcherNode)
            }

            return rootNode
        }
    }
}
