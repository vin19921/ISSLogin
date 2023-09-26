//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 22/09/2023.
//

import UIKit

public enum OTP {
    public enum Model {
        public struct Request: Encodable {
            public var mobileNo: String
            public var code: Int?
        }
        
        struct Response {
            var resultCode: Int16
            var resultMessage: String
            var data: OTPDataModel
        }

        struct ViewModel {
            var message: String
            var otpData: OTPDataModel
        }
    }
}
