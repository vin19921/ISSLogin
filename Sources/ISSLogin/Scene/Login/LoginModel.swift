//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 05/10/2023.
//

import UIKit

public enum Login {
    public enum Model {
        public struct Request: Encodable {
            public var mobileNo: String
            public var password: String
        }

        struct Response {
            var resultCode: Int16?
            var resultMessage: String?
            var status: Bool?
            var data: LoginDataModel
        }

        struct ViewModel {
            var message: String
            var otpData: LoginDataModel
        }
    }
}
