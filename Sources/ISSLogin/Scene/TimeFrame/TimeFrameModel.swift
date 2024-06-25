//
//  TimeFrameModel.swift
//
//
//  Copyright by iSoftStone 2024.
//

import UIKit

public enum TimeFrame {
    public enum Model {
        public struct Request: Encodable {
            public var status: String = "active"
            public var currentPage: Int = 1
            public var pageSize: Int = 99
            public var sort: Int = 1
        }

        public struct Response {
            public var resultMessage: String?
            public var data: TimeFrameListDataModel? = nil
        }

        struct ViewModel {
            var message: String
            var timeFrameList: [TimeFrameDataModel]
        }

        public struct TimeFrame: Encodable {
            let date: String
            let timeFrameId: String
        }

        public struct CreateRequest: Encodable {
            public var rule: Int = 1
            public var scheduleName: String = "my schedule"
            public var status: Int = 0
            public var days: [TimeFrame] = []
        }

        public struct CreateResponse {
            public var resultMessage: String?
        }
    }
}
