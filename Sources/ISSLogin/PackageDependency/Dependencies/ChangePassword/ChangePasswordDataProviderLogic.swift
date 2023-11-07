//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/11/2023.
//

import Combine

/// The provider facilitate communication between the controller from the UI layer and the services that are used to retrieve/persist data.
/// This helps provide proper separation of concerns between the these objects.
public protocol ChangePasswordDataProviderLogic {
    func changePassword(request: ChangePassword.Model.UpdateRequest) -> AnyPublisher<ChangePasswordResponse, Error>
}
