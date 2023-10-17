//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 05/10/2023.
//

import Combine

/// The provider facilitate communication between the controller from the UI layer and the services that are used to retrieve/persist data.
/// This helps provide proper separation of concerns between the these objects.
public protocol LoginDataProviderLogic {
    func fetchLogin(request: Login.Model.Request) -> AnyPublisher<LoginResponse, Error>
    func getUserInfo(key: UserInfoKey) -> String
    func saveUserInfo(loginDataModel: LoginDataModel)
}
