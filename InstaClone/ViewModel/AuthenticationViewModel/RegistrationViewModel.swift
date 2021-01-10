//
//  RegistrationViewModel.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import UIKit

struct RegistrationViewModel: AuthenticationViewModel {
    
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
            && fullname?.isEmpty == false
            && username?.isEmpty == false
 
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? UIColor.systemBlue : UIColor.systemBlue.withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.7)
    }
}
