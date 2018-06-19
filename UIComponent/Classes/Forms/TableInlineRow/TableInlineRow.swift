//
//  TableInlineRow.swift
//  TableRow
//
//  Created by Anton Kovtun on 17.03.18.
//  Copyright © 2018 Anton Kovtun. All rights reserved.
//

import Eureka
import UIKit

open class TableInlineCell<T: Equatable>: Cell<T>, CellType {
    private var inlineCell:BaseCell?
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func setup() {
        super.setup()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        accessoryType = .none
        editingAccessoryType =  .none
        
        if let inlineCell = (self.row as? _TableInlineRow)?.inlineCellProvider?.makeCell(style: UITableViewCellStyle.default) as? Cell<T>{
            inlineCell.row = self.row
            inlineCell.setup()
            _ = self.contentView.subviews.map({$0.removeFromSuperview()})
            self.contentView.addSubview(inlineCell.contentView)
            inlineCell.contentView.loFillInParent()
            self.inlineCell = inlineCell
            self.layoutIfNeeded()
            (self.row as? _TableInlineRow)?.callbackOnSetupCell?(inlineCell)
        }
    }
    
    override open func update() {
        super.update()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        selectionStyle = row.isDisabled ? .none : .default
        self.inlineCell?.update()
    }
    
    override open func didSelect() {
        super.didSelect()
        row.deselect()
    }
}

open class _TableInlineRow<T> : Row<TableInlineCell<T>>, NoValueDisplayTextConformance where T: Equatable {
    open var values = [T]()
    
    public var callbackOnSetupCell: ((UITableViewCell) -> Void)?
    public var callbackOnSetupSubCell: ((UITableViewCell, T, Int) -> Void)?
    public var callbackOnSelectItem: ((T) -> Void)?
    
    public var inlineCellProvider:TableCellProvider?
    
    public var inlineSubCellProvider:TableCellProvider?
    
    public var noValueDisplayText: String?
    
    private var subcellConfigurator: (UITableViewCell, T, Int) -> Void = { _, _, _ in }
    
    public required init(tag: String?) {
        super.init(tag: tag)
    }
    
    public func setupInlineRow(_ inlineRow: TableRow<T>) {
        inlineRow.values = values
        inlineRow.callbackOnSetupSubCell = callbackOnSetupSubCell
        inlineRow.callbackOnSelectItem = self.callbackOnSelectItem
        inlineRow.inlineCellProvider = self.inlineSubCellProvider
        inlineRow.value = value
    }
    
    @discardableResult
    open func onSetupSubCell(_ callback: @escaping (UITableViewCell, T, Int) -> Void) -> Self {
        callbackOnSetupSubCell = callback
        return self
    }
}

final public class TableInlineRow<T>: _TableInlineRow<T>, RowType, InlineRowType where T: Equatable {
    
    /// Sets underlying `SelectionListRow` textLabel color
    public var subcellTextColor = UIColor.gray
    /// Sets underlying `SelectionListRow` horizontal insets in it's superview
    public var subcellHorizontalInset: CGFloat = 16
    /// Sets whether row should collapse on option selection, defaults to true
    public var collapseOnInlineRowSelection = true
    
    required public init(tag: String?) {
        super.init(tag: tag)
        onExpandInlineRow { cell, row, _ in
            let color = cell.detailTextLabel?.textColor
            row.onCollapseInlineRow { cell, _, _ in
                cell.detailTextLabel?.textColor = color
            }
            cell.detailTextLabel?.textColor = cell.tintColor
        }
    }
    
    override public func customDidSelect() {
        super.customDidSelect()
        if !isDisabled {
            toggleInlineRow()
        }
    }
    
    override public func setupInlineRow(_ inlineRow: InlineRow) {
        super.setupInlineRow(inlineRow)
//        inlineRow.onDidSelectItem { [weak self] _ in
//            if self?.collapseOnInlineRowSelection ?? true {
//                self?.toggleInlineRow()
//            }
//        }
        inlineRow.textColor = subcellTextColor
        inlineRow.horizontalContentInset = subcellHorizontalInset
    }
    
    /// The block used to configure cells
    @discardableResult
    open func onSetupCell(_ callback: @escaping (UITableViewCell) -> Void) -> TableInlineRow {
        callbackOnSetupCell = callback
        return self
    }
    
    @discardableResult
    open func onDidSelectSubItem(_ callback: @escaping (T) -> Void) -> TableInlineRow {
        callbackOnSelectItem = callback
        return self
    }
    
    /// This block gets called immediately and on `expanded/collapsed` state changes,
    /// setting first parameter `true` if `expanded`
    @discardableResult
    public func onToggleInlineRow(_ callback: @escaping (Bool, TableInlineCell<T>, TableInlineRow<T>, InlineRow) -> Void) -> TableInlineRow {
        callback(isExpanded, cell, self, inlineRow ?? InlineRow())
        onExpandInlineRow { callback(true, $0, $1, $2) }
        onCollapseInlineRow { callback(false, $0, $1, $2) }
        return self
    }
}
