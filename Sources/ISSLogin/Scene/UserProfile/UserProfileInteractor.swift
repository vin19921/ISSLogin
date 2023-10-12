//
//  File 3.swift
//  
//
//  Created by Wing Seng Chew on 12/10/2023.
//

import Combine
import Foundation
import ISSNetwork

protocol UserProfileBusinessLogic {
    func getUserInfo(key: UserInfoKey) -> String
}

final class UserProfileInteractor: UserProfileBusinessLogic {
    private var provider: UserProfileDataProviderLogic
    private var cancellables = Set<AnyCancellable>()

    init(provider: UserProfileDataProviderLogic) {
        self.provider = provider
    }

    func getUserInfo(key: UserInfoKey) -> String {
        provider.getUserInfo(key: key)
    }
}

