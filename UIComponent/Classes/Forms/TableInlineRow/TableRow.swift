//
//  TableRow.swift
//  TableRow
//
//  Created by Anton Kovtun on 17.03.18.
//  Copyright © 2018 Anton Kovtun. All rights reserved.
//

import UIKit

open class TableCell<T>: Cell<T>, CellType, UITableViewDelegate, UITableViewDataSource where T: Equatable {
    
    private let tableView = IntrinsicSizeTableView()
    
    private lazy var tableHorizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[table]-0-|", options: [], metrics: nil, views: ["table": tableView])
    private lazy var tableVerticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[table]-0-|", options: [], metrics: nil, views: ["table": tableView])
    
    private var listRow: TableRow<T>? {
        return row as? TableRow<T>
    }
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(tableView)
        self.contentView.addConstraints(tableHorizontalConstraints)
        self.contentView.addConstraints(tableVerticalConstraints)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func setup() {
        super.setup()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        accessoryType = .none
        editingAccessoryType = .none
        if let inset = listRow?.horizontalContentInset {
            tableHorizontalConstraints.forEach { $0.constant = inset }
        }
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        DispatchQueue.main.async {
            self.tableView.invalidateIntrinsicContentSize()
            self.tableView.layoutIfNeeded()
        }
    }
    
    override open func update() {
        super.update()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        self.tableView.reloadData()
    }
    

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = listRow?.values.count ?? 0
        return count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell?
        if let cellProvider = self.listRow?.inlineCellProvider{
            cell = cellProvider.makeCell(style: UITableViewCellStyle.default)
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        }
        listRow?.configure(subCell: cell!, row: indexPath.row)
        cell?.layoutIfNeeded()
        return cell!
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        listRow?.select(at: indexPath.row)
    }
}

open class SubCell<T:Equatable>:Cell<T>{
    public var subValue:T?
}

public final class TableRow<T>: Row<TableCell<T>>, RowType where T: Equatable {
    
    public var values = [T]()
    public var inlineCellProvider:TableCellProvider?
    
    public var callbackOnSetupSubCell: ((UITableViewCell, T, Int) -> Void)?
    
    public var callbackOnSelectItem: ((T) -> Void)?
    
    /// Sets textLabel color
    open var textColor = UIColor.gray
    
    /// Sets horizontal insets
    open var horizontalContentInset: CGFloat = 0
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
    
    fileprivate func select(at index: Int) {
        guard index < values.count else { return }
        callbackOnSelectItem?(values[index])
    }
    
    /// This block gets called on option selection
    @discardableResult
    open func onDidSelectItem(_ callback: @escaping (T) -> Void) -> TableRow {
        callbackOnSelectItem = callback
        return self
    }
    
    @discardableResult
    open func onSetupSubCell(_ callback: @escaping ((UITableViewCell, T, Int) -> Void)) -> TableRow{
        callbackOnSetupSubCell = callback
        return self
    }
    
    fileprivate func configure(subCell: UITableViewCell, row: Int) {
        guard row < values.count else { return }
        if let cell = subCell as? SubCell<T>{
            cell.subValue = values[row]
            cell.setup()
            cell.update()
        }else if self.inlineCellProvider == nil{
            cell.textLabel?.text = displayValueFor?(values[row])
            cell.textLabel?.textColor = textColor
        }
        callbackOnSetupSubCell?(cell, values[row], row)
    }
}
