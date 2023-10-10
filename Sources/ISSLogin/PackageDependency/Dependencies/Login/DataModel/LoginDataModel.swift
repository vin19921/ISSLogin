//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 05/10/2023.
//

public struct LoginToken: Codable {
    public let appToken: String?
    public let exp: String?
    
    enum CodingKeys: String, CodingKey {
        case appToken
        case exp
    }
}

public extension LoginToken {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        appToken = try? container.decode(String.self, forKey: .appToken)
        exp = try? container.decode(String.self, forKey: .exp)
    }
}

public struct LoginDataModel: Codable {
    public let id: String?
    public let name: String?
    public let email: String?
    public let state: String?
    public let city: String?
    public let mobileNo: String?
    public let status: Int16?
    public let isMerchant: Bool?
    public let isCustomer: Bool?
    public let isDraft: Bool?
    public let isCompleteRegister: Bool?
    public let token: LoginToken

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
        case token
    }
}

public struct LoginResponse: Codable {
    public let resultCode: Int16?
    public let resultMessage: String?
    public let status: Bool?
    public let data: LoginDataModel
}

public extension LoginResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCode = try? container.decode(Int16.self, forKey: .resultCode) ?? 0
        resultMessage = try? container.decode(String.self, forKey: .resultMessage) ?? ""
        status = try? container.decodeIfPresent(Bool.self, forKey: .status) ?? false
        data = try container.decode(LoginDataModel.self, forKey: .data)
    }
}
