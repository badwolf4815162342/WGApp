//
//  UserEditVC.swift
//  WGApp
//
//  Created by Anna Abad on 11.06.18.
//  Copyright © 2018 Viviane Rehor. All rights reserved.
//

import UIKit

class UserEditVC: UIViewController {
    
    var user: User!

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var mail: UITextField!
    @IBOutlet weak var icon: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = user.name
        mail.text = user.mail
        
        NotificationCenter.default.addObserver(self, selector: #selector(showUser), name: NSNotification.Name("BackToUserMsg"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func save(_ sender: Any) {
        var changed = false
        if name.text != user.name && name.text != ""{
            user.name = name.text
            changed = true
        }
        if mail.text != user.mail && mail.text != ""{
            user.mail = mail.text
            changed = true
        }
        if changed{
            PersistenceService.saveContext()
        }
        NotificationCenter.default.post(name: NSNotification.Name("BackToUserMsg"), object: nil)
    }
    
    @objc func showUser(notification: NSNotification) {
        performSegue(withIdentifier: "BackToUser", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackToUser" {
            if let destinationVC = segue.destination as? SingleUserVC {
                destinationVC.user = self.user
            }
        }
    }
    
}
