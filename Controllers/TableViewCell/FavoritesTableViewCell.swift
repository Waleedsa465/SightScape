//
//  FavoritesTableViewCell.swift
//  SightScapUser
//
//  Created by Hunain on 16/06/2023.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgExc: UIImageView!
    @IBOutlet weak var lblRegularTitle: UILabel!
    @IBOutlet weak var lblBoldtitle: UILabel!
    @IBOutlet weak var viewSponcered: UIView!
    @IBOutlet weak var viewPremium: UIView!
    @IBOutlet weak var viewGroupActivity: CustomView!
    @IBOutlet weak var viewBookingReq: CustomView!
    //@IBOutlet weak var constraintStackWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintPremiumTop: NSLayoutConstraint!
    @IBOutlet weak var constraintBookingTrailing: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
