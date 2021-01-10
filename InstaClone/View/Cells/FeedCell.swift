//
//  FeedCell.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit

protocol FeedCellDelegate: class {
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post )
    func cell(_ cell: FeedCell, didLike post: Post)
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String)
}


 class FeedCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    weak var delegate: FeedCellDelegate?
    
    var viewModel: PostViewModel? {
        didSet {
            configure()
        }
    }
    
    private lazy var ProfileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.backgroundColor = .lightGray
        
        view.setDimensions(height: 40, width: 40)
        view.layer.cornerRadius = 40 / 2
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showUserProfile))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
   
        return view
    }()
    
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(showUserProfile), for: .touchUpInside)
        
        return button
    }()
    
    private let postImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    
     lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapComments), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private let likesLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 13)
        
        return view
    }()
    
    
    private let captionLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        
        return view
    }()
    
    private let postTimeLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .lightGray
        
        return view
    }()
        
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(ProfileImageView)
        ProfileImageView.anchor(top: topAnchor, left: leftAnchor,
                                paddingTop: 12, paddingLeft: 12)
        
        addSubview(usernameButton)
        usernameButton.centerY(inView: ProfileImageView, leftAnchor: ProfileImageView.rightAnchor,
                               paddingLeft: 8)
        
        addSubview(postImageView)
        postImageView.anchor(top: ProfileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor,
                             paddingTop: 8)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        configureActionButtons()
        
        addSubview(likesLabel)
        likesLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor,
                          paddingTop: -4, paddingLeft: 8)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likesLabel.bottomAnchor, left: leftAnchor,
                            paddingTop: 8, paddingLeft: 8)
        
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor,
                             paddingTop: 8, paddingLeft: 8)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Methods
    
    func configureActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor, width: 120, height: 50)
    }
    
    func configure() {
        guard let viewModel = self.viewModel else {return}
        captionLabel.text = viewModel.caption
        postImageView.sd_setImage(with: viewModel.imageUrl)
        likesLabel.text = viewModel.likes
        
        likeButton.tintColor = viewModel.likesButtonTintColor
        likeButton.setImage(viewModel.likesButtonImage, for: .normal)
        
        ProfileImageView.sd_setImage(with: viewModel.userProfileImageUrl)
        usernameButton.setTitle(viewModel.username, for: .normal)
        
        guard let timestampText = viewModel.timestampString else {return}
        postTimeLabel.text = timestampText + " ago"
        
        
    }
    
    //MARK: - Selectors
    
    @objc func showUserProfile() {
        guard let viewModel = self.viewModel else {return}
        delegate?.cell(self, wantsToShowProfileFor: viewModel.post.ownerUid)
    }
    
    @objc func didTapLike() {
        guard let viewModel = viewModel else {return}
        delegate?.cell(self, didLike: viewModel.post)
    }
    
    @objc func didTapComments() {
        guard let delegate = self.delegate,
              let viewModel = self.viewModel else {return}
        delegate.cell(self, wantsToShowCommentsFor: viewModel.post)
    }
    
}
