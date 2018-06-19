//
//  FormComponentRender.swift
//  UIComponent
//
//  Created by Duc Ngo on 6/11/18.
//

import Foundation
import UIKit
import Eureka

extension FormComponent: UIKitRenderable{
    
    var hostController: UIViewController?{
        return host as? UIViewController
    }
    
    public convenience init(_ host: UIViewController,_ initializer: (FormComponent)->Void = {_ in}) {
        self.init(nil, host, initializer)
    }
    
    public convenience init(_ tag: String? = nil,_ host: UIViewController,_ initializer: (FormComponent)->Void = {_ in}) {
        self.init(tag)
        self.host = host
        initializer(self)
    }
    
    public func renderUIKit() -> UIKitRenderTree {
        guard let host = hostController else { return .leaf(self, UIView())}
        let formController = CustomFormViewController()
        formController.component = self
        host.addChildViewController(formController)
        formController.didMove(toParentViewController: host)
        self.applyBaseAttributes(to: formController.view)        
        self.render?(formController.form)
        return .leaf(self, formController.view)
    }
    
    public func updateUIKit(_ view: UIView, change: Changes, newComponent: UIKitRenderable, renderTree: UIKitRenderTree) -> UIKitRenderTree {
        guard let host = hostController else { fatalError()}
        guard let formComponent = newComponent as? FormComponent else {fatalError()}
        guard let formController = host.childViewControllers.compactMap({return ($0 is CustomFormViewController) ? $0 : nil }).first as? CustomFormViewController else {fatalError()}
        updateFormComponent(with: formComponent)
        formController.updateInfiniteScrollState()
        return .leaf(self, formController.view)
    }
    
    public func autoLayout(view: UIView) {
        if let layout = self.layout{
            layout(self, view)
        } else {
            view.loFillInParent()
        }
    }
}

extension FormComponent{
    func updateFormComponent(with newComponent:FormComponent){
        guard let host = hostController else { fatalError()}
        guard let oldFormController = host.childViewControllers.compactMap({return ($0 is CustomFormViewController) ? $0 : nil }).first as? CustomFormViewController else {fatalError()}
        let newFormController = CustomFormViewController()
        newComponent.render?(newFormController.form)
        let oldRows = oldFormController.form.allRows.map({return "\($0.indexPath!.section)-\($0.indexPath!.row)"})
        let newRows = newFormController.form.allRows.map({return "\($0.indexPath!.section)-\($0.indexPath!.row)"})
        let oldSections = oldFormController.form.allSections.map({return "\($0.index!)"})
        let newSections = newFormController.form.allSections.map({return "\($0.index!)"})
        
        let diffRows = oldRows.diff(newRows)
        let diffSections = oldSections.diff(newSections)
        
        var insertedRows:[String:[String]] = [:]
        var deletedRows:[String:[String]] = [:]
        var updatedRows:[String:Bool] = [:]
        
        var deletedSections:[String] = [String]()
        var updatedSections:[String:Bool] = [:]
        
        oldFormController.form.allRows.forEach { row in
            updatedRows["\(row.indexPath!.section)-\(row.indexPath!.row)"] = true
        }
        oldFormController.form.allSections.forEach { section in
            updatedSections["\(section.index!)"] = true
        }
        
        diffRows.results.forEach{ diffStep in
            switch diffStep{
                case let .insert(_, id):
                    let indexes = id.split(separator: "-").map({return String($0)})
                    if insertedRows[indexes[0]] == nil{
                        insertedRows[indexes[0]] = [String]()
                    }
                    insertedRows[indexes[0]]?.append(indexes[1])
                break
                case let .delete(_, id):
                    let indexes = id.split(separator: "-").map({return String($0)})
                    if insertedRows[indexes[0]] == nil{
                        insertedRows[indexes[0]] = [String]()
                    }
                    if deletedRows[indexes[0]] == nil{
                        deletedRows[indexes[0]] = [String]()
                    }
                    deletedRows[indexes[0]]?.append(indexes[1])
                    updatedRows.removeValue(forKey: id)
                break
            }
        }
        
        diffSections.results.forEach { (diffStep) in
             switch diffStep{
                case let .delete(_, id):
                    deletedSections.append(id)
                    updatedSections.removeValue(forKey: "\(id)")
                break
                default:
                break
            }
        }
        
        migrateDeletionRows(to: oldFormController.form, deletedIndexes: deletedRows)
        migrateInsertionRows(from: newFormController.form, to: oldFormController.form, insertedRows: insertedRows)
        migrateUpdationRows(to: oldFormController.form, updatedIndexes: updatedRows)
        migrateUpdationSections(to: oldFormController.form, updatedSections: updatedSections)
        migrateDeletionSections(to: oldFormController.form, deletedSections: deletedSections)
        oldFormController.stopPullToRefresh()
    }
    
