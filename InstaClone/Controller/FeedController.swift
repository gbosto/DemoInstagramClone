//
//  FeedController.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit

 class FeedController: UICollectionViewController {
    
    //MARK: - Properties
    
    private let cellId = ReuseId.forFeedCell
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
        }
        
    }

    //MARK: - Helper Methods
    
    func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
     
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        if post == nil {
        navigationItem.title = NavigationItemTitle.forFeedController
        collectionView.refreshControl = refresher
        } else {
            navigationItem.title = " "
        }
    }
    
    //MARK: - API
    
    func fetchPosts() {
        guard post == nil else {return}

        PostService.fetchFeedPosts { posts in
            self.posts = posts
            self.checkIfUserLikedPost()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func checkIfUserLikedPost() {
        if let post = post {
            PostService.checkIfUserLiked(post: post) { didLike in
                self.post?.didLike = didLike
            }
        } else {
            posts.forEach { post in
                PostService.checkIfUserLiked(post: post) { isLiked in
                    if let index = self.posts.firstIndex(where: {$0.postId == post.postId }) {
                        self.posts[index].didLike = isLiked
                    }
                }
            }
        }
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
            cell.viewModel = PostViewModel(post: post)
        } else {
            let posts = self.posts.sorted {$0.timestamp.compare($1.timestamp) == ComparisonResult.orderedDescending}
            let feedPost = posts[indexPath.row]
            cell.viewModel = PostViewModel(post: feedPost)
            
        }
        return cell
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
}


extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell,
              wantsToShowCommentsFor post: Post) {
        
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeedCell,
              didLike post: Post) {
        
        guard let tab = tabBarController as? MainTabController,
              let currentUser = tab.user else {return}

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
                
                NotificationService.uploadNotification(toUid: post.ownerUid,
                                                       fromUser: currentUser,
                                                       type: .like,
                                                       post: post)
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
}
