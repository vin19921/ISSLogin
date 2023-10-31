//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 17/10/2023.
//

import UIKit

public enum ViewProfile {
    public enum Model {
        public struct Request: Encodable {
            public var mobileNo: String
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
