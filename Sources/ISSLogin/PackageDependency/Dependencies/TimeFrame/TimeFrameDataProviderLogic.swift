//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/05/2024.
//

import Combine

public protocol TimeFrameDataProviderLogic {
    func fetchTimeFrameList(request: TimeFrame.Model.Request) -> AnyPublisher<TimeFrameListResponse, Error>
}

