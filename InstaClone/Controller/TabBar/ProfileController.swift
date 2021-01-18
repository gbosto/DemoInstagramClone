//
//  ProfileController.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import Firebase

protocol ProfileControllerDelegate: class {
    func controllerWantsToLogout()
}

 class ProfileController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var user: User
    
    private var posts = [Post]()
    weak var delegate: ProfileControllerDelegate?
    
    private var cellId = "ProfilePostCell"
    private var headerId = "HeaderId"
    
    //MARK: - Lifecycle
    
    init (user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        checkIfUserIsFollowed()
        fetchPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUser()
        fetchUserStats()
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: - API
    
    func checkIfUserIsFollowed() {
        UserService.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    func fetchPosts() {
        PostService.fetchPosts(forUser: user.uid) { posts in
            self.posts = posts
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    func fetchUser() {
        UserService.fetchUser(withUid: user.uid) { user in
            self.user = user
            self.collectionView.reloadData()
            self.navigationItem.title = user.username
        }
    }
    
    
    
    //MARK: - Selectors
    
    @objc func handleLogout () {
        delegate?.controllerWantsToLogout()
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchUserStats()
        fetchPosts()
        collectionView.reloadData()
    }
 
    //MARK: - Helper Methods
    
    func configureUI() {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain,
                                           target: self, action: #selector(handleLogout))
        
        if user.uid == Auth.auth().currentUser?.uid {
            navigationItem.rightBarButtonItem = logoutButton
        }
        navigationItem.title = user.username
        collectionView.backgroundColor = .white
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(ProfileHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerId)
    }
}

//MARK: - Data Source

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        cell.viewModel = PostViewModel(post: post, user: user)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: headerId,
                                                                     for: indexPath) as! ProfileHeader
        header.delegate = self
        header.viewModel = ProfileHeaderViewModel(user: user)
        
        return header
    }
}

//MARK: - Delegate

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let controller = FeedController(collectionViewLayout: layout)
        controller.post = posts[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 222)
    }
}

//MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        guard let tab = tabBarController as? MainTabController,
              let currentUser = tab.user else {return}
        
        if user.isCurrentUser {
        let controller = EditProfileController(user: user)
            navigationController?.pushViewController(controller, animated: true)
        } else {
        
        if user.isFollowed {
            UserService.unfollow(uid: user.uid) { error in
                self.user.isFollowed = false
                self.fetchUserStats()
                self.collectionView.reloadData()
                PostService.updateUserFeedAfterFollowing(user: user, didFollow: false)
            }
        } else {
            UserService.follow(uid: user.uid) { error in
                self.user.isFollowed = true
                self.fetchUserStats()
                self.collectionView.reloadData()
                
                NotificationService.uploadNotification(toUid: user.uid,
                                                       fromUser: currentUser,
                                                       type: .follow)
                
                PostService.updateUserFeedAfterFollowing(user: user, didFollow: true)
                }
            }
        }
    }
    
    func header(wantsToShowUserFollowers show: Bool) {
        let controller = FollowersController(user: user, showFollowers: show)
        
        navigationController?.pushViewController(controller, animated: true)
    }
}


