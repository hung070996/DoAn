//
//  ChooseTopicViewController.swift
//  Englishor
//
//  Created by Do Hung on 10/15/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import ButtonWheel
import SwiftyButton
import CountdownLabel

class ChooseTopicViewController: UIViewController {
    
    @IBOutlet weak var topicLabel: LTMorphingLabel!
    @IBOutlet weak var rotateButton: PressableButton!
    @IBOutlet weak var subviewTopic: UIView!
    @IBOutlet weak var navigationView: NavigationView!
    @IBOutlet weak var topicButton: ButtonWheel!
    
    var topics = [Topic.animal, .color, .sport, .home, .food, .school]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        topicButton.transform = topicButton.transform.rotated(by: CGFloat.pi / 6 * 5)
        rotateButton.shadowHeight = 10
        rotateButton.cornerRadius = rotateButton.frame.size.width / 2
        navigationView.setHiddenView(nextLv: true, title: false, back: true)
        navigationView.setTitle(title: "Choose topic")
        topicButton.delegate = self
        var buttonPieces = [ButtonPiece]()
        for topic in topics {
            var buttonPiece = ButtonPiece(name: topic.name,
                                          color: topic.rawValue % 2 == 0 ? .red : .yellow,
                                          centerOffset: .zero)
            buttonPiece.setImage(image: topic.icon,
                                 imageViewSize: CGSize(width: 100, height: 100),
                                 tintColor: .black)
            buttonPieces.append(buttonPiece)
        }
        topicButton.setupWith(buttonPieces: buttonPieces, middleRadius: .small)
        subviewTopic.layer.cornerRadius = subviewTopic.frame.size.width / 2
    }
    
    @IBAction func clickRotate(_ sender: PressableButton) {
        let random = Int.random(in: 0..<topics.count)
        print("asasas \(random)")
        self.rotateView(targetView: self.topicButton, count: 5, random: random)
    }
    
    private func rotateView(targetView: UIView, count: Int, random: Int) {
        UIView.animate(withDuration: Double(6 - count), delay: 0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat.pi)
        }) { finished in
            let remain = count - 1
            if remain > 1 {
                self.rotateView(targetView: targetView, count: remain, random: random)
            } else {
                self.finish(random: random)
            }
        }
    }
    
    func finish(random: Int) {
        if random < 4 {
            UIView.animate(withDuration: 6, delay: 0, options: .curveLinear, animations: {
                self.topicButton.transform = self.topicButton.transform.rotated(by: CGFloat.pi / 3 * CGFloat(random))
            }, completion: { (_) in
                self.topicLabel.text = Topic(rawValue: random + 1)?.name
            })
        } else {
            UIView.animate(withDuration: 6, delay: 0, options: .curveLinear, animations: {
                self.topicButton.transform = self.topicButton.transform.rotated(by: CGFloat.pi)
            }) { (_) in
                UIView.animate(withDuration: 7, delay: 0, options: .curveLinear, animations: {
                    self.topicButton.transform = self.topicButton.transform.rotated(by: CGFloat.pi / 3 * CGFloat(random - 3))
                }, completion: { (_) in
                    self.topicLabel.text = Topic(rawValue: random + 1)?.name
                })
            }
        }
    }

}

extension ChooseTopicViewController: ButtonWheelDelegate {
    func didTapButtonWheelAtName(name: String) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseDifficultyViewController") as? ChooseDifficultyViewController
        for topic in topics {
            if topic.name == name {
                Phase.shared.topic = topic
            }
        }
        navigationController?.pushViewController(vc!, animated: true)
    }
}



