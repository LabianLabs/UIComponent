//
//  Style.swift
//  UIComponent
//
//  Created by labs01 on 6/11/18.
//

import Foundation
public struct Color {
    public let hexString: String
    
    public static var defaultColor:Color{
        return Color(hexString: "#")
    }
    
    public static var white:Color{
        return Color(hexString: "#ffffff")
    }
    public static var black:Color{
        return Color(hexString: "#000000")
    }
    public static var silver:Color{
        return Color(hexString: "#C0C0C0")
    }
    public static var gray:Color{
        return Color(hexString: "#808080")
    }
    public static var red:Color{
        return Color(hexString: "#FF0000")
    }
    public static var maroon:Color{
        return Color(hexString: "#800000")
    }
    public static var yellow:Color{
        return Color(hexString: "#FFFF00")
    }
    public static var olive:Color{
        return Color(hexString: "#808000")
    }
    public static var lime:Color{
        return Color(hexString: "#00FF00")
    }
    public static var green:Color{
        return Color(hexString: "#008000")
    }
    public static var aqua:Color{
        return Color(hexString: "#00FFFF")
    }
    public static var teal:Color{
        return Color(hexString: "#008080")
    }
    public static var blue:Color{
        return Color(hexString: "#0066FF")
    }
    public static var navy:Color{
        return Color(hexString: "#000080")
    }
    public static var fuchsia:Color{
        return Color(hexString: "#FF00FF")
    }
    public static var purple:Color{
        return Color(hexString: "#800080")
    }
    public static var transparent:Color{
        return Color(hexString: "#00FFFFFF")
    }
    
}
