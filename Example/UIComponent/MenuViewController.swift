//
//  ViewController.swift
//  UIComponent
//
//  Created by labs01 on 06/09/2018.
//  Copyright (c) 2018 LabianLabs. All rights reserved.
//

import UIKit
import UIComponent

class MenuViewController: UITableViewController {
    weak var menuContainer:MenuContainer?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            case 0:
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BasicComponentViewController")
                self.navigationController?.pushViewController(vc, animated: true)

                break
            case 1:
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DynamicFormViewController")
                self.navigationController?.pushViewController(vc, animated: true)
                break
            case 2:
                let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FormTableViewController")
                self.navigationController?.pushViewController(vc, animated: true)
                break
            default:
                break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        let menuContainer = MenuContainer(controller: self, state: 0)
//        menuContainer.onMenuSelected = { menu in
//            switch menu {
//                case .basicComponents:
//                    let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BasicComponentViewController")
//                    self.navigationController?.pushViewController(vc, animated: true)
//                break
//                case .dynamicForm:
//                    let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DynamicFormViewController")
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    break
//                default:
//                    let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FormTableViewController")
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    break
//            }
//        }
//        RenderView.render(container: menuContainer, in: self)
//        self.menuContainer = menuContainer
    }
}

