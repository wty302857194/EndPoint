//
//  MyTableViewCell.swift
//  EndPoint
//
//  Created by wbb on 2021/1/15.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var contentLab: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
