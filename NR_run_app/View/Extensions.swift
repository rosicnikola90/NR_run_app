//
//  Extensions.swift
//  NR_run_app
//
//  Created by MacBook on 3/6/21.
//  Copyright © 2021 MacBook. All rights reserved.
//

import UIKit


extension UIButton {
    
    open override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.height/5
    }
    
}
