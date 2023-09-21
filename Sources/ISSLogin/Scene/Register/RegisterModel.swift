//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 20/09/2023.
//

import UIKit

public enum RegisterModel {
    public struct Request: Encodable {
        public var mobileNo: String
        public var password: String
        public var confirmPassword: String
        public var email: String
        public var name: String
    }

    struct Response {
        var resultCode: Int16
        var resultMessage: String
        var data: Register
    }
}
