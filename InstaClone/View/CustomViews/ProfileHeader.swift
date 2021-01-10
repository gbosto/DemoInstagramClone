//
//  ProfileHeader.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate: class {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User)
}

class ProfileHeader: UICollectionReusableView {
    
    //MARK: - Properties
    
    weak var delegate: ProfileHeaderDelegate?
    var viewModel: ProfileHeaderViewModel? {
        didSet {
            populate()
        }
    }
    
    
    private let profileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.setDimensions(height: 80, width: 80)
        view.layer.cornerRadius = 80 / 2
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 14)
        
        return view
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var postLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .center
        
        return view
    }()
    
    private lazy var followersLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .center
        
        return view
    }()
    
    private lazy var followingLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .center
        
        return view
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
        
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor,
                                paddingTop: 16, paddingLeft: 12)
        
        addSubview(nameLabel)
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor,
                         paddingTop: 12, paddingLeft: 12)
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                 paddingTop: 16, paddingLeft: 24, paddingRight: 24)
        
        configureStackForLabels()
        configureStackForButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helper Methods

    
    func configureStackForLabels() {
        let stack = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.centerY(inView: profileImageView)
        stack.anchor(left: profileImageView.rightAnchor, right: rightAnchor,
                     paddingLeft: 12, paddingRight: 12,
                     height: 50)
    }
    
    func configureStackForButtons() {
        let topDivider = UIView()
        topDivider.backgroundColor = .lightGray
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .lightGray
        
        let stack = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.anchor(left: leftAnchor, bottom: bottomAnchor,
                     right: rightAnchor, height: 50)
        
        addSubview(topDivider)
        topDivider.anchor(top: stack.topAnchor, left: leftAnchor,
                          right: rightAnchor, height: 0.5)
        
        addSubview(bottomDivider)
        bottomDivider.anchor(top: stack.bottomAnchor, left: leftAnchor,
                             right: rightAnchor, height: 0.5)
    }
    
    func populate() {
        guard let viewModel = self.viewModel else { return }
        
        nameLabel.text = viewModel.fullname
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        
        editProfileFollowButton.setTitle(viewModel.followButtomText, for: .normal)
        editProfileFollowButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
        editProfileFollowButton.backgroundColor = viewModel.followButtonBackgroundColor
        
        postLabel.attributedText = viewModel.numberOfPosts
        followersLabel.attributedText = viewModel.numberOfFollowers
        followingLabel.attributedText = viewModel.numberOfFollowing
    }
    
    //MARK: - Selectors
    @objc func handleEditProfile() {
        guard let viewModel = self.viewModel else {return}
        delegate?.header(self, didTapActionButtonFor: viewModel.user)
    }
}
