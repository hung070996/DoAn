//
//  Lv3ViewController.swift
//  Englishor
//
//  Created by do.tien.hung on 10/19/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import SwiftyButton
import SQLite

class Lv3ViewController: UIViewController {
    @IBOutlet weak var navigationView: NavigationView!
    @IBOutlet weak var countdownView: CountdownView!
    @IBOutlet weak var submitButton: PressableButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTextview: UITextView!
    
    private var timeCountdown: Double = Phase.shared.difficulty.timeOfLevel.lv3
    private var questions = [QuestionLv3]()
    private var currentQuestion: QuestionLv3!
    private var totalPoint: Double = 0
    private var index = -1
    private var isPushed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupPressableButton(color: nil, shadow: nil, button: submitButton)
        answerTextview.layer.borderWidth = 0.5
        answerTextview.layer.borderColor = UIColor.gray.cgColor
        navigationView.setHiddenView(nextLv: false, title: false, back: true)
        navigationView.setTitle(title: "Lv3")
        navigationView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        countdownView.start(time: timeCountdown) { [unowned self] in
            if self.index < self.questions.count {
                self.pushToLv4()
            }
        }
    }
    
    func loadData() {
        
        let questionTable = Table("QuestionLv3")
        let id = Expression<Int>("id")
        let idTopic = Expression<Int>("idTopic")
        let question = Expression<String>("question")
        let answer = Expression<String>("answer")
        
        do {
            let filter = questionTable.filter(idTopic == Phase.shared.topic?.rawValue ?? 0)
            for q in try DatabaseManager.shared.connection!.prepare(filter) {
                let aQuestion = QuestionLv3(id: Int(q[id]),
                                            question: q[question],
                                            answer: q[answer],
                                            idTopic: Int(q[idTopic]))
                questions.append(aQuestion)
            }
            questions = getRandom(in: questions, quantity: Phase.shared.difficulty?.numberOfQuestion ?? 0)
        } catch {
            
        }
        nextQuestion()
    }
    
    func nextQuestion() {
        index += 1
        if index < self.questions.count {
            currentQuestion = questions[index]
            questionLabel.text = currentQuestion.question
            answerTextview.text = ""
        } else {
            pushToLv4()
        }
    }
    
    func pushToLv4() {
        if !isPushed {
            Phase.shared.pointLv3 = Int(totalPoint)
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Lv4ViewController") as? Lv4ViewController
            navigationController?.pushViewController(vc!, animated: true)
            isPushed = true
        }
    }
    
    @IBAction func clickSubmit(_ sender: PressableButton) {
        if compare(answerTextview.text, currentQuestion.answer) {
            totalPoint += 100 / Double(questions.count)
            nextQuestion()
        } else {
            answerTextview.shakeView()
        }
    }
}

extension Lv3ViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            view.endEditing(true)
        }
        return true
    }
}

extension Lv3ViewController: NavigationViewDelegate {
    func clickNext() {
        pushToLv4()
    }
}

extension UIView {
    func shakeView() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
