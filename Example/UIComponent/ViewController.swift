//
//  ViewController.swift
//  UIComponent
//
//  Created by labs01 on 06/09/2018.
//  Copyright (c) 2018 LabianLabs. All rights reserved.
//

import UIKit
import UIComponent

class ViewController: UIViewController {
    var menuContainer:MenuContainer!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.menuContainer = MenuContainer(controller: self, state: 0)
        self.menuContainer.onMenuSelected = { menu in
            switch menu {
                case .basicComponents:
                    break
                case .dynamicForm:
                    let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DynamicFormViewController")
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                default:
                    let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FormTableViewController")
                    self.navigationController?.pushViewController(vc, animated: true)                    
                    break
            }
        }
        RenderView.render(container: menuContainer, in: self)
    }
}

