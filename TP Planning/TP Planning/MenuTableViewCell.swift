//
//  MenuTableViewCell.swift
//  TownPlanning
//
//  Created by Vinit Ingale on 12/25/20.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView?
    @IBOutlet weak var menuNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setUpCell(image: UIImage?, name: String) {
        iconImageView?.image = image
        menuNameLabel.text = name
    }
}
