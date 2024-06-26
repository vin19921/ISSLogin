//
//  ChangePasswordModel.swift
//
//
//  Copyright by iSoftStone 2024.
//

import UIKit

public enum ChangePassword {
    public enum Model {

        public struct UpdateRequest: Encodable {
            public var oldPassword: String
            public var newPassword: String
        }

        struct Response {
            var resultCode: Int16? = 1
            var resultMessage: String?
            var status: Int16?
        }

        struct ViewModel {
            var message: String
        }
    }
}
