//
//  ProfileDetailCell.swift
//  PartyOrganizer
//
//  Created by Masha on 2/9/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class ProfileDetailCell: UICollectionViewCell
{
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var textLbl: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        infoLbl.adjustsFontSizeToFitWidth = true
    }
    
    func set(text: String, info: String)
    {
        self.textLbl.text = text
        self.infoLbl.text = info
    }
}
