//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 17/10/2023.
//

public struct ViewProfileDataModel: Codable {
    public let id: String?
    public let name: String?
    public let email: String?
    public let state: String?
    public let city: String?
    public let mobileNo: String?
    public let status: Int16?
    public let isMerchant: Int16?
    public let isCustomer: Int16?
    public let isDraft: Int16?
    public let isCompleteRegister: Int16?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case state
        case city
        case mobileNo
        case status
        case isMerchant
        case isCustomer
        case isDraft
        case isCompleteRegister
    }
}

public struct ViewProfileResponse: Codable {
    public let resultCode: Int16?
    public let resultMessage: String?
    public let status: Int16?
    public let data: ViewProfileDataModel
}

public extension LoginResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCode = try? container.decode(Int16.self, forKey: .resultCode)
        resultMessage = try? container.decode(String.self, forKey: .resultMessage)
        status = try? container.decodeIfPresent(Int16.self, forKey: .status) ?? 0
        data = try container.decode(ViewProfileDataModel.self, forKey: .data)
    }
}

