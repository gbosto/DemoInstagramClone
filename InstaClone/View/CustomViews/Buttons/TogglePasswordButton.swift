//
//  TogglePasswordButton.swift
//  InstaClone
//
//  Created by Giorgi on 1/11/21.
//

import UIKit

protocol TogglePasswordButtonDelegate: class {
    func buttonPressed(button: TogglePasswordButton)
}

class TogglePasswordButton: UIButton {
    
    weak var delegate: TogglePasswordButtonDelegate?
    
    var isSecured = true
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        let image = UIImage(systemName: "eye.slash")
        tintColor = .lightGray
        setImage(image, for: .normal)
        isUserInteractionEnabled = true
        setDimensions(height: 15, width: 25)
        
        addTarget(self, action: #selector(handleToggleSecureText), for: .touchUpInside)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleToggleSecureText() {
        print("toggle button pressed")
        delegate?.buttonPressed(button: self)
    }
}
