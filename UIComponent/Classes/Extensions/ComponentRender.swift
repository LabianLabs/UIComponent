//
//  ComponentRender.swift
//  UIComponent
//
//  Created by Duc Ngo on 6/12/18.
//

import Foundation
import UIKit
extension BaseComponent{
    func applyBaseAttributes(to view:UIView){
        view.alpha = self.alpha
        view.isHidden = self.isHidden
        view.isUserInteractionEnabled = self.isUserInteractionEnabled
        view.layer.cornerRadius = self.cornerRadius
        if self.borderWidth >= 0{
            view.layer.borderWidth = self.borderWidth
        }
        if let borderColor = self.borderColor{
            view.layer.borderColor = UIColor(rgba: borderColor.hexString).cgColor
        }
        if let bgColor = self.backgroundColor{
            view.backgroundColor = UIColor(rgba: bgColor.hexString)
        }
        if let tintColor = self.tintColor{
            view.tintColor = UIColor(rgba: tintColor.hexString)
        }
    }
}
