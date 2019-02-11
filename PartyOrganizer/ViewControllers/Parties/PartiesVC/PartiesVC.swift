//
//  PartiesVC.swift
//  PartyOrganizer
//
//  Created by Masha on 2/8/19.
//  Copyright © 2019 Maša Zlatković. All rights reserved.
//

import UIKit

class PartiesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate
{
    @IBOutlet weak var partiesTableView: UITableView!
    @IBOutlet weak var createBtn: UIButton!
    
    private var resultIndexes: [Int]
    {
        if self.searchedText == nil || searchedText!.isEmpty
        {
            var indexes = [Int]()
            indexes += 0..<User.shared.parties.count
            return indexes
        }
        else
        {
            return User.shared.parties.enumerated().compactMap({ (pair) -> Int? in
                if pair.element.name.lowercased().contains(searchedText!.lowercased())
                {
                    return pair.offset
                }
                return nil
            })
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        createBtn.layer.cornerRadius = 10.0
        
        let backBarButton = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        refreshView()
    }
    
    func refreshView()
    {
        if User.shared.parties.count == 0
        {
            self.hideSearchBar()
            self.hideTableView()
        }
        else
        {
            self.showTableView()
        }
    }
    
    private func hideTableView()
    {
        partiesTableView.isHidden = true
        self.navigationItem.leftBarButtonItem = nil
    }
    
    private func showTableView()
    {
        partiesTableView.isHidden = false
        self.partiesTableView.reloadData()
        let searchItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar(_:)))
        self.navigationItem.leftBarButtonItem = searchItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let partyEditorVC = segue.destination as? PartyEditorVC
        {
            if let sender = sender as? PartyCell
            {
                if let cellIndex = self.partiesTableView.indexPath(for: sender)?.row
                {
                    partyEditorVC.present(forParty: resultIndexes[cellIndex])
                }
            }
            else
            {
                partyEditorVC.present(forParty: nil)
            }
        }
    }
    
    //MARK: -Keyboard Frame
    @objc func keyboardWillShow(_ notification: Notification)
    {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            
            self.partiesTableView.contentInset.bottom = keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification)
    {
        self.partiesTableView.contentInset.bottom = 0.0
    }
    
    //MARK: -Table View Data Source & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return resultIndexes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PartyCell") as! PartyCell
        cell.set(party: User.shared.parties[resultIndexes[indexPath.row]])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "PartyEditorSegue", sender: tableView.cellForRow(at: indexPath))
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            User.shared.parties.remove(at: resultIndexes[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            if User.shared.parties.isEmpty
            {
                self.hideTableView()
                self.hideSearchBar()
            }
        }
    }
    
    //MARK: -Search
    @IBOutlet weak var seacrhHeight_c: NSLayoutConstraint!
    @objc func showSearchBar(_ sender: Any)
    {
        if self.navigationItem.titleView == nil
        {
            showSearchBar()
        }
    }
    
    private var searchedText: String?
    {
        didSet
        {
            self.partiesTableView.reloadData()
        }
    }
    
    private func showSearchBar()
    {
        searchedText = nil
        hideNavigationButtons()
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        self.navigationItem.titleView = searchBar
        
        searchBar.becomeFirstResponder()

    }
    
    private func hideNavigationButtons()
    {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
    }
    
    @objc private func hideSearchBar()
    {
        searchedText = nil
        self.navigationItem.titleView = nil
        showNavigationButtons()
    }
    
    private func showNavigationButtons()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addParty(_:)))
        if !User.shared.parties.isEmpty
        {
            let searchItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar(_:)))
            self.navigationItem.leftBarButtonItem = searchItem
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.searchedText = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        hideSearchBar()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
    }
    
    //MARK: -Actions
    @IBAction func addParty(_ sender: Any)
    {
        self.performSegue(withIdentifier: "PartyEditorSegue", sender: nil)
    }
}
