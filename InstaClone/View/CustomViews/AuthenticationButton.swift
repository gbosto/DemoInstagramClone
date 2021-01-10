//
//  AuthenticationButton.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit

 class AuthenticationButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        layer.cornerRadius = 5
        setHeight(40)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
