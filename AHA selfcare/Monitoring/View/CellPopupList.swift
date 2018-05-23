//
//  CellPopupList.swift
//  Harbour
//
//  Created by SivaChandran on 10/01/17.
//  Copyright © 2017 Sivachandiran. All rights reserved.
//

import UIKit

class CellPopupList: UITableViewCell {

    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var BtnSelect : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
