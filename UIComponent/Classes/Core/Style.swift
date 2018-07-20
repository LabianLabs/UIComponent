//
//  Style.swift
//  UIComponent
//
//  Created by labs01 on 6/11/18.
//

import Foundation
public struct Color {
    public let hexString: String
    
    public init(hex:String){
        self.hexString = hex
    }
    
    public static var defaultColor:Color{
        return Color(hex: "#")
    }
    
    public static var white:Color{
        return Color(hex: "#ffffff")
    }
    public static var black:Color{
        return Color(hex: "#000000")
    }
    public static var silver:Color{
        return Color(hex: "#C0C0C0")
    }
    public static var gray:Color{
        return Color(hex: "#808080")
    }
    public static var red:Color{
        return Color(hex: "#FF0000")
    }
    public static var maroon:Color{
        return Color(hex: "#800000")
    }
    public static var yellow:Color{
        return Color(hex: "#FFFF00")
    }
    public static var olive:Color{
        return Color(hex: "#808000")
    }
    public static var lime:Color{
        return Color(hex: "#00FF00")
    }
    public static var green:Color{
        return Color(hex: "#008000")
    }
    public static var aqua:Color{
        return Color(hex: "#00FFFF")
    }
    public static var teal:Color{
        return Color(hex: "#008080")
    }
    public static var blue:Color{
        return Color(hex: "#0066FF")
    }
    public static var navy:Color{
        return Color(hex: "#000080")
    }
    public static var fuchsia:Color{
        return Color(hex: "#FF00FF")
    }
    public static var purple:Color{
        return Color(hex: "#800080")
    }
    public static var transparent:Color{
        return Color(hex: "#00FFFFFF")
    }
    
}
