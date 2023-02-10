//
//  KelimeTableViewCell.swift
//  WordQuizSQLite
//
//  Created by Kadir Yılmaz on 28.01.2023.
//

import UIKit

class KelimeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ingilizceLabel: UILabel!
    
    @IBOutlet weak var turkceLabel: UILabel!
    
    @IBOutlet weak var cumleTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

