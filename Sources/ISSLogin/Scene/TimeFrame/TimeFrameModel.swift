//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/05/2024.
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
//            public var resultCode: Int16? = 1
            public var resultMessage: String?
//            public var status: Int16?
            public var data: TimeFrameListDataModel? = nil
        }

        struct ViewModel {
            var message: String
            var timeFrameList: [TimeFrameDataModel]
        }

        public struct TimeFrame {
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
