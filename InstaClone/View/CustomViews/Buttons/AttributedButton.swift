//
//  AttributedButton.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit

class AttributedButton: UIButton {
    
    //MARK: - Lifecycle
    init(text: String, boldText: String){
        super.init(frame: .zero)
        
        let attributes: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.lightGray,
                                                          .font : UIFont.systemFont(ofSize: 14)]
        let boldAttributes: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.systemBlue,
                                                          .font : UIFont.boldSystemFont(ofSize: 14)]
        
        let attributedtitle = NSMutableAttributedString(string: text + " ", attributes: attributes)
        attributedtitle.append(NSAttributedString(string: boldText, attributes: boldAttributes))
        
        setAttributedTitle(attributedtitle, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
