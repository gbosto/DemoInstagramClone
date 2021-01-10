//
//  CommentController.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit

class CommentController: UICollectionViewController {
    
    //MARK: - Properties
    
    private let cellId = ReuseId.forCommentCell
    
    private let post: Post
    private var comments = [Comment]()
    
    
    private lazy var commentInputView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let view = CommentInputAccessoryView(frame: frame)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
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
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.comments.count - 1], at: .bottom, animated: true)
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
        let comment = comments[indexPath.row]
        cell.viewModel = CommentViewModel(comment: comment)
        
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

extension CommentController: CommentInputAccessoryViewDelegate {
    func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String) {

        guard let tabBarController = tabBarController as? MainTabController,
        let currentUser = tabBarController.user else {return}
        
        showLoader(true)
        
        CommentService.uploadComments(comment: comment, postID: post.postId, user: currentUser) { error in
            self.showLoader(false)
            inputView.clearCommentTextView()
            
            NotificationService.uploadNotification(toUid: self.post.ownerUid, fromUser: currentUser, type: .comment, post: self.post)
        }
    }
}
