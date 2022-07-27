//
//  ItemTableViewCell.swift
//  Demo Design App
//
//  Created by Aadeez Shaikh on 27/07/22.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    public static let indentifier = "ItemTableViewCell"
    
    @IBOutlet weak var flagLabel: UILabel!
    
    @IBOutlet weak var countryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
