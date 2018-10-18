//
//  Lv1ViewController.swift
//  Englishor
//
//  Created by do.tien.hung on 10/17/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import CountdownLabel
import SDWebImage
import SQLite

class Lv1ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countDownLabel: CountdownLabel!
    @IBOutlet weak var slider: UISlider!
    
    private var timeCountdown: Double = 30
    var words = [Word]()
    var wordTable: Table!
    var db : Connection!
    var id, idTopic : Expression<Int>!
    var word, meaning : Expression<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
//        let filePath = Bundle.main.path(forResource: "fire", ofType: "gif")
//        let gifData = NSData(contentsOfFile: filePath ?? "") as Data?
//        slider.setThumbImage(UIImage.sd_animatedGIF(with: gifData), for: .normal)
        countDownLabel.setCountDownTime(minutes: timeCountdown)
        countDownLabel.timeFormat = "ss"
        tableView.register(cellType: Lv1Cell.self)
        loadTable()
    }
    
    func getData() {
        do {
            db = try Connection("/Users/do.tien.hung/Desktop/DoAn/DoAn/Englishor/Englishor/Supporting/DoAnDB.db")
            wordTable = Table("Word")
            id = Expression<Int>("id")
            idTopic = Expression<Int>("idTopic")
            word = Expression<String>("word")
            meaning = Expression<String>("meaning")
        } catch {
            
        }
    }
    
    func loadTable() {
        do {
            words = [Word]()
            let filter = wordTable.filter(idTopic == Phase.shared.topic?.rawValue ?? 0)
            for w in try db.prepare(filter) {
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
        countDownLabel.start()
        UIView.animate(withDuration: timeCountdown, animations: { [weak self] in
            guard let `self` = self else { return }
            self.slider.setValue(0, animated: true)
        }) { _ in
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Lv2ViewController") as? Lv2ViewController
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
