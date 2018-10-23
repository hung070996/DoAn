//
//  CountdownView.swift
//  Englishor
//
//  Created by Do Hung on 10/20/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable
import CountdownLabel

class CountdownView: UIView, NibOwnerLoadable {
    
    @IBOutlet weak var label: CountdownLabel!
    @IBOutlet weak var slider: UISlider!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
        label.timeFormat = "ss"
        label.animationType = .Burn
        let filePath = Bundle.main.path(forResource: "fire", ofType: "gif")
        let gifData = NSData(contentsOfFile: filePath ?? "") as Data?
        slider.setThumbImage(UIImage.sd_animatedGIF(with: gifData), for: .normal)
    }
    
    func start(time: Double, complete: @escaping () -> ()) {
        label.timeFormat = time < 60 ? "ss" : "mm:ss"
        label.setCountDownTime(minutes: time)
        label.start()
        UIView.animate(withDuration: time, delay: 0, options: .curveLinear, animations: { [weak self] in
            guard let `self` = self else { return }
            self.slider.setValue(0, animated: true)
        }) { _ in
            complete()
        }
    }
}
