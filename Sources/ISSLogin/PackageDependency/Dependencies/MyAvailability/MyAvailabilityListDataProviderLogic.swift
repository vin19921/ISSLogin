//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 18/06/2024.
//

import Combine

public protocol MyAvailabilityListDataProviderLogic {
    func fetchMyAvailabilityList() -> AnyPublisher<String, Error>
}
