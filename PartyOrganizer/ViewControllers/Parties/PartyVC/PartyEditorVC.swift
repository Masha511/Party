//
//  PartyEditorVC.swift
//  PartyOrganizer
//
//  Created by Masha on 2/8/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class PartyEditorVC: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var contentBottom_c: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        descriptionTextView.delegate = self
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: -TextView Delegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        let toolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done))]
        toolbar.sizeToFit()
        textView.inputAccessoryView = toolbar
        
        return true
    }
    
    @objc func done(_ sender : UIBarButtonItem)
    {
        descriptionTextView.resignFirstResponder()
    }

    //MARK: -Keyboard Frame
    @objc func keyboardWillShow(_ notification: Notification)
    {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            self.contentBottom_c.constant = keyboardFrame.height - self.view.safeAreaInsets.bottom
            UIView.animate(withDuration: 0.2)
            {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification)
    {
        self.contentBottom_c.constant = 0.0
        UIView.animate(withDuration: 0.2)
        {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: -TableViewDelegate
    var areMembersVisible = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3 + (areMembersVisible ? 0 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var reuseID = ""
        if indexPath.row == 0
        {
            reuseID = "PartyNameCell"
        }
        else if indexPath.row == 1
        {
            reuseID = "PartyDateCell"
        }
        else if indexPath.row == 2
        {
            reuseID = "PartyMembersCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID) as! PartyDetailCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return indexPath.row > 2
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            
        }
    }
    
    //MARK: -Actions
    
    private func createParty()-> Party
    {
        let party = Party(name: "Party\(User.shared.parties.count)", description: "Malo duzi opis", date: Date())
        return party
    }
    
    @IBAction func saveParty(_ sender: Any)
    {
        let party = self.createParty()
        if let index = User.shared.currentPartyIndex
        {
            User.shared.parties[index] = party
        }
        else
        {
            User.shared.parties.append(party)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
