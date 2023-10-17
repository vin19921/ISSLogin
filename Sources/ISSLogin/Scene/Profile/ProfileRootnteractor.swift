//
//  File 3.swift
//  
//
//  Created by Wing Seng Chew on 12/10/2023.
//

import Combine
import Foundation
import ISSNetwork

protocol ProfileRootBusinessLogic {
//    func getUserInfo(key: UserInfoKey) -> String
    func logOut()
}

final class ProfileRootInteractor: ProfileRootBusinessLogic {
    private var provider: ProfileRootDataProviderLogic
    private var cancellables = Set<AnyCancellable>()

    init(provider: ProfileRootDataProviderLogic) {
        self.provider = provider
    }

//    func getUserInfo(key: UserInfoKey) -> String {
//        provider.getUserInfo(key: key)
//    }

    func logOut() {
        provider.logOut()
    }
}

