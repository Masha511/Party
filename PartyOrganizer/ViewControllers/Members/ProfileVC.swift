//
//  ProfileVC.swift
//  PartyOrganizer
//
//  Created by Masha on 2/9/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Call", style: .plain, target: self, action: #selector(call))
    }
    
    private var member: Member!
    func present(for member: Member)
    {
        self.member = member
    }
    
    @objc func call(_ sender: UIBarButtonItem)
    {
        guard let url = URL(string: "tel://" + member.cell) else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
