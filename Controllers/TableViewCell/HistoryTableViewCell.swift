//
//  HistoryTableViewCell.swift
//  SightScapeVendor
//
//  Created by Hunain on 12/06/2023.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewContainer: CustomView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
