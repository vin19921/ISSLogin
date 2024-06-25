//
//  TimeFrameDataProviderLogic.swift
//
//
//  Copyright by iSoftStone 2024.
//

import Combine

public protocol TimeFrameDataProviderLogic {
    func fetchTimeFrameList(request: TimeFrame.Model.Request) -> AnyPublisher<TimeFrameListResponse, Error>
    func createTimeFrame(request: TimeFrame.Model.CreateRequest) -> AnyPublisher<TimeFrameListResponse, Error>
}
