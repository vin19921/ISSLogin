//
//  ViewProfileDataProviderLogic.swift
//
//
//  Copyright by iSoftStone 2024.
//


import Combine

/// The provider facilitate communication between the controller from the UI layer and the services that are used to retrieve/persist data.
/// This helps provide proper separation of concerns between the these objects.
public protocol ViewProfileDataProviderLogic {
    func fetchViewProfile(request: ViewProfile.Model.FetchRequest) -> AnyPublisher<ViewProfileResponse, Error>
    func updateProfile(request: ViewProfile.Model.UpdateRequest) -> AnyPublisher<ViewProfileResponse, Error>
    func saveUserInfo(viewProfileDataModel: ViewProfileDataModel)
}
