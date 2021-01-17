//
//  Conversationsheader.swift
//  InstaClone
//
//  Created by Giorgi on 1/15/21.
//

import UIKit

protocol ConversationsHeaderDelegate: class {
    func headerWantsToShowNewMessage()
    func headerWantsToCloseChat()
}

class ConversationsHeader: UIView {
    //MARK: - Properties
    
    weak var delegate: ConversationsHeaderDelegate?
    
    lazy var newMessageButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "square.and.pencil")
            button.setImage(image, for: .normal)
            button.tintColor = .black
            button.addTarget(self, action: #selector(handleShowNewMessage), for: .touchUpInside)
            button.setDimensions(height: 50, width: 50)
        
        return button
    }()
    
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
            button.tintColor = .black
        let image = UIImage(systemName: "chevron.left")
            button.setImage(image, for: .normal)
            button.setTitle("  Chats", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
            button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
            button.setDimensions(height: 50, width: 120)
       
       return button
   }()
    
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(newMessageButton)
        newMessageButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 8, paddingRight: 12)
        
        addSubview(backButton)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - Selectors

    @objc func handleShowNewMessage () {
        delegate?.headerWantsToShowNewMessage()     
    }
    
    @objc func handleBackButtonTapped () {
        delegate?.headerWantsToCloseChat()
    }
}
