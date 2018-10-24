//
//  Lv4ViewController.swift
//  Englishor
//
//  Created by do.tien.hung on 10/22/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit

class Lv4ViewController: UIViewController {
    @IBOutlet weak var countdownView: CountdownView!
    private var timeCountdown: Double = Phase.shared.difficulty.timeOfConversation
    private var totalPoint: Double = 70
    
    var a = ["asd", "asdsdasdnbasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd", "asd", "asdsdasdnbasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd","asd", "asdsdasdnbasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd", "asd", "asdsdasdnbasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd", "asd", "asdsdasdnbasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd","asd", "asdsdasdnbasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd", "asd", "asdsdasdnbasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd", "asd", "asdsdasdnbasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd","asd", "asdsdasdnbasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd"]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellType: LeftChatCell.self)
        tableView.register(cellType: RightChatCell.self)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        countdownView.start(time: timeCountdown) { [unowned self] in
            self.pushToLv5()
        }
    }

    func pushToLv5() {
        Phase.shared.pointLv4 = Int(totalPoint)
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Lv5ViewController") as? Lv5ViewController
        navigationController?.pushViewController(vc!, animated: true)
    }
}

extension Lv4ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return a.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell: LeftChatCell = tableView.dequeueReusableCell(for: indexPath)
            cell.avatar.image = UIImage(named: "microphone")
            cell.label.text = a[indexPath.row]
            return cell
        } else {
            let cell: RightChatCell = tableView.dequeueReusableCell(for: indexPath)
            cell.avatar.image = UIImage(named: "micro")
            cell.label.text = a[indexPath.row]
            return cell
        }
        
    }
}
