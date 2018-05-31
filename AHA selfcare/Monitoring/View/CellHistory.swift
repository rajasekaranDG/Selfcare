//
//  CellHistory.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 10/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class CellHistory: UITableViewCell {

    @IBOutlet weak var lableDot : UILabel!
    @IBOutlet weak var lableDate : UILabel!
    @IBOutlet weak var lableTime : UILabel!

    @IBOutlet weak var viewDate : UIView!
    @IBOutlet weak var viewMessage : UIView!
    @IBOutlet weak var lableMessage : UILabel!
    @IBOutlet weak var lableLine : UILabel!
    @IBOutlet weak var lableSport : UILabel!
    @IBOutlet weak var lableActivity : UILabel!
    @IBOutlet weak var lableLastMeal : UILabel!
    @IBOutlet weak var lableContext : UILabel!
    @IBOutlet weak var viewBP : UIView!
    @IBOutlet weak var lableBP : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
