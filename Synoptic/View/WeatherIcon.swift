//
//  WeatherIcon.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 05.08.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import UIKit

class WeatherIcon: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var iconView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInit()
    }
    
    func viewInit() {
        Bundle.main.loadNibNamed("WeatherIcon", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
