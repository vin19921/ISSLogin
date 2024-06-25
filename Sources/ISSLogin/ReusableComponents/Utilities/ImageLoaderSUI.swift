//
//  ImageLoaderSUI.swift
//
//
//  Copyright by iSoftStone 2024.
//

import SwiftUI

public protocol ImageLoaderSUI: RawRepresentable where RawValue == String {
    var image: Image { get }
    var templateImage: Image? { get }
    var originalImage: Image? { get }
}

public extension ImageLoaderSUI {
    var image: Image {
        return Image(rawValue,
                     bundle: Bundle.resource)
    }

    var templateImage: Image? {
        return Image(rawValue,
                     bundle: Bundle.resource)
            .renderingMode(.template)
    }

    var originalImage: Image? {
        return Image(rawValue,
                     bundle: Bundle.resource)
            .renderingMode(.original)
    }
}
