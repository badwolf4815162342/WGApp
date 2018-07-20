//
//  SideMenueVC.swift
//  WGApp
//
//  Created by Viviane Rehor on 27.05.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class SideMenueVC: UITableViewController {
    
    @IBOutlet weak var userCell: UITableViewCell!
    @IBOutlet weak var busCell: UITableViewCell!
    @IBOutlet weak var moneyCell: UITableViewCell!
    @IBOutlet weak var cleanCell: UITableViewCell!
    @IBOutlet weak var calendarCell: UITableViewCell!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userCell.selectionStyle = .none
        busCell.selectionStyle = .none
        moneyCell.selectionStyle = .none
        cleanCell.selectionStyle = .none
        calendarCell.selectionStyle = .none
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            NotificationCenter.default.post(name: NSNotification.Name("ShowUserManagement"), object: nil)
        case 1:
            NotificationCenter.default.post(name: NSNotification.Name("ShowBusManagement"), object: nil)
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name("ShowMoneyManagement"), object: nil)
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
