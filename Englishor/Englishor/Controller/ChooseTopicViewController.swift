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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topicLabel.text = ""
        rotateButton.isUserInteractionEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rotateButton.shadowHeight = 6
        rotateButton.cornerRadius = (rotateButton.frame.size.width - rotateButton.shadowHeight) / 2
    }
    
    func setup() {
        topicButton.delegate = self
        navigationView.setHiddenView(nextLv: true, title: false, back: true)
        navigationView.setTitle(title: "Choose topic")
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
        topicButton.transform = topicButton.transform.rotated(by: CGFloat.pi / 6 * 5)
        sender.isUserInteractionEnabled = false
        let random = Int.random(in: 0..<topics.count)
        self.rotateView(targetView: self.topicButton, count: 5, random: random)
    }
    
    private func rotateView(targetView: UIView, count: Double, random: Int) {
        UIView.animate(withDuration: 6 - count, delay: 0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat.pi)
        }) { [unowned self] finished in
            let remain = count - 0.5
            if remain > 3 {
                self.rotateView(targetView: targetView, count: remain, random: random)
            } else {
                self.finish(random: random)
            }
        }
    }
    
    func finish(random: Int) {
        if random < 4 {
            let duration: Double = random == 1 ? 3 : (random == 3 ? 5 : 4)
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { [unowned self] in
                self.topicButton.transform = self.topicButton.transform.rotated(by: CGFloat.pi / 3 * CGFloat(random))
            }, completion: { [unowned self] (_) in
                self.topicLabel.text = Topic(rawValue: random + 1)?.name
                Phase.shared.topic = Topic(rawValue: random + 1)
                self.pushToDifficulty()
            })
        } else {
            UIView.animate(withDuration: 4, delay: 0, options: .curveLinear, animations: { [unowned self] in
                self.topicButton.transform = self.topicButton.transform.rotated(by: CGFloat.pi)
            }) { [unowned self] (_) in
                let duration: Double = random == 4 ? 4 : 5
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                    self.topicButton.transform = self.topicButton.transform.rotated(by: CGFloat.pi / 3 * CGFloat(random - 3))
                }, completion: { [unowned self] (_) in
                    self.topicLabel.text = Topic(rawValue: random + 1)?.name
                    Phase.shared.topic = Topic(rawValue: random + 1)
                    self.pushToDifficulty()
                })
            }
        }
    }
    
    func pushToDifficulty() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) { [weak self] in
            guard let `self` = self else { return }
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseDifficultyViewController") as? ChooseDifficultyViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            self.topicButton.transform = CGAffineTransform.identity
        }
    }

}

extension ChooseTopicViewController: ButtonWheelDelegate {
    func didTapButtonWheelAtName(name : String) {
        let topicName = topics.map { $0.name }
        guard let index = topicName.firstIndex(of: name) else { return }
        self.topicLabel.text = name
        Phase.shared.topic = topics[index]
        pushToDifficulty()
    }
}
