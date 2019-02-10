//
//  ProfileVC.swift
//  PartyOrganizer
//
//  Created by Masha on 2/9/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class ProfileVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, ProfileFooterDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Call", style: .plain, target: self, action: #selector(call))
        self.navigationItem.title = "Profile"
        
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButton
    }
    
    private var member: Member!
    func present(for member: Member)
    {
        self.member = member
    }
    
    @objc func call(_ sender: UIBarButtonItem)
    {
        let phoneNumber = member.cell.compactMap { (digit) -> Character? in
            switch digit
            {
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                return digit
            default:
                return nil
            }
        }
        guard let url = URL(string: "tel://" + phoneNumber) else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let addToPartyVC = segue.destination as? AddToPartyVC
        {
            addToPartyVC.present(for: self.member)
        }
    }
    
    //MARK: -Collection View
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        switch indexPath.item
        {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileImageCell", for: indexPath) as! ProfileImageCell
            member.loadImage { (image) in
                DispatchQueue.main.async
                {
                    cell.set(image: image)
                }
            }
            return cell
        case 1, 2, 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileDetailCell", for: indexPath) as! ProfileDetailCell
            if indexPath.item == 1
            {
                cell.set(text: "Full name:", info: member.name)
            }
            else if indexPath.item == 2
            {
                cell.set(text: "Gender:", info: member.gender)
            }
            else
            {
                cell.set(text: "email:", info: member.email)
            }
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileAboutCell", for: indexPath) as! ProfileAboutCell
            cell.set(text: member.aboutMe)
            return cell
        default:
            return UICollectionViewCell() //not going to be called
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        switch indexPath.item
        {
        case 0:
            return CGSize(width: collectionView.frame.width, height: 200.0)
        case 1, 2, 3:
            return CGSize(width: collectionView.frame.width, height: 30.0)
        case 4:
            let proposedTextHeight = member.aboutMe.height(withConstrainedWidth: collectionView.frame.width, font: UIFont(name: "SFProText-Regular", size: 13.0)!)
            return CGSize(width: collectionView.frame.width, height: proposedTextHeight + 30.0)
        default:
            return .zero //not going to be called
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileFooterView", for: indexPath) as! ProfileFooterView
        footerView.delegate = self
        return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        return CGSize(width: collectionView.frame.width, height: 50.0)
    }
    
    //MARK: -Footer Delegate
    
    func addToParty()
    {
        if User.shared.parties.count == 0
        {
            let alert = UIAlertController(title: "No parties", message: "There are no available parties. Do you wish to create one?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                //TODO: show party editor
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.performSegue(withIdentifier: "AddToPartySegue", sender: nil)
    }
}
