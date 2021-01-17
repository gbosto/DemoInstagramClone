//
//  NewMessageController.swift
//  InstaClone
//
//  Created by Giorgi on 1/15/21.
//

import UIKit

protocol NewMessageControllerDelegate: class {
    func controller(_ controller: NewMessageController, wantsToChatWith user: User)
}

class NewMessageController: UITableViewController {
    
    //MARK: - Properties
    
    private let cellId = "NewMessageCell"

    private var suggestedUsers = [User]()
    private var users = [User]()
    private var filteredUsers = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    weak var delegate: NewMessageControllerDelegate?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUsers()
        fetchSuggestedUsers()
        
    }
    
    //MARK: - API
    
    func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
            users.forEach { (user) in
                print(user.username)
            }
            self.tableView.reloadData()
        }
    }
    
    func fetchSuggestedUsers() {
        UserService.fetchCurrentUser { currentUser  in
            UserService.fetchFollowing(forUid: currentUser.uid) { followings in
                self.suggestedUsers = followings
                self.tableView.reloadData()
            }
        }
    }
    
    
    //MARK: - Helper Methods

    func configureUI() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "New Message"
        let image = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleBackButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        tableView.backgroundColor = .white
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.rowHeight = 64
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchResultsUpdater = self
        configureSearchController(searchController: searchController)
    }
    
    //MARK: - Selectors
    @objc func handleBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableView DataSource

extension NewMessageController {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if !inSearchMode {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
                returnedView.backgroundColor = .white
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 25))
                label.text = "    Suggested"
                label.font = UIFont.boldSystemFont(ofSize: 14)
                returnedView.addSubview(label)

                return returnedView
        } else  {
            return UIView()
        }
    }
     
  
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : suggestedUsers.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = inSearchMode ? filteredUsers[indexPath.row] : suggestedUsers[indexPath.row]
        
        cell.viewModel = UserCellViewModel(user: user)
        
        return cell
    }
}


//MARK: - TableView Delegate

extension NewMessageController {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : suggestedUsers[indexPath.row]
        
        delegate?.controller(self, wantsToChatWith: user)

    }
}

//MARK: - UISearchResultsUpdating

extension NewMessageController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        
        filteredUsers = users.filter({  $0.username.contains(searchText) || $0.fullname.lowercased().contains(searchText)    })
        self.tableView.reloadData()
    }
}
