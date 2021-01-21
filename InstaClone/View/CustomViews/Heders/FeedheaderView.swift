//
//  Feedheader.swift
//  InstaClone
//
//  Created by Giorgi on 1/11/21.
//

import UIKit

protocol FeedHeaderViewDelegate: class {
    func headerWantsToGoBack(_ feedHeader: FeedHeader)
    func headerWantsToShowDirectMessages(_ feedHeader: FeedHeader)
}

class FeedHeader: UICollectionReusableView {
    
    //MARK: - Properties
    
    weak var delegate: FeedHeaderViewDelegate?
    
    lazy var directMessagesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleShowDirectMessages), for: .touchUpInside)
        
        return button
    }()
    
     let iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "Insta_logo_2")
        view.setDimensions(height: 40, width: 110)
        
        return view
    }()
    
     lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        let image = UIImage(systemName: "chevron.left")
        button.setImage(image, for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(iconImageView)
        iconImageView.centerY(inView: self)
        iconImageView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor,
                             paddingTop: 12, paddingLeft: 12, paddingBottom: 12)
        
        
        addSubview(directMessagesButton)
        directMessagesButton.centerY(inView: iconImageView)
        directMessagesButton.anchor(top: safeAreaLayoutGuide.topAnchor, right: rightAnchor,
                     paddingTop: 12, paddingRight: 12)
        
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor,
                          paddingTop: 12, paddingLeft: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    //MARK: - Selectors
    
    @objc func handleShowDirectMessages () {
        delegate?.headerWantsToShowDirectMessages(self)
    }
    
    @objc func handleBackButtonTapped () {
        delegate?.headerWantsToGoBack(self)
    }
}

