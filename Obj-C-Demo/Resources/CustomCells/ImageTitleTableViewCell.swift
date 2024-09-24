//
//  ImageTitleTableViewCell.swift
//  Obj-C-Demo
//
//  Created by ricolwang on 2024/9/16.
//

import UIKit

class ImageTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var theImageView: UIImageView!
    @IBOutlet weak var theTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
