//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 12/10/2023.
//

import Combine

/// The provider facilitate communication between the controller from the UI layer and the services that are used to retrieve/persist data.
/// This helps provide proper separation of concerns between the these objects.
public protocol ProfileRootDataProviderLogic {
//    func getUserInfo(key: UserInfoKey) -> String
    func fetchViewProfile(request: ViewProfile.Model.FetchRequest) -> AnyPublisher<ViewProfileResponse, Error>
    func getUserName() -> String
    func logOut()
    func isLoggedIn() -> Bool
    func hasRunBefore() -> Bool
}
