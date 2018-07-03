////  ContainerRow.swift
//  UIComponent
//
//  Created by labs01 on 7/2/18.
//  Copyright © LabianLabs 2015
//

import Foundation

class ContainerRender:BaseComponentRenderable<Int>{
    public var container:ComponentContainer
    
    public init(state: Int, container: ComponentContainer) {
        self.container = container
        super.init(state: state)
    }
    
    override func render(_ state: Int) -> ComponentContainer {
        return self.container
    }
}

public class ContainerCell:Cell<Int>, CellType{
    private var container: EmptyViewComponent
    private var containerRender: ContainerRender?
    private var renderView:RenderView?
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.container = EmptyViewComponent(){$0.layout = {c, v in v.loFillInParent()}}
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.container = EmptyViewComponent(){$0.layout = {c, v in v.loFillInParent()}}
        super.init(coder: aDecoder)
    }

    public override func setup() {
        self.containerRender = ContainerRender(state:1, container:self.container)
        self.container.children = (self.row as! ContainerRow).children
        self.renderView = RenderView(container: self.containerRender!)
        self.contentView.addSubview(self.renderView!.view)
        self.renderView!.view.loFillInParent()    }
    
    public override func update() {
        self.container.children = (self.row as! ContainerRow).children
        containerRender?.update(animated: false) {
            self.containerRender?.state = 0
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
}

public final class ContainerRow:Row<ContainerCell>, RowType{
    public var children:Children = Children()
    
    public override func update(from row: BaseRowType) {
        guard let containerRow = row as? ContainerRow else {return}
        super.update(from: row)
        self.children = containerRow.children
    }
}
