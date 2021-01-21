//
//  CommentCell.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit

protocol commentCellDelegate: class {
    func cellWantsToDelete(_ cell: CommentCell, comment: Comment)
}

class CommentCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    weak var delegate: commentCellDelegate?
    
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
    
    private lazy var detailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        let image = UIImage(systemName: "ellipsis")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleDetailsButtonTapped), for: .touchUpInside)
        button.setDimensions(height: 30, width: 30)
        
        return button
    }()
    
    private let timestampLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .lightGray
        
        return view
    }()

    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(detailsButton)
        detailsButton.centerY(inView: self)
        detailsButton.anchor(right: rightAnchor, paddingRight: 12)
        
        contentView.addSubview(profileImageview)
        profileImageview.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        profileImageview.setDimensions(height: 40, width: 40)
        profileImageview.layer.cornerRadius = 40 / 2
        
        addSubview(commentLabel)
        commentLabel.centerY(inView: self, leftAnchor: profileImageview.rightAnchor, paddingLeft: 8)
        commentLabel.anchor(right: rightAnchor, paddingRight: 20)
        
        addSubview(timestampLabel)
        timestampLabel.anchor(top: commentLabel.bottomAnchor, left: profileImageview.rightAnchor,
                              paddingTop: 8, paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
 
    func configure() {
        guard let viewModel = viewModel else {return}
        
        profileImageview.sd_setImage(with: viewModel.profileImageUrl)
        commentLabel.attributedText = viewModel.commentLabelText()
        
        guard let timestampText = viewModel.timestampString else {return}
        timestampLabel.text = timestampText
        
        detailsButton.isHidden = viewModel.detailsButtonIsHidden
    }
    
    //MARK: - Selectors
    
    @objc func handleDetailsButtonTapped () {
        guard let viewModel = viewModel else {return}        
        delegate?.cellWantsToDelete(self, comment: viewModel.comment)
    }
}
