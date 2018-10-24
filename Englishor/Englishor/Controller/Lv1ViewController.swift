//
//  Lv1ViewController.swift
//  Englishor
//
//  Created by do.tien.hung on 10/17/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import SDWebImage
import SQLite
import AVFoundation
import AMPopTip

class Lv1ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countdownView: CountdownView!
    
    private var timeCountdown: Double = Phase.shared.difficulty.timeOfLevel.lv1
    private var words = [Word]()
    private var speechSynthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let filePath = Bundle.main.path(forResource: "burn", ofType: "gif")
//        let gifData = NSData(contentsOfFile: filePath ?? "") as Data?
//        slider.setThumbImage(UIImage.sd_animatedGIF(with: gifData), for: .normal)
//        slider.setThumbImage(UIImage(named: "fire"), for: .normal)
//        slider.trackRect(forBounds: CGRect(x: 0, y: -100, width: 300, height: 300))
        
        tableView.register(cellType: Lv1Cell.self)
        loadTable()
        
    }
    
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
    }
    
    func loadTable() {
        do {
            let wordTable = Table("Word")
            let id = Expression<Int>("id")
            let idTopic = Expression<Int>("idTopic")
            let word = Expression<String>("word")
            let meaning = Expression<String>("meaning")
            
            let filter = wordTable.filter(idTopic == Phase.shared.topic?.rawValue ?? 0)
            for w in try DatabaseManager.shared.connection!.prepare(filter) {
                let aWord = Word(id: Int(w[id]), word: w[word], meaning: w[meaning])
                words.append(aWord)
            }
            words = getRandom(in: words, quantity: Phase.shared.difficulty?.numberOfQuestion ?? 0)
            tableView.reloadData()
        } catch {
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        countdownView.start(time: timeCountdown) { [unowned self] in
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AnswerLv1ViewController") as? AnswerLv1ViewController
            vc!.words = self.words
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

extension Lv1ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Lv1Cell = tableView.dequeueReusableCell(for: indexPath)
        cell.label.text = words[indexPath.row].word
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension Lv1ViewController: Lv1CellDelegate {
    func clickLoud(cell: Lv1Cell, frameButton: CGRect) {
        guard let index = tableView.indexPath(for: cell) else {
            return
        }
        speechAndText(text: words[index.row].word)
        let popTip = PopTip()
        popTip.shouldDismissOnTap = true
        popTip.font = UIFont(name: "Chalkboard SE", size: 20)!
        popTip.show(text: words[index.row].meaning, direction: .left, maxWidth: 200, in: cell.contentView, from: frameButton, duration: 3)
    }
}
