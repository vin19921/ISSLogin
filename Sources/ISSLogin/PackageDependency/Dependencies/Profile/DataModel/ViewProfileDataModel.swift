//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 17/10/2023.
//

public struct ViewProfileDataModel: Codable {
    public let user: ViewProfileUserDataModel?

    enum CodingKeys: String, CodingKey {
        case user
    }
}

public extension ViewProfileDataModel {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try? container.decode(ViewProfileUserDataModel.self, forKey: .user)
    }
}


public struct ViewProfileUserDataModel: Codable {
    public let id: String?
    public let name: String?
    public let email: String?
    public let mobileNo: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case mobileNo
    }
}

public extension ViewProfileUserDataModel {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        mobileNo = try container.decodeIfPresent(String.self, forKey: .mobileNo) ?? ""
    }
}


public struct ViewProfileResponse: Codable {
    public let resultCode: Int16?
    public let resultMessage: String?
    public let status: Int16?
    public let data: ViewProfileDataModel
}

public extension ViewProfileResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        resultCode = try? container.decode(Int16.self, forKey: .resultCode)
        resultMessage = try? container.decode(String.self, forKey: .resultMessage)
        status = try? container.decodeIfPresent(Int16.self, forKey: .status) ?? 0
        data = try container.decode(ViewProfileDataModel.self, forKey: .data)
    }
}

