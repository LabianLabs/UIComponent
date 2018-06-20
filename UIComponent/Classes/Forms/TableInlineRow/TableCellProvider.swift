//
//  TableCellProvider.swift
//  UIComponent
//
//  Created by labs01 on 6/19/18.
//

import Foundation

public struct TableCellProvider{
    
    /// Nibname of the cell that will be created.
    public private (set) var nibName: String?
    
    /// Bundle from which to get the nib file.
    public private (set) var bundle: Bundle!
    
    public init() {}
    
    public init(nibName: String, bundle: Bundle? = nil) {
        self.nibName = nibName
        self.bundle = bundle ?? Bundle.main
    }
    
    /**
     Creates the cell with the specified style.
     
     - parameter cellStyle: The style with which the cell will be created.
     
     - returns: the cell
     */
    func makeCell(style: UITableViewCellStyle) -> BaseCell {
        if let nibName = self.nibName {
            return bundle.loadNibNamed(nibName, owner: nil, options: nil)!.first as! BaseCell
        }
        return BaseCell.init(style: style, reuseIdentifier: nil)
    }
}
