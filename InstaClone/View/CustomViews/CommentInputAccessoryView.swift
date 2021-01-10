//
//  CommentInputAccessoryView.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//


import UIKit

protocol CommentInputAccessoryViewDelegate: class {
    func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String)
}

class CommentInputAccessoryView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: CommentInputAccessoryViewDelegate?
    
     lazy var commentTextView: UITextView = {
        let view = UITextView()
        view.font = UIFont.systemFont(ofSize: 15)
        view.isScrollEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
        
        return view
    }()
    
    let placeholderLabel: UILabel = {
       let view = UILabel()
       view.textColor = .lightGray
       view.text = "Enter comment.."
       
       return view
   }()
    
     lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handlePostTap), for: .touchUpInside)
        button.isHidden = true
        
        button.setDimensions(height: 50, width: 50)
        
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        addSubview(postButton)
        postButton.anchor(top: topAnchor, right: rightAnchor,
                          paddingRight: 8)
        
        addSubview(commentTextView)
        commentTextView.anchor(top: topAnchor, left: leftAnchor,
                               bottom: safeAreaLayoutGuide.bottomAnchor, right: postButton.leftAnchor,
                               paddingTop: 8, paddingLeft: 8,
                               paddingBottom: 8, paddingRight: 8)
        
        commentTextView.addSubview(placeholderLabel)
        placeholderLabel.anchor(left: commentTextView.leftAnchor, right: commentTextView.rightAnchor,
                                paddingLeft: 4)
        placeholderLabel.centerY(inView: commentTextView)
        
        configureDivider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    //MARK: - Selectors
    
    @objc func handlePostTap () {
        delegate?.inputView(self, wantsToUploadComment: commentTextView.text)
    }
    
    @objc func textDidChange() {
        placeholderLabel.isHidden = !commentTextView.text.isEmpty
        postButton.isHidden = commentTextView.text.isEmpty
    }
    //MARK: - Helpers
    
    func clearCommentTextView() {
        commentTextView.text = nil
        placeholderLabel.isHidden = false
    }
}
