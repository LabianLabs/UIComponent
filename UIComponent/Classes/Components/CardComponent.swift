////  CardComponent.swift
//  FBSnapshotTestCase
//
//  Created by labs01 on 6/26/18.
//  Copyright © LabianLabs 2015
//

import Foundation

public final class CardComponent: BaseContainerComponent, ComponentType {
    public var selectionIndex: Int? = 0
    public var callBackOnIndexChanged: ((Any?)->Void)?
    public func onIndexChanged(selectionIndex index:Int, callback: ((Any?)->Void)?) -> CardComponent{
        self.callBackOnIndexChanged = callback
        return self
    }
}
