//
//  File.swift
//  
//
//  Created by Wing Seng Chew on 07/05/2024.
//

public protocol TimeFrameListResponseDataModel {
    var resultCode: Int16 { get }
    var resultMessage: String { get }
    var status: Int16 { get }
}

