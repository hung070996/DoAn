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
    @IBOutlet weak var nextQuestionButton: PressableButton!
    
    private var timeCountdown: Double = Phase.shared.difficulty.timeOfLevel.lv3
    private var questions = [QuestionLv3]()
    private var currentQuestion: QuestionLv3!
    private var totalPoint: Double = 0
    private var index = -1
    private var isPushed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        Utils.shared.setupPressableButton(color: nil, shadow: nil, button: submitButton)
        Utils.shared.setupPressableButton(color: nil, shadow: nil, button: nextQuestionButton)
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
    
    func getSynonymsById(idQuestion: Int) -> [Synonym] {
        var synonyms = [Synonym]()
        let table = Table("Synonym")
        let id = Expression<Int>("id")
        let original = Expression<String>("original")
        let synonym = Expression<String>("synonym")
        let idQuestionLv3 = Expression<Int>("idQuestionLv3")
        do {
            let filter = table.filter(idQuestionLv3 == idQuestion)
            for row in try DatabaseManager.shared.connection!.prepare(filter) {
                let result = Synonym(id: row[id],
                                     original: row[original],
                                     synonym: row[synonym],
                                     idQuestionLv3: row[idQuestionLv3])
                synonyms.append(result)
            }
        } catch {
            
        }
        return synonyms
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
                let aQuestion = QuestionLv3(id: q[id],
                                            question: q[question],
                                            answer: q[answer],
                                            idTopic: q[idTopic],
                                            synonyms: getSynonymsById(idQuestion: q[id]))
                questions.append(aQuestion)
            }
            questions = Utils.shared.getRandom(in: questions, quantity: Phase.shared.difficulty?.numberOfQuestion ?? 0)
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
        if Utils.shared.compare(standardAnswer(answer: answerTextview.text, question: currentQuestion), currentQuestion.answer) {
            totalPoint += 100 / Double(questions.count)
            Utils.shared.playSound(correct: true)
            nextQuestion()
        } else {
            Utils.shared.playSound(correct: false)
            answerTextview.shakeView()
        }
    }
    
    func standardAnswer(answer: String, question: QuestionLv3) -> String {
        var temp = answer.lowercased()
        for item in question.synonyms {
            if temp.contains(item.synonym) {
                temp = temp.replacingOccurrences(of: item.synonym, with: item.original)
            }
        }
        return temp
    }
    
    @IBAction func clickNextQuestion(_ sender: Any) {
        nextQuestion()
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
