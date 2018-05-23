//
//  CellAssessment.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 09/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class CellAssessment: UITableViewCell {

    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var imageIcon : UIImageView!
    @IBOutlet weak var buttonSelect : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
