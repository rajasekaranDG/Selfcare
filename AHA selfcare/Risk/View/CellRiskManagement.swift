//
//  CellRiskManagement.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 15/06/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class CellRiskManagement: UITableViewCell {

    @IBOutlet weak var lableDot : UILabel!
    @IBOutlet weak var lableDate : UILabel!
    @IBOutlet weak var viewDate : UIView!
    @IBOutlet weak var viewMessage : UIView!
    @IBOutlet weak var lableMessage : UILabel!
    @IBOutlet weak var lableLine : UILabel!
    @IBOutlet weak var buttonMessage : UIButton!
    @IBOutlet weak var lableAHASay : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
