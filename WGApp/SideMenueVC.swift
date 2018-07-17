//
//  SideMenueVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 27.05.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class SideMenueVC: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        switch indexPath.row {
        case 0:
            NotificationCenter.default.post(name: NSNotification.Name("ShowUserManagement"), object: nil)
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name("ShowBusManagement"), object: nil)
        case 3:
            NotificationCenter.default.post(name: NSNotification.Name("ShowPutzManagement"), object: nil)
        case 4:
            NotificationCenter.default.post(name: NSNotification.Name("ShowPutzPlan"), object: nil)
        default:
            break
        }
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }

}
