////  CMTime+Ext.swift
//  FBSnapshotTestCase
//
//  Created by labs01 on 6/29/18.
//  Copyright © LabianLabs 2015
//

import Foundation
import AVKit
import AVFoundation

extension CMTime {
    var asDouble: Double {
        get {
            return Double(self.value) / Double(self.timescale)
        }
    }
    var asFloat: Float {
        get {
            return Float(self.value) / Float(self.timescale)
        }
    }
}

extension CMTime: CustomStringConvertible {
    public var description: String {
        get {
            let seconds = Int(round(self.asDouble))
            return String(format: "%02d:%02d", seconds / 60, seconds % 60)
        }
    }
}
