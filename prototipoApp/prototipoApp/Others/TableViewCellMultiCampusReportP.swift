//
//  TableViewCellMultiCampusReportP.swift
//  prototipoApp
//
//  Created by Alumno on 19/11/21.
//

import UIKit

class TableViewCellMultiCampusReportP: UITableViewCell {

    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 3, left: 0, bottom: 3, right: 0))
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
