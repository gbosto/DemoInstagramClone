//
//  FeedController.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import Firebase

 class FeedController: UICollectionViewController {
    
    //MARK: - Properties
    
    private let cellId = "FeedCell"
    private var headerId = "FeedHeaderId"
    
    private var posts = [Post]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var post: Post? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
        
        if post != nil {
            checkIfUserLikedPost()
            checkIfPostBelongsToCurrentUser()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
    }

    //MARK: - Helper Methods
    
    func configureUI() {
        navigationController?.setStatusBar(backgroundColor: .white)

        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(FeedHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerId)
     
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        if post == nil {
        collectionView.refreshControl = refresher
        }
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
    }

    //MARK: - API
    
    func fetchPosts() {
        guard post == nil else {return}
        
        
        PostService.fetchFeedPosts { posts in
            self.posts = posts
            self.checkIfUserLikedPost()
            self.checkIfPostBelongsToCurrentUser()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func checkIfPostBelongsToCurrentUser() {
        if let post = post {
            PostService.checkIfPostBelongsToCurrentUser(post: post) { belongsToUser in
                self.post?.belongsToCurrentUser = belongsToUser
            }
        } else {
            posts.forEach { post in
                PostService.checkIfPostBelongsToCurrentUser(post: post) { belongsToUser in
                    if let index = self.posts.firstIndex(where: {$0.postId == post.postId }) {
                        self.posts[index].belongsToCurrentUser = belongsToUser
                    }
                }
            }
        }
    }
    
    func checkIfUserLikedPost() {
        if let post = post {
            PostService.checkIfUserLiked(post: post) { didLike in
                self.post?.didLike = didLike
            }
        } else {
            posts.forEach { post in
                PostService.checkIfUserLiked(post: post) { didLike in
                    if let index = self.posts.firstIndex(where: {$0.postId == post.postId }) {
                        self.posts[index].didLike = didLike
                    }
                }
            }
        }
    }
    
    func deletePost(post: Post){
            PostService.deletePost(post: post)
    }
    
    //MARK: - Selectors

    @objc func handleRefresh() {
        posts.removeAll()
        fetchPosts()
        collectionView.reloadData()
    }
}

    //MARK: - Data Source

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        cell.delegate = self
        
        if let post = self.post {
            UserService.fetchUser(withUid: post.ownerUid) { user in
                cell.viewModel = PostViewModel(post: post, user: user)
            }
        } else {
            let posts = self.posts.sorted {$0.timestamp.compare($1.timestamp) == ComparisonResult.orderedDescending}
            let feedPost = posts[indexPath.row]
            UserService.fetchUser(withUid: feedPost.ownerUid) { user in
                cell.viewModel = PostViewModel(post: feedPost, user: user)
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: headerId,
                                                                     for: indexPath) as! FeedHeader
        header.delegate = self
        if post != nil {
            header.backButton.isHidden = false
            header.iconImageView.isHidden = true
            header.directMessagesButton.isHidden = true
        }
        return header
    }
}

    //MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if post == nil {
        return CGSize(width: view.frame.width, height: 60)
        } else {
            return CGSize(width: view.frame.width, height: 40)
        }
    }
}


//MARK: - FeedCellDelegate

extension FeedController: FeedCellDelegate {
    
    func cell(_ cell: FeedCell,
              wantsToShowCommentsFor post: Post) {
        
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeedCell,
              didLike post: Post) {
        
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}

        cell.viewModel?.post.didLike.toggle()
        
        if post.didLike {
            PostService.unlikePost(post: post) { error in
                if let error = error {
                    print("DEBUGL: Failed to unlike post with \(error.localizedDescription)")
                }
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
        } else {
            PostService.likePost(post: post) { error in
                if let error = error {
                    print("DEBUGL: Failed to like post with \(error.localizedDescription)")
                }
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
                
                UserService.fetchUser(withUid: currentUserUid) { currentUser in
                    NotificationService.uploadNotification(toUid: post.ownerUid,
                                                           fromUser: currentUser,
                                                           type: .like,
                                                           post: post)
                }
            }
        }
    }
    
    func cell(_ cell: FeedCell,
              wantsToShowProfileFor uid: String) {
        
        UserService.fetchUser(withUid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func cell(_ cell: FeedCell, wantsToShowDetailsFor post: Post) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete post", style: .default) { _ in
            self.deletePost(post: post)
            self.fetchPosts()
            if self.post != nil {
            self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
        }
    }

extension FeedController: FeedHeaderViewDelegate {
    func headerWantsToGoBack(_ feedHeader: FeedHeader) {
        navigationController?.popViewController(animated: true)
    }
    
    func headerWantsToShowDirectMessages(_ feedHeader: FeedHeader) {
        let controller = ConversationsController()
            navigationController?.pushViewController(controller, animated: true)
    }
}
