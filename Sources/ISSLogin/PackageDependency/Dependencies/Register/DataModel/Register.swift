//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 20/09/2023.
//

public struct Register: Codable {
    public let _id: String?
    public let name: String?
    public let email: String?
    public let mobileNo: String?
    public let isDraft: Int16?
    public let isCompleteRegister: Int16?

    enum CodingKeys: String, CodingKey {
        case _id
        case name
        case email
        case mobileNo
        case isDraft
        case isCompleteRegister
    }
}

public struct RegisterResponse: Codable {
    public let resultCode: Int16?
    public let resultMessage: String?
    public let data: Register
}

public extension RegisterResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCode = try container.decode(Int16.self, forKey: .resultCode)
        resultMessage = try container.decode(String.self, forKey: .resultMessage)
        data = try container.decode(Register.self, forKey: .data)
    }
}
