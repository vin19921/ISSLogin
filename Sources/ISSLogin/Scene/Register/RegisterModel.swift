//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 20/09/2023.
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
        }
        
        struct Response {
            var resultCode: Int16? = 1
            var resultMessage: String?
            var data: Register
        }

        struct ViewModel {
            var message: String
            var registrationData: Register
        }
    }
}
