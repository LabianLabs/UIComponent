//
//  UIViewLayout.swift
//  UIComponent
//
//  Created by labs01 on 6/11/18.
//

import Foundation
import UIKit

extension UIView:Initializable /*Core*/{
    
}

extension UIView /*AutoLayout*/{
    @discardableResult
    public func loHeightInParent(_ percentage:CGFloat = 1.0)->UIView{
        self.loBelowOf(self.superview!).loHeightWithParent(percentage)
        return self
    }
    
    @discardableResult
    public func loBellow(_ view: UIView)->UIView{
        constrain(self, view){ v1, v2 in
            v1.top == v2.bottom
            v1.left == v1.superview!.left
            v1.width == v1.superview!.width
            v1.bottom == v1.superview!.bottom
        }
        return self
    }
    
    //PADDING
    @discardableResult
    public func loTopPadding(_ topPadding: CGFloat = 0)->UIView{
        constrain(self){ v in
            v.top == v.superview!.top + topPadding
        }
        return self
    }
    
    @discardableResult
    public func loLeftPadding(_ leftPadding: CGFloat = 0)->UIView{
        constrain(self){ v in
            v.left == v.superview!.left + leftPadding
        }
        return self
    }
    
    @discardableResult
    public func loRightPadding(_ rightPadding: CGFloat = 0)->UIView{
        constrain(self){ v in
            v.right == v.superview!.right - rightPadding
        }
        return self
    }
    
    @discardableResult
    public func loBottomPadding(_ bottomPadding: CGFloat = 0)->UIView{
        constrain(self){ v in
            v.bottom == v.superview!.bottom - bottomPadding
        }
        return self
    }
    
    @discardableResult
    public func loPaddingWithParent(left:CGFloat = 0,right:CGFloat = 0,
                                    top: CGFloat = 0,bottom: CGFloat = 0)->UIView{
        constrain(self) { v in
            v.top == v.superview!.top + top
            v.left == v.superview!.left + left
            v.right == v.superview!.right - right
            v.bottom == v.superview!.bottom - bottom
        }
        return self
    }
    
    //FILL IN PARENT
    @discardableResult
    public func loFillInParent()->UIView{
        self.loPaddingWithParent()
        return self
    }
    
    @discardableResult
    public func loFillInParent(_ height: CGFloat)->UIView{
        self.loFillInParent().loHeight(height)
        return self
    }
    
    //BELOW OF
    
    @discardableResult
    public func loBelowOf(_ view:UIView)->UIView{
        constrain(self,view){ v1,v2 in
            v1.top == v2.bottom
            v1.left == v2.left
            v1.right == v2.right
        }
        return self
    }
    
    @discardableResult
    public func loBellowOf(_ view: UIView,with height: CGFloat)->UIView{
        self.loBelowOf(view).loHeight(height)
        return self
    }
    
    
    @discardableResult
    public func loBellowStatusBar()->UIView{
        let statusHeight = UIApplication.shared.statusBarFrame.height
        self.loPaddingWithParent(left: 0, right: 0, top: statusHeight, bottom: 0)
        return self
    }
    
    //RIGHT OF
    
    @discardableResult
    public func loRightOf(_ view:UIView)->UIView{
        constrain(self,view){ v1,v2 in
            v1.top == v2.top
            v1.left == v2.right
            v1.bottom == v2.bottom
        }
        return self
    }
    
    @discardableResult
    public func loRightOf(_ view: UIView,with width: CGFloat)->UIView{
        self.loRightOf(view).loWidth(width)
        return self
    }
    
    //CENTER OF
    
    @discardableResult
    public func loCenterOfParent()->UIView{
        constrain(self){ v in
            v.center == v.superview!.center
        }
        return self
    }
    
    @discardableResult
    public func loCenterOfParent(with widthPercentage: CGFloat = 1.0,
                                 _ heightPercentage: CGFloat = 1.0)->UIView{
        self.loSizeWithParent().loCenterOfParent()
        return self
    }
    
    //LAYOUT SIZE
    
    @discardableResult
    public func loHeight(_ height:CGFloat)->UIView{
        constrain(self){ v in v.height == height }
        return self
    }
    
    @discardableResult
    public func loWidth(_ width:CGFloat)->UIView{
        constrain(self){ v in v.width == width }
        return self
    }
    
    @discardableResult
    public func loWidthWithParent(_ widthPercentage:CGFloat = 1.0)->UIView{
        constrain(self){ v in
            v.width == v.superview!.width * widthPercentage
        }
        return self
    }
    
    @discardableResult
    public func loHeightWithParent(_ heightPercentage:CGFloat = 1.0)->UIView{
        constrain(self){ v in
            v.height == v.superview!.height * heightPercentage
        }
        return self
    }
    
    @discardableResult
    public func loSize( width:CGFloat,height: CGFloat)->UIView{
        self.loHeight(height).loWidth(width)
        return self
    }
    
    @discardableResult
    public func loSizeWithParent(with widthPercentage: CGFloat = 1.0,
                                 _ heightPercentage: CGFloat = 1.0)->UIView{
        self.loWidthWithParent(widthPercentage).loHeightWithParent(heightPercentage)
        return self
    }
    
    //VISIBLE AREA
    
    @discardableResult
    public func loSafeAreaFrame()->UIView{
        if #available(iOS 11.0, *) {
            let height = UIApplication.shared.keyWindow!.safeAreaLayoutGuide.layoutFrame.height
            let width = UIApplication.shared.keyWindow!.safeAreaLayoutGuide.layoutFrame.width
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            self.loTopPadding(statusBarHeight).loLeftPadding().loSize(width: width,height: height)
        } else {
            self.loBellowStatusBar()
        }
        return self
    }
    
    @discardableResult
    public func loFillInVisibleArea(topBarHeight: CGFloat = 0, bottomBarHeight: CGFloat = 0)->UIView{
        if #available(iOS 11.0, *) {
            let height = UIApplication.shared.keyWindow!.safeAreaLayoutGuide.layoutFrame.height
            let width = UIApplication.shared.keyWindow!.safeAreaLayoutGuide.layoutFrame.width
            let statusHeight = UIApplication.shared.statusBarFrame.height
            constrain(self){ v in
                v.top == v.superview!.top + UIApplication.shared.statusBarFrame.height
                v.left == v.superview!.left
                v.width == width
                v.height == height - topBarHeight - statusHeight
            }
        } else {
            self.loBellowStatusBar()
        }
        return self
    }
    
    @discardableResult
    public func loFillSafeArea(embeddedInNavigationBar:Bool=true, embeddedInTabeBar:Bool=false) -> UIView{
        constrain(self){ view in
            if #available(iOS 11.0, *) {
                view.top == view.superview!.safeAreaLayoutGuide.top
                view.bottom == view.superview!.safeAreaLayoutGuide.bottom
            } else {
                var height: CGFloat = 0
                height += UIApplication.shared.statusBarFrame.height
                if embeddedInNavigationBar{
                    height += 44
                }
                view.top == view.superview!.top + height
                if embeddedInTabeBar{
                    view.bottom == view.superview!.bottom - 49 // tabbar height
                }
            }
            view.left == view.superview!.left
            view.width == view.superview!.width
        }
        return self
    }
}
