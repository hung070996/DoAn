//
//  MySlider.swift
//  Englishor
//
//  Created by Do Hung on 10/23/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit

class MySlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        
        //keeps original origin and width, changes height, you get the idea
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 5.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    
    //while we are here, why not change the image here as well? (bonus material)
    override func awakeFromNib() {
        let filePath = Bundle.main.path(forResource: "fire", ofType: "gif")
        let gifData = NSData(contentsOfFile: filePath ?? "") as Data?
        self.setThumbImage(UIImage.sd_animatedGIF(with: gifData), for: .normal)
        super.awakeFromNib()
    }
}
