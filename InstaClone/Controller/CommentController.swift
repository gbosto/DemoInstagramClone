//
//  CommentController.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit
import Firebase

class CommentController: UICollectionViewController {
    
    //MARK: - Properties
    
    private let cellId = "CommentCell"
    
    private let post: Post
    private var comments = [Comment]()
    
    
    private lazy var commentInputView: CostumInputAccessoryView = {
        let view = CostumInputAccessoryView(placeholderTitle: "Enter comment", buttonTitle: "Post",
                                            frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        view.delegate = self
        
        return view
    }()
    
    //MARK: - Lifecycle
    
    init(post: Post) {
        self.post = post
        
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchComments()
        print(post.belongsToCurrentUser)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return commentInputView
        }
    }
    
    
    //MARK: - API
    
    func fetchComments() {
        CommentService.fetchComments(forPost: post.postId) { comments in
            self.comments = comments
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.reloadData()
            self.checkIfCommentBelongsToCurrentUser()
            self.collectionView.scrollToItem(at: [0, self.comments.count - 1], at: .bottom, animated: false)
        }
    }
    
    func checkIfCommentBelongsToCurrentUser() {
        
        comments.forEach { comment in
            
            CommentService.checkIfCommentBelongsToCurrentUser(post: post, comment: comment) { belogsToUser in
                if let index = self.comments.firstIndex(where: {$0.commentId == comment.commentId }) {
                    self.comments[index].commentBelongsToCurrentUser = belogsToUser
                }
            }
        }
    }
    
    //MARK: - Helper Methods
    
    func configureUI() {
        navigationItem.title = "Comments"
        
        collectionView.backgroundColor = .white
        collectionView.register(CommentCell.self,
                                forCellWithReuseIdentifier: cellId)
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
    //MARK: - Selectors
    
    @objc func handleRefresh() {
        comments.removeAll()
        fetchComments()
        collectionView.reloadData()
    }
}

    //MARK: - Data Source

extension CommentController {
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId,
                                                      for: indexPath) as! CommentCell
        let comments = self.comments.sorted {$0.timestamp.compare($1.timestamp) == ComparisonResult.orderedAscending}
        var comment = comments[indexPath.row]
        comment.postBelongsToCurrentUser = post.belongsToCurrentUser

        cell.delegate = self
        UserService.fetchUser(withUid: comment.uid) { user in
            cell.viewModel = CommentViewModel(comment: comment, user: user)
        }
        
        return cell
    }
}

    //MARK: - UICollectionViewDelegateFlowLayout

extension CommentController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let comment = comments[indexPath.row]
        
        
        
        
        let viewModel = CommentViewModel(comment: comment)
        let height = viewModel.size(forWidth: view.frame.width).height + 32
        
        return CGSize(width: view.frame.width, height: height)
    }
}

//MARK: - Delegate

extension CommentController {
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        let comments = self.comments.sorted {$0.timestamp.compare($1.timestamp) == ComparisonResult.orderedAscending}
        let comment = comments[indexPath.row]
        let uid = comment.uid
        
        UserService.fetchUser(withUid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

//MARK: - CommentInputAccessoryViewDelegate

extension CommentController: CostumInputAccessoryViewDelegate {
    func inputView(_ inputView: CostumInputAccessoryView, wantsToUploadInput input: String) {
        showLoader(true)
        guard let currentUserUid = Auth.auth().currentUser?.uid else {return}
        UserService.fetchUser(withUid: currentUserUid) { user in
            CommentService.uploadComments(comment: input, postID: self.post.postId, user: user) { error in
                self.showLoader(false)
                inputView.clearInputTextView()
                
                NotificationService.uploadNotification(toUid: self.post.ownerUid, fromUser: user, type: .comment, post: self.post)
            }
        }
    }}

extension CommentController: commentCellDelegate {
    func cellWantsToDelete(comment: Comment) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete comment", style: .default) { _ in
            CommentService.deleteComment(forPost: self.post, comment: comment)
            self.fetchComments()
        }
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
        }
    }
    
    

