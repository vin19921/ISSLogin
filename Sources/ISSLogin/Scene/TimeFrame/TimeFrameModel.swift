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
            var timeFrameList: TimeFrameListDataModel
        }
    }
}
