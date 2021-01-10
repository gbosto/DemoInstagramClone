//
//  ResetpasswordViewModel.swift
//  InstaClone
//
//  Created by Giorgi on 1/10/21.
//

import UIKit

struct ResetpasswordViewModel: AuthenticationViewModel {
    var email: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? UIColor.systemBlue : UIColor.systemBlue.withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.7)
    }
}
