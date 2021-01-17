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
    func header(wantsToShowUserFollowers show: Bool)
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
    
    private let bioLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12)
        view.text = "bio"
        view.numberOfLines = 0
        
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleShowFollowers))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    private lazy var followingLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .center
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleShowFollowings))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
        return view
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
        
        addSubview(bioLabel)
        bioLabel.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,
                        paddingTop: 6, paddingLeft: 12, paddingRight: 12)
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: bioLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                 paddingTop: 16, paddingLeft: 24, paddingRight: 24)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        
        addSubview(divider)
        divider.anchor(top: editProfileFollowButton.bottomAnchor, left: leftAnchor,right: rightAnchor,
                       paddingTop: 30, height: 0.5)
        
        
        configureStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helper Methods

    
    func configureStack() {
        let stack = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.centerY(inView: profileImageView)
        stack.anchor(left: profileImageView.rightAnchor, right: rightAnchor,
                     paddingLeft: 12, paddingRight: 12,
                     height: 50)
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
    
    @objc func handleShowFollowers() {
        delegate?.header(wantsToShowUserFollowers: true)
    }
    
    @objc func handleShowFollowings() {
        delegate?.header(wantsToShowUserFollowers: false)
    }
}
