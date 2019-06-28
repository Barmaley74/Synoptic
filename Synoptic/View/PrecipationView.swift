//
//  PrecipationView.swift
//  Synoptic
//
//  Created by Serhiy Vlasevych on 05.08.2018.
//  Copyright © 2018 Neo. All rights reserved.
//

import UIKit

class PrecipationView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var snowLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewInit()
    }
    
    func viewInit() {
        Bundle.main.loadNibNamed("PrecipationView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
