//
//  SearchCell.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit

class SearchCell: UITableViewCell {
    
    //MARK: - Properties
    
    var viewModel: SearchCellViewModel? {
        didSet {
            populate()
        }
    }
    
    private let ProfileImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        
        view.setDimensions(height: 48, width: 48)
        view.layer.cornerRadius = 48 / 2
        
        return view
    }()
    
    private let usernameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 14)
        
        return view
    }()
    
    private let fullnameLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = .lightGray
        
        return view
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(ProfileImageView)
        ProfileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        configureStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Methods
    
    func configureStack() {
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        
        addSubview(stack)
        stack.centerY(inView: ProfileImageView, leftAnchor: ProfileImageView.rightAnchor, paddingLeft: 8)
    }
    
    func populate() {
        guard let viewModel = self.viewModel else { return }
        usernameLabel.text = viewModel.username
        fullnameLabel.text = viewModel.fullname
        ProfileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }    
}
