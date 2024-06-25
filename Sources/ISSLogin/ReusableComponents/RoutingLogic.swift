//
//  RoutingLogic.swift
//
//
//  Copyright by iSoftStone 2024.
//

import Foundation

protocol RoutingLogic {
    associatedtype Destination
    func navigate(to destination: Destination)
}
