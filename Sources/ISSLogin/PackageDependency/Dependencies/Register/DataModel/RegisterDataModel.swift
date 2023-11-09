//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 20/09/2023.
//

public struct RegisterDataModel: Codable {
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

public extension RegisterDataModel {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        mobileNo = try container.decodeIfPresent(String.self, forKey: .mobileNo) ?? ""
        isDraft = try container.decodeIfPresent(Int16.self, forKey: .isDraft) ?? 0
        isCompleteRegister = try container.decodeIfPresent(Int16.self, forKey: .isCompleteRegister) ?? 0
    }
}

public struct RegisterResponse: Codable {
    public let resultCode: Int16?
    public let resultMessage: String?
    public let data: RegisterDataModel
}

public extension RegisterResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCode = try container.decode(Int16.self, forKey: .resultCode)
        resultMessage = try container.decode(String.self, forKey: .resultMessage)
        data = try container.decode(RegisterDataModel.self, forKey: .data)
    }
}
