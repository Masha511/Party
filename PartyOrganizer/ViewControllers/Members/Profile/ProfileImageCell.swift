//
//  ProfileImageCell.swift
//  PartyOrganizer
//
//  Created by Masha on 2/9/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class ProfileImageCell: UICollectionViewCell
{
    @IBOutlet weak var imageView: UIImageView!
    func set(image: UIImage?)
    {
        self.imageView.image = image
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.imageView.layer.masksToBounds = true
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.imageView.layer.cornerRadius = self.imageView.bounds.width * 0.5
    }
}
