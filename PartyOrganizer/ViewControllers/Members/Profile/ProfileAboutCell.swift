//
//  ProfileAboutCell.swift
//  PartyOrganizer
//
//  Created by Masha on 2/9/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class ProfileAboutCell: UICollectionViewCell
{
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    func set(text: String)
    {
        self.textView.text = text + text + text
    }
}
