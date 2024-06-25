//
//  MyAvailabilityListDataProviderLogic.swift
//  
//
//  Copyright by iSoftStone 2024.
//

import Combine

public protocol MyAvailabilityListDataProviderLogic {
    func fetchMyAvailabilityList() -> AnyPublisher<String, Error>
}
