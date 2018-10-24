//
//  Lv5ViewController.swift
//  Englishor
//
//  Created by do.tien.hung on 10/23/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit

class Lv5ViewController: UIViewController {

    @IBOutlet weak var countdownView: CountdownView!
    private var timeCountdown: Double = Phase.shared.difficulty.timeOfConversation
    private var totalPoint: Double = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        countdownView.start(time: timeCountdown) { [unowned self] in
            self.pushToResult()
        }
    }
    
    func pushToResult() {
        Phase.shared.pointLv5 = Int(totalPoint)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let date = formatter.string(from: Date())
        Phase.shared.date = date
        var data = getDataAnalytic()
        if data.last?.date != date {
            data.append(Phase.shared)
        }
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: data)
        UserDefaults.standard.set(encodedData, forKey: "data")
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController
        navigationController?.pushViewController(vc!, animated: true)
    }
}
