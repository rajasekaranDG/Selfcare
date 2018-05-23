//
//  CellMonitoring.swift
//  AHA selfcare
//
//  Created by Sivachandiran on 10/05/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class CellMonitoring: UITableViewCell {

    @IBOutlet var ViewInner: [UIView]!
    @IBOutlet var IconImage: [UIImageView]!
    @IBOutlet var lblName: [UILabel]!
    @IBOutlet var BtnSelect: [UIButton]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
