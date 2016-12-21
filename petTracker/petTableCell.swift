//
//  petTableCell.swift
//  petTracker
//
//  Created by Miriam Flores on 12/20/16.
//  Copyright © 2016 CSUMB. All rights reserved.
//

import UIKit

class petTableCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var type: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
