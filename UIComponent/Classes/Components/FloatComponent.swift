////  FloatComponent.swift
//  FBSnapshotTestCase
//
//  Created by labs01 on 6/22/18.
//  Copyright © LabianLabs 2015
//

import Foundation
public final class FloatComponent<T:Initializable>: BaseComponent, ComponentType{
    public var nibFile:String?
    public var render:((T)->Void)?
    public required init(_ tag: String? = nil){
        //self.nibFile = String(describing: T.self)
        super.init(tag)
    }
}
