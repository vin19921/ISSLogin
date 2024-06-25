//
//  RegisterModel.swift
//
//
//  Copyright by iSoftStone 2024.
//

import UIKit

public enum Registration {
    public enum Model {
        public struct Request: Encodable {
            public var mobileNo: String
            public var password: String
            public var confirmPassword: String
            public var email: String
            public var name: String
            public var userType: Int /// 0 = merchant, 1 = service_provider, 2 = customer
        }
        
        struct Response {
            var resultCode: Int16? = 1
            var resultMessage: String?
            var data: RegisterDataModel
        }

        struct ViewModel {
            var message: String
            var registrationData: RegisterDataModel
        }
    }
}
