//
//  IntrinsicContentSizeTableView.swift
//  TableRow
//
//  Created by Anton Kovtun on 18.03.18.
//  Copyright © 2018 Anton Kovtun. All rights reserved.
//

import UIKit

final class IntrinsicSizeTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }
    
    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }
}
