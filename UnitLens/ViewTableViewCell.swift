//
//  ViewTableViewCell.swift
//  UnitLens
//
//  Created by 大内亮 on 2024/09/15.
//

import UIKit

class ViewTableViewCell: UITableViewCell {
    
    @IBOutlet var numLabel: UILabel!
    @IBOutlet var unitImage: UIImageView?
    @IBOutlet var unitLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell (amount: Double, unitImage: UIImage, unitName: String) {
        numLabel.text = String(amount)
        self.unitImage?.image = unitImage
        unitLabel.text = unitName
    }
    
}
