//
//  Style.swift
//  UIComponent
//
//  Created by Duc Ngo on 6/11/18.
//

import Foundation
public struct Color {
    public let hexString: String
    public static var white:Color{
        return Color(hexString: "#ffffff")
    }
    public static var black:Color{
        return Color(hexString: "#000000")
    }
}
