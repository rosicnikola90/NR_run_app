//
//  NRTableViewCell.swift
//  NR_run_app
//
//  Created by MacBook on 3/6/21.
//  Copyright © 2021 MacBook. All rights reserved.
//

import UIKit

class NRTableViewCell: UITableViewCell {
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var avrPaceLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    
}
