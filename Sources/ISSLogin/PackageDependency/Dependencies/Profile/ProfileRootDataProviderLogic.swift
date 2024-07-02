//
//  ProfileRootDataProviderLogic.swift
//
//
//  Copyright by iSoftStone 2024.
//

import Combine

/// The provider facilitate communication between the controller from the UI layer and the services that are used to retrieve/persist data.
/// This helps provide proper separation of concerns between the these objects.
public protocol ProfileRootDataProviderLogic {
    func fetchViewProfile(request: ViewProfile.Model.FetchRequest) -> AnyPublisher<ViewProfileResponse, Error>
    func getUserName() -> String
    func getMobileNo() -> String
    func logOut()
    func isLoggedIn() -> Bool
    func hasRunBefore() -> Bool
    func isServiceProvider() -> Bool
}
