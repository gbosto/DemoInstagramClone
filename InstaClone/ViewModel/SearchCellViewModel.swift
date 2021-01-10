//
//  SearchCellViewModel.swift
//  InstaClone
//
//  Created by Giorgi on 1/4/21.
//

import Foundation

struct SearchCellViewModel {
    let user: User
    
    var username: String {
        return user.username
    }
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    init(user: User) {
        self.user = user
    }
}
