//
//  MenuTableViewController.swift
//  EasyBook
//
//  Created by yuh on 2/25/17.
//  Copyright © 2017 yuh. All rights reserved.
//

import UIKit
class MenuTableViewCell: UITableViewCell
{
    
}
class MenuTableViewController: UITableViewController
{

    let test = ["The Grapes of Wrath","For Whom the Bell Tolls","As I Lay Dying","No Country for Old men"]
    let data = ["11/04/1928","01/14/2017","06/05/2018","11/11/1111"]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


}
