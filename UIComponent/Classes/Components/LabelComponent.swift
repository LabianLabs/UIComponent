//
//  Label.swift
//  UILib
//
//  Created by Benji Encz on 5/26/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

import Foundation

public final class LabelComponent: BaseComponent, ComponentType, UIKitRenderable {
    public var text: String?
    public var textColor: Color = Color.black
    public var fontSize:CGFloat = 0
    public var fontName:String?
    public var fontStyle:FontStyle = FontStyle.normal
    public var textAlignment:TextAlignment = TextAlignment.left
    public enum TextAlignment{
        case center, left, right
    }
    
    public enum FontStyle{
        case bold, normal
    }
}
