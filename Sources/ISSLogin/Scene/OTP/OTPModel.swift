//
//  OTPModel.swift
//
//
//  Copyright by iSoftStone 2024.
//

import UIKit

public enum OTP {
    public enum Model {
        public struct Request: Encodable {
            public var mobileNo: String
            public var code: Int?
            public var otpAttemptCount: Int16
        }

        struct Response {
            var resultCode: Int16? = 1
            var resultMessage: String?
            var data: OTPDataModel
        }

        struct ViewModel {
            var message: String
            var otpData: OTPDataModel
        }
    }
}

public enum OTPAction {
    case registration
    case resetPassword
}
