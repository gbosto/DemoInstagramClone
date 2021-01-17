//
//  SearchController.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit

 class SearchController: UIViewController {
    
    //MARK: -  Properties
    
    
    private let collectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout())
    private let collectionViewCellId = "PostCell"
    private var posts = [Post]()

    
    private let searchController = UISearchController(searchResultsController: nil)
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }

    private let tableView = UITableView()
    private let tableViewCellId = "SearchCell"
    
    private var users = [User]()
    private var filteredUsers = [User]()
    
 
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureCollectionView()
        configuraSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPosts()
        fetchUsers()
        navigationController?.navigationBar.isHidden = false
    }
    
    func configuraSearchController() {
        configureSearchController(searchController: searchController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }

    
    //MARK: - Helper Methods
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .white
        tableView.register(UserCell.self, forCellReuseIdentifier: tableViewCellId)
        tableView.rowHeight = 64
        tableView.tableFooterView = UIView()
        
        tableView.isHidden = true
    }
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.fillSuperview()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: collectionViewCellId)

    }
    
    
    //MARK: - API
    
    func fetchUsers() {
        showLoader(true)
        
        UserService.fetchUsers { users in
            self.showLoader(false)
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    func fetchPosts() {
        showLoader(true)
        PostService.fetchPosts { posts in
            self.showLoader(false)
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
}

//MARK: - TableView DataSource

extension SearchController: UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId, for: indexPath) as! UserCell
        if inSearchMode {
            let user = filteredUsers[indexPath.row]
            cell.viewModel = UserCellViewModel(user: user)
        }
        return cell
    }
}

//MARK: - TableView Delegate

extension SearchController: UITableViewDelegate {
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if inSearchMode {
            let user = filteredUsers[indexPath.row]
            let controller = ProfileController(user: user)
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}

//MARK: - UISearchResultsUpdating

extension SearchController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else {return}
        
        filteredUsers = users.filter({  $0.username.contains(searchText) || $0.fullname.lowercased().contains(searchText)})
        self.tableView.reloadData()
    }
}

//MARK: - UISearchBarDelegate

extension SearchController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        collectionView.isHidden = true
        tableView.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        searchBar.text = nil
        
        collectionView.isHidden = false
        tableView.isHidden = true
    }
}


//MARK: - CollectionView DataSource

extension SearchController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellId, for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        cell.viewModel = PostViewModel(post: post)
        
        return cell
    
    }
}


//MARK: - CollectionView Delegate

extension SearchController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let layout = UICollectionViewFlowLayout()
        let controller = FeedController(collectionViewLayout: layout)
        controller.post = post
        
        navigationController?.pushViewController(controller, animated: true)
    }
}


//MARK: - UICollectionViewDelegateFlowLayout

extension SearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        
        return CGSize(width: width, height: width)
    }
}
