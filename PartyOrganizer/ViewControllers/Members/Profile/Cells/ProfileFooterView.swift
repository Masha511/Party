//
//  ProfileFooterView.swift
//  PartyOrganizer
//
//  Created by Masha on 2/9/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class ProfileFooterView: UICollectionReusableView
{
    @IBOutlet weak var addBtn: UIButton!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        addBtn.layer.cornerRadius = 10.0
        addBtn.layer.masksToBounds = true
    }
    
    @IBAction func addToParty(_ sender: UIButton)
    {
        print("Touched")
    }
}
