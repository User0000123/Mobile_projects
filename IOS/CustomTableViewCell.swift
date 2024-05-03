//
//  CustomTableViewCell.swift
//  MP
//
//  Created by aleksej on 3/27/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var lBookTitle: UILabel!
    @IBOutlet weak var lBookAuthors: UILabel!
    @IBOutlet weak var lBookRating: UILabel!
    @IBOutlet weak var lBookPrice: UILabel!
    @IBOutlet weak var lBookPreview: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
