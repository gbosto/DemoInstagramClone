//
//  CommentViewModel.swift
//  InstaClone
//
//  Created by Giorgi on 1/6/21.
//

import UIKit

struct CommentViewModel {
    let comment: Comment
    let user: User?
    
    var profileImageUrl: URL? {
        guard let user = self.user else {return URL(string: "")}
        return URL(string: user.profileImageUrl)
    }
    
    var timestampString: String? {
        let formater = DateComponentsFormatter()
        formater.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formater.maximumUnitCount = 1
        formater.unitsStyle = .abbreviated
        
        return formater.string(from: comment.timestamp.dateValue(), to: Date())
    }
    
    var detailsButtonIsHidden: Bool {
        return comment.commentBelongsToCurrentUser || comment.postBelongsToCurrentUser ? false : true
    }
    
    init(comment: Comment, user: User? = nil) {
        self.comment = comment
        self.user = user
    }
    
    func commentLabelText() -> NSAttributedString {
        guard let user = self.user else {return NSAttributedString()}
        let attributedString = NSMutableAttributedString(string: user.username,
                                                         attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedString.append(NSAttributedString(string: " \(comment.comment)",
                                                   attributes: [.font: UIFont.systemFont(ofSize: 14)]))
        
        return attributedString
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = comment.comment
        label.lineBreakMode = .byWordWrapping
        label.setWidth(width)
        
    
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}


