//
//  Lv2ViewController.swift
//  Englishor
//
//  Created by do.tien.hung on 10/17/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import CountdownLabel
import SQLite

class Lv2ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var countDownLabel: CountdownLabel!
    @IBOutlet weak var slider: UISlider!
    
    private var timeCountdown: Double = 30
    var questions = [QuestionLv2]()
    var currentQuestion: QuestionLv2!
    var questionTable: Table!
    var db : Connection!
    var id, idTopic : Expression<Int>!
    var question, a, b, c, d, answer : Expression<String>!
    var totalPoint: Double = 0
    var index = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        tableView.register(cellType: Lv2Cell.self)
        loadTable()
        countDownLabel.setCountDownTime(minutes: timeCountdown)
        countDownLabel.timeFormat = "ss"
        countDownLabel.animationType = .Burn
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        countDownLabel.start()
        UIView.animate(withDuration: timeCountdown, animations: { [weak self] in
            guard let `self` = self else { return }
            self.slider.setValue(0, animated: true)
        }) { _ in
            if self.index < Phase.shared.difficulty?.numberOfQuestion ?? 0 {
                self.pushToLv3()
            }
        }
    }
    
    func pushToLv3() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Lv3ViewController") as? Lv3ViewController
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getData() {
        questionTable = Table("QuestionLv2")
        id = Expression<Int>("id")
        idTopic = Expression<Int>("idTopic")
        question = Expression<String>("question")
        a = Expression<String>("a")
        b = Expression<String>("b")
        c = Expression<String>("c")
        d = Expression<String>("d")
        answer = Expression<String>("answer")
    }
    
    func loadTable() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        do {
            let filter = questionTable.filter(idTopic == Phase.shared.topic?.rawValue ?? 0)
            for q in try DatabaseManager.shared.connection!.prepare(filter) {
                let aQuestion = QuestionLv2(id: Int(q[id]),
                                            question: q[question],
                                            a: q[a], b: q[b], c: q[c], d: q[d],
                                            answer: q[answer],
                                            idTopic: Int(q[idTopic]))
                questions.append(aQuestion)
            }
            questions = getRandom(in: questions, quantity: Phase.shared.difficulty?.numberOfQuestion ?? 0)
            tableView.reloadData()
        } catch {
            
        }
        nextQuestion()
    }
    
    func nextQuestion() {
        index += 1
        if index < Phase.shared.difficulty?.numberOfQuestion ?? 0 {
            currentQuestion = questions[index]
            questionLabel.text = currentQuestion.question
            tableView.reloadData()
        } else {
            pushToLv3()
        }
    }
}

extension Lv2ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Lv2Cell = tableView.dequeueReusableCell(for: indexPath)
        switch indexPath.row {
        case 0:
            cell.label.text = "A. " + currentQuestion.a
        case 1:
            cell.label.text = "B. " + currentQuestion.b
        case 2:
            cell.label.text = "C. " + currentQuestion.c
        case 3:
            cell.label.text = "D. " + currentQuestion.d
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentQuestion.answer.toIndexAnswer() == indexPath.row {
            totalPoint += 100 / Double(Phase.shared.difficulty?.numberOfQuestion ?? 0)
        }
        print(totalPoint)
        nextQuestion()
        
    }
}

extension String {
    func toIndexAnswer() -> Int {
        switch self {
        case "a":
            return 0
        case "b":
            return 1
        case "c":
            return 2
        case "d":
            return 3
        default:
            return -1
        }
    }
}
