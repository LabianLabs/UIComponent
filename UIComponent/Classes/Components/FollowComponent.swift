////  FollowComponent.swift
//  FBSnapshotTestCase
//
//  Created by labs01 on 6/26/18.
//  Copyright © LabianLabs 2015
//

import Foundation

public final class FollowComponent:BaseComponent, ComponentType {
    public var status: Bool = false
    public var backgroundImage: UIImage?
    public var callbackOnFollow: ((Any?)->Void)?
    public var callbackOnUnFollow: ((Any?)->Void)?
    public func onFollow(_ callback: ((Any?)->Void)?)->FollowComponent{
        self.callbackOnFollow = callback
        return self
    }
    public func onUnFollow(_ callback: ((Any?)->Void)?)->FollowComponent{
        self.callbackOnUnFollow = callback
        return self
    }
}
