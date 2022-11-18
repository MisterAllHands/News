//
//  TableViewCell.swift
//  News
//
//  Created by TTGMOTSF on 15/11/2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
}
