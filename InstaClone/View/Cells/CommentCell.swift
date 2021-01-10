//
//  CommentCell.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit

class CommentCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var viewModel: CommentViewModel? {
        didSet {
            configure()
        }
    }
    
    private lazy var profileImageview: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    let commentLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        
        return view
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageview)
        profileImageview.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        profileImageview.setDimensions(height: 40, width: 40)
        profileImageview.layer.cornerRadius = 40 / 2
        
        addSubview(commentLabel)
        commentLabel.centerY(inView: self, leftAnchor: profileImageview.rightAnchor, paddingLeft: 8)
        commentLabel.anchor(right: rightAnchor, paddingRight: 8)
        
        configureDivider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
 
    func configure() {
        guard let viewModel = viewModel else {return}
        
        profileImageview.sd_setImage(with: viewModel.profileImageUrl)
        commentLabel.attributedText = viewModel.commentLabelText()        
    }
}