    func migrateUpdationSections(to originalForm:Form, updatedSections:[String:Bool]){
        let indexes = updatedSections.keys.map({return Int($0)})
        for idx in indexes{
            originalForm.allSections[idx!].reload()
        }
    }
    
    func migrateDeletionSections(to originalForm:Form, deletedSections:[String]){
        var updatedForm = originalForm
        let indexes = deletedSections.map({return Int($0)}).sorted(by: {l,r in return l! > r!})
        for section in indexes{
            updatedForm.remove(at: section!)
        }
        
    }
    
    func migrateDeletionRows(to originalForm:Form, deletedIndexes:[String:[String]]){
        for sectionIdx in deletedIndexes.keys{
            let isection = Int(sectionIdx)!
            if let irows = deletedIndexes[sectionIdx]?.map({ return $0 }).map({return Int($0)}).sorted(by: {l,r in return l! > r!}){
                for row in irows{
                    originalForm.allSections[isection].remove(at: row!)
                }
            }
        }
    }
    
    func migrateUpdationRows(to originalForm:Form, updatedIndexes:[String:Bool]){
        for key in updatedIndexes.keys{
            let indexes = key.split(separator: "-").map({return Int($0)})
            let row = originalForm.allRows[indexes[0]! + indexes[1]!]
            row.reload()
        }
    }
    
    func migrateInsertionRows(from updatedForm:Form, to originalForm:Form, insertedRows:[String:[String]]){
        var immutOriginalForm = originalForm
        for sectionIdx in insertedRows.keys{
            let isection = Int(sectionIdx)!
            if isection >= originalForm.allSections.count{
                let section = updatedForm.allSections[isection]
                immutOriginalForm.insert(section, at: isection)
            } else{
                var section = originalForm.allSections[isection]
                for rowIdx in insertedRows[sectionIdx]!{
                    let irow = Int(rowIdx)!
                    section.insert(updatedForm.allRows[isection + irow], at: irow)
                }
            }
        }
    }
}

class CustomFormViewController:FormViewController{
    weak var component:FormComponent?
    weak var spinnerControl:UIActivityIndicatorView?
    weak var refreshControl:UIRefreshControl?
    
    public var isPullToRefreshEnabled:Bool{
        if let c = component{
            return c.isPullToRefreshEnabled
        }
        return true
    }
    
    public var isInfiniteScrollEnabled:Bool{
        if let c = component{
            return c.isInfiniteScrollEnabled
        }
        return true
    }
    
    var hasMoreItems:Bool{
        if let c = component{
            return c.hasMoreItems
        }
        return false
    }
    
    public func updateInfiniteScrollState(){
        if tableView.contentSize.height <= tableView.frame.size.height || !hasMoreItems{
            self.spinnerControl?.stopAnimating()
        }else{
            self.spinnerControl?.startAnimating()
        }
    }
    
    func stopPullToRefresh(){
        self.refreshControl?.endRefreshing()
    }
    
    func enablePullToRefresh(enabled:Bool=true){
        if enabled{
            self.refreshControl?.removeFromSuperview()
        }else{
            if let control = self.refreshControl{
                self.tableView.addSubview(control)
            }
        }
    }
    
    func enableInfiniteScroll(enabled:Bool=true){
        if enabled{
            self.tableView.tableFooterView = self.spinnerControl
            updateInfiniteScrollState()
        }else{
            self.tableView.tableFooterView = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 44)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        
        if isPullToRefreshEnabled{
            self.tableView.addSubview(refreshControl)
        }
        if isInfiniteScrollEnabled{
            self.tableView.tableFooterView = spinner;
        }
        self.spinnerControl = spinner
        self.refreshControl = refreshControl
        self.forceInlineTableLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateInfiniteScrollState()
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){        
        if ((indexPath.row + 1) * (indexPath.section + 1) == self.form.allRows.count) {
            self.component?.callbackOnInfiniteScroll?()
        }
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    
//    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        self.forceInlineTableLayout()
    }
    
    @objc func handleRefresh(){
        self.component?.callbackOnRefresh?()
    }
    
    private func forceInlineTableLayout(){
        DispatchQueue.main.async {
            UIView.setAnimationsEnabled(false)
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
}
