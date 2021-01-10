//
//  AuthenticationTextField.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit

 class AuthenticationTextField: UITextField {
    
    //MARK: - Lifecycle
    
    init (placeholder: String, type: UIKeyboardType = .default, secureTextEntry: Bool = false) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always


        keyboardType = type
        layer.cornerRadius = 5
        enablesReturnKeyAutomatically = true
        returnKeyType = .continue
        clearButtonMode = .whileEditing
        borderStyle = .roundedRect
        textColor = .black
        keyboardAppearance = .dark
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        isSecureTextEntry = secureTextEntry
        setHeight(40)
        
        attributedPlaceholder = NSAttributedString(string: placeholder,
                                                   attributes: [.foregroundColor : UIColor.lightGray])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
