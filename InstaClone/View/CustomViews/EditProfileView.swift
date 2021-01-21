//
//  EditProfileView.swift
//  InstaClone
//
//  Created by Giorgi on 1/12/21.
//

import UIKit

protocol EditProfileViewDelegate: class {
    func viewWantsToEditName(_ view: EditProfileView)
    func viewWantsToEditUserName(_ view: EditProfileView)
}

class EditProfileView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: EditProfileViewDelegate?
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.text = "Name"
        view.font = UIFont.boldSystemFont(ofSize: 16)
        
        return view
    }()
    
    private let usernameLabel: UILabel = {
        let view = UILabel()
        view.text = "Username"
        view.font = UIFont.boldSystemFont(ofSize: 16)
        
        return view
    }()
    
     let usersNameLabel: UILabel = {
        let view = UILabel()
        view.text = "user.name"
        view.font = UIFont.systemFont(ofSize: 14)
        
        return view
    }()
    
     let usersUsernameLabel: UILabel = {
        let view = UILabel()
        view.text = "user.username"
        view.font = UIFont.systemFont(ofSize: 14)
        
        return view
    }()
    
    private let editNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("edit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setDimensions(height: 20, width: 30)
        button.addTarget(self, action: #selector(handleEditName), for: .touchUpInside)
        
        return button
    }()
    
    private let editUsernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("edit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setDimensions(height: 20, width: 30)
        button.addTarget(self, action: #selector(handleEditUsername), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let nameStack = configureEditNameStack()
        let usernameStack = configureEditUsernameStack()
        
        let stack = UIStackView(arrangedSubviews: [nameStack, usernameStack])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor,
                     bottom: bottomAnchor, right: rightAnchor,
                     paddingTop: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureEditNameStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [nameLabel, usersNameLabel, editNameButton])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .equalCentering
        
        return stack
    }
    
    func configureEditUsernameStack() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [usernameLabel, usersUsernameLabel, editUsernameButton])
        stack.axis = .horizontal
        stack.spacing = 40
        stack.distribution = .equalCentering
        
        return stack
    }
    
    //MARK: - Selectors
    
    @objc func handleEditName() {
        delegate?.viewWantsToEditName(self)
    }
    
    @objc func handleEditUsername() {
        delegate?.viewWantsToEditUserName(self)
    }
}
