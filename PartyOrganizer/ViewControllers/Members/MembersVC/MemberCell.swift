//
//  MemberCell.swift
//  PartyOrganizer
//
//  Created by Masha on 2/9/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class MemberCell: UITableViewCell
{
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var isMemberSelected = false
    {
        didSet
        {
            if isMemberSelected
            {
                self.accessoryType = .checkmark
            }
            else
            {
                self.accessoryType = .none
            }
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()

        self.profileImageView.layer.cornerRadius = self.bounds.height * 0.4
        self.profileImageView.layer.masksToBounds = true
    }
    
    private var forSelection = false
    func set(member: Member, forSelection: Bool)
    {
        self.forSelection = forSelection
        self.nameLbl.text = member.name
        member.loadImage { (image) in
            DispatchQueue.main.async
            {
                self.profileImageView.image = image
            }
        }
        
        if forSelection
        {
            self.accessoryType = .checkmark
        }
        else
        {
            self.accessoryType = .disclosureIndicator
        }
    } 
}
