//
//  ConversationsCell.swift
//  InstaClone
//
//  Created by Giorgi on 1/16/21.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    //MARK: - Properties
    
    var viewModel: ConversationViewModel? {
        didSet {
            configure()
        }
    }
    
    private let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
    
        return imageView
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.text = "2h"
        
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    private let messageTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    //MARK: - Lifecycle
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor, paddingLeft: 12)
        profileImageView.setDimensions(height: 50, width: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerY(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, messageTextLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: profileImageView)
        stack.anchor(left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 16)
        
        addSubview(timestampLabel)
        timestampLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 20, paddingRight: 12)    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else {return}
        
        usernameLabel.text = viewModel.conversation.user.username
        messageTextLabel.text = viewModel.conversation.message.text
        timestampLabel.text = viewModel.timestamp
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
}
