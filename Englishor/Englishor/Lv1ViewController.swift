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

class Lv1ViewController: UIViewController {
    
    @IBOutlet weak var countDownLabel: CountdownLabel!
    @IBOutlet weak var slider: UISlider!
    private var timeCountdown: Double = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let filePath = Bundle.main.path(forResource: "fire", ofType: "gif")
        let gifData = NSData(contentsOfFile: filePath ?? "") as Data?
        slider.setThumbImage(UIImage.sd_animatedGIF(with: gifData), for: .normal)
        countDownLabel.setCountDownTime(minutes: timeCountdown)
        countDownLabel.timeFormat = "ss"
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
