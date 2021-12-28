//
//  PopularListCell.swift
//  Pomelo Test App
//
//  Created by Achyuth Bujjigadu  on 27/12/21.
//

import UIKit

public protocol Reuseable {
    static func reuseID() -> String
}

class PopularListCell: UITableViewCell {

    @IBOutlet var articleImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

extension PopularListCell: Reuseable {
    static func reuseID() -> String {
        return String(describing: self)
    }
}
