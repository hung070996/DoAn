//
//  Lv2ViewController.swift
//  Englishor
//
//  Created by do.tien.hung on 10/17/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import SQLite

class Lv2ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var countdownView: CountdownView!
    
    private var timeCountdown: Double = 5
    private var questions = [QuestionLv2]()
    private var currentQuestion: QuestionLv2!
    private var totalPoint: Double = 0
    private var index = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellType: Lv2Cell.self)
        loadTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        countdownView.start(time: timeCountdown) { [unowned self] in
            if self.index < self.questions.count {
                self.pushToLv3()
            }
        }
    }
    
    func pushToLv3() {
        Phase.shared.pointLv2 = Int(totalPoint)
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Lv3ViewController") as? Lv3ViewController
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func loadTable() {
        
        let questionTable = Table("QuestionLv2")
        let id = Expression<Int>("id")
        let idTopic = Expression<Int>("idTopic")
        let question = Expression<String>("question")
        let a = Expression<String>("a")
        let b = Expression<String>("b")
        let c = Expression<String>("c")
        let d = Expression<String>("d")
        let answer = Expression<String>("answer")
        
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
        if index < self.questions.count {
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
