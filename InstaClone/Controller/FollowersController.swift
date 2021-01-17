//
//  FollowersController.swift
//  InstaClone
//
//  Created by Giorgi on 1/11/21.
//

import UIKit

class FollowersController: UITableViewController {
    //MARK: - Properties
    
    private let user: User
    private let showFollowers: Bool
    
    private let cellId = "FollowersCell"
    private var users = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        if showFollowers {
            fetchFollowers()
        } else {
            fetchFollowing()
        }
    }
    
    init(user: User, showFollowers: Bool) {
        self.showFollowers = showFollowers
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Methods
    
    func configureUI() {
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = 64
        tableView.separatorStyle = .none
    }
    
    //MARK: - API
    func fetchFollowers() {
        showLoader(true)
        UserService.fetchFollowers(forUid: user.uid) { users in
            self.showLoader(false)
            self.users = users
        }
    }
    
    func fetchFollowing() {
        showLoader(true)
        UserService.fetchFollowing(forUid: user.uid) { users in
            self.showLoader(false)
            self.users = users
        }
    }
}

    //MARK: - Data Source

extension FollowersController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.viewModel = UserCellViewModel(user: user)
        
        return cell
    }
}

    //MARK: - Delegate

extension FollowersController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
