//
//  SecondViewController.swift
//  photo-app
//
//  Created by David Ng on 14/9/2017.
//  Copyright © 2017 Skygear. All rights reserved.
//

import UIKit
import SKYKit

class SecondViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshView()
    }

    func refreshView() {
        if (SKYContainer.default().auth.currentUser != nil) {
            self.tableView.isHidden = false
        } else {
                self.tableView.isHidden = true
        }
        
    }

}

