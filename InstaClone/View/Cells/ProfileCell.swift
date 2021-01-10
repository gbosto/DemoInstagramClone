//
//  ProfileCell.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    var viewModel: PostViewModel? {
        didSet {
            configure()
        }
    }
    
    //MARK: - Properties
    private let postImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "venom-7")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        return view
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(postImageView)
        postImageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Methods
    func configure() {
        guard let viewModel = self.viewModel else {return}
        
        postImageView.sd_setImage(with: viewModel.imageUrl)
    }
}

