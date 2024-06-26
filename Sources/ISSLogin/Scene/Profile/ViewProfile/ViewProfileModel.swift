//
//  ViewProfileModel.swift
//
//
//  Copyright by iSoftStone 2024.
//

import UIKit

public enum ViewProfile {
    public enum Model {
        public struct FetchRequest: Encodable {
            public var mobileNo: String
        }

        public struct UpdateRequest: Encodable {
            public var name: String
            public var email: String
        }

        struct Response {
            var resultCode: Int16? = 1
            var resultMessage: String?
            var status: Int16?
            var data: ViewProfileDataModel
        }

        struct ViewModel {
            var message: String
            var viewProfileData: ViewProfileDataModel
        }
    }
}
