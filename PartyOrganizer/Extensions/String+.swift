//
//  String+.swift
//  PartyOrganizer
//
//  Created by Masha on 2/9/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import Foundation
import UIKit

extension String
{
    func getDate(withTime: Bool)-> Date?
    {
        let formatter = DateFormatter()
        if withTime
        {
            formatter.dateFormat = "dd.MM.yyyy HH:mm"
        }
        else
        {
            formatter.dateFormat = "dd.MM.yyyy"
        }
        return formatter.date(from: self)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}
