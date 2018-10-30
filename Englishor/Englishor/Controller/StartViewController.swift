//
//  StartViewController.swift
//  Englishor
//
//  Created by Do Hung on 10/16/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Floaty
import SwiftyButton

class StartViewController: UIViewController {

    @IBOutlet weak var floaty: Floaty!
    @IBOutlet weak var readyButton: PressableButton!
    @IBOutlet weak var tutorialImageView: UIImageView!
    @IBOutlet weak var tutorialLabel: UILabel!
    
    let tutorialArray = ["Level 1. You will have time to learn new words, you can click the loud to hear the pronounciation and see the meaning of words. After that, you must speak and input the meaning of the words.", "Level 2. You will choose the best anwer which is the best meaning of the sentence.", "Lv3. You have to input the English sentence.", "Lv4. You will talk with bot. You will ask, bot will answer.", "Lv5. You will talk with bot. Bot will ask, you will answer."]
    var index = 0
    var blurEffectView = UIVisualEffectView()
    var panGesture = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        view.addGestureRecognizer(panGesture)
        setupPressableButton(color: .green, shadow: .lightGray, button: readyButton)
        configFloaty()
    }
    
    func configFloaty() {
        floaty.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        floaty.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        floaty.layer.shadowOpacity = 1.0
        floaty.layer.shadowRadius = 1.0
        floaty.layer.masksToBounds = false
        floaty.fabDelegate = self
        FloatyManager.defaultInstance().font = globalFont
        
        floaty.addItem("Change topic",
                       icon: Phase.shared.topic?.iconStraight,
                       titlePosition: .right,
                       handler: { [unowned self] item in
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: ChooseTopicViewController.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                        self.floaty.close()
        })
        floaty.addItem("Change difficulty",
                       icon: Phase.shared.difficulty.image,
                       titlePosition: .right,
                       handler: { [unowned self] item in
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: ChooseDifficultyViewController.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                        self.floaty.close()
        })
        floaty.addItem("Analytics",
                       icon: UIImage(named: "analytic")!,
                       titlePosition: .right,
                       handler: { [unowned self] item in
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChartViewController") as? ChartViewController
                        self.navigationController?.pushViewController(vc!, animated: true)
                        self.floaty.close()
        })
    }
    
    @objc func handlePanGesture(panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: view)
        if panGesture.state == .ended {
            if translation.y < 0 && index < tutorialArray.count - 1 {
                UIView.transition(with: tutorialImageView, duration: 0.5, options: [UIView.AnimationOptions.transitionCurlUp], animations: { [unowned self] in
                    self.view.removeGestureRecognizer(panGesture)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) { [unowned self] in
                        self.index += 1
                        self.tutorialLabel.text = self.tutorialArray[self.index]
                    }
                }, completion: { [unowned self] _ in
                    self.view.addGestureRecognizer(panGesture)
                })
            }
            if translation.y > 0 && index > 0 {
                UIView.transition(with: tutorialImageView, duration: 0.5, options: [UIView.AnimationOptions.transitionCurlDown], animations: { [unowned self] in
                    self.view.removeGestureRecognizer(panGesture)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) { [unowned self] in
                        self.index -= 1
                        self.tutorialLabel.text = self.tutorialArray[self.index]
                    }
                }, completion: { [unowned self] _ in
                    self.view.addGestureRecognizer(panGesture)
                })
            }
        }
        
    }
    
    func addBlur() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        view.bringSubviewToFront(floaty)
    }
    
    func removeBlur() {
        blurEffectView.removeFromSuperview()
    }
    
    @IBAction func clickReady(_ sender: PressableButton) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) { [weak self] in
            guard let `self` = self else { return }
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Lv1ViewController") as? Lv1ViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

extension StartViewController: FloatyDelegate {
    func floatyWillOpen(_ floaty: Floaty) {
        addBlur()
    }
    
    func floatyWillClose(_ floaty: Floaty) {
        removeBlur()
    }
}
