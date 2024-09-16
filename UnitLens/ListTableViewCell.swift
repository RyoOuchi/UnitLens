//
//  ListTableViewCell.swift
//  UnitLens
//
//  Created by 大内亮 on 2024/09/15.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet var starPic: UIImageView!
    @IBOutlet var unitImage: UIImageView?
    @IBOutlet var originalUnit: UILabel!
    @IBOutlet var uniqueUnit: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(originalUnitValue: Double, originalUnitString: String, uniqueUnitValue: Double, uniqueUnitString: String, unitImage: UIImage, isMarked: Bool) {
        originalUnit.text = "\(originalUnitValue) \(originalUnitString)"
        uniqueUnit.text = "\(uniqueUnitValue) \(uniqueUnitString)"
        self.unitImage?.image = unitImage
        if isMarked {
            starPic.image = UIImage(systemName: "star.fill")
        } else {
            starPic.image = UIImage(systemName: "star")
        }
    }
}
