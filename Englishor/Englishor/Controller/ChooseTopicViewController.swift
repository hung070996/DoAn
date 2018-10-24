//
//  ChooseTopicViewController.swift
//  Englishor
//
//  Created by Do Hung on 10/15/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import ButtonWheel

class ChooseTopicViewController: UIViewController {
    
    @IBOutlet weak var subviewTopic: UIView!
    @IBOutlet weak var navigationView: NavigationView!
    @IBOutlet weak var topicButton: ButtonWheel!
    
    var topics = [Topic.animal, .school, .food, .home, .sport, .color]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        navigationView.setHiddenView(nextLv: true, title: false, back: true)
        navigationView.setTitle(title: "Choose topic")
        topicButton.delegate = self
        var buttonPieces = [ButtonPiece]()
        for topic in topics {
            var buttonPiece = ButtonPiece(name: topic.name,
                                          color: topic.rawValue % 2 == 0 ? .red : .yellow,
                                          centerOffset: .zero)
            
            buttonPiece.setLabel(maxLabelWidth: 100,
                                 labelFont: globalFont,
                                 textColor: .black)
            buttonPiece.setImage(image: topic.icon,
                                 imageViewSize: CGSize(width: 50, height: 50),
                                 tintColor: .black)
            buttonPieces.append(buttonPiece)
        }
        topicButton.setupWith(buttonPieces: buttonPieces, middleRadius: .small)
        subviewTopic.layer.cornerRadius = subviewTopic.frame.size.width / 2
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

