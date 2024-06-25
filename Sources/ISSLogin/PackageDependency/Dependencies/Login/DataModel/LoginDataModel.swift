//
//  LoginDataModel.swift
//
//
//  Copyright by iSoftStone 2024.
//

public protocol LoginResponseDataModel {
    var resultCode: Int16 { get }
    var resultMessage: String { get }
    var status: Int16 { get }
    var data: LoginDataModel? { get }
}

public protocol LoginDataModel {
    var login: LoginDetailsDataModel? { get }
    var token: LoginTokenDataModel? { get }
}

public protocol LoginDetailsDataModel {
    var id: String { get }
    var name: String { get }
    var email: String { get }
    var state: String { get }
    var city: String { get }
    var mobileNo: String { get }
    var status: Int16 { get }
    var isMerchant: Int16 { get }
    var isCustomer: Int16 { get }
    var isDraft: Int16 { get }
    var isCompleteRegister: Int16 { get }
    var userType: Int16 { get }
}

public protocol LoginTokenDataModel {
    var appToken: String { get }
    var exp: Int { get }
    var refreshToken: String { get }
}

//public struct LoginToken: Codable {
//    public let appToken: String?
//    public let exp: Int?
//    public let refreshToken: String?
//
//    enum CodingKeys: String, CodingKey {
//        case appToken
//        case exp
//        case refreshToken
//    }
//}
//
//public extension LoginToken {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        appToken = try? container.decode(String.self, forKey: .appToken)
//        exp = try? container.decode(Int.self, forKey: .exp)
//        refreshToken = try? container.decode(String.self, forKey: .refreshToken)
//    }
//}
//
//public struct LoginDataModel: Codable {
//    public let id: String?
//    public let name: String?
//    public let email: String?
//    public let state: String?
//    public let city: String?
//    public let mobileNo: String?
//    public let status: Int16?
//    public let isMerchant: Int16?
//    public let isCustomer: Int16?
//    public let isDraft: Int16?
//    public let isCompleteRegister: Int16?
//    public let token: LoginToken?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case email
//        case state
//        case city
//        case mobileNo
//        case status
//        case isMerchant
//        case isCustomer
//        case isDraft
//        case isCompleteRegister
//        case token
//    }
//}
//
//public extension LoginDataModel {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try? container.decode(String.self, forKey: .id)
//        name = try? container.decode(String.self, forKey: .name)
//        email = try? container.decode(String.self, forKey: .email)
//        state = try? container.decode(String.self, forKey: .state)
//        city = try? container.decode(String.self, forKey: .city)
//        mobileNo = try? container.decode(String.self, forKey: .mobileNo)
//        status = try? container.decode(Int16.self, forKey: .status)
//        isMerchant = try? container.decode(Int16.self, forKey: .isMerchant)
//        isCustomer = try? container.decode(Int16.self, forKey: .isCustomer)
//        isDraft = try? container.decode(Int16.self, forKey: .isDraft)
//        isCompleteRegister = try? container.decode(Int16.self, forKey: .isCompleteRegister)
//        token = try? container.decode(LoginToken.self, forKey: .token)
//    }
//}
//
//public struct LoginResponse: Codable {
//    public let resultCode: Int16?
//    public let resultMessage: String?
//    public let status: Int16?
//    public let data: LoginDataModel
//}
//
//public extension LoginResponse {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        resultCode = try? container.decode(Int16.self, forKey: .resultCode)
//        resultMessage = try? container.decode(String.self, forKey: .resultMessage)
//        status = try? container.decodeIfPresent(Int16.self, forKey: .status) ?? 0
//        data = try container.decode(LoginDataModel.self, forKey: .data)
//    }
//}
