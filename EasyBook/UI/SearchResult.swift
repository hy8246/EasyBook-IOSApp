//
//  SearchResult.swift
//  EasyBook
//
//  Created by yuh on 1/28/17.
//  Copyright © 2017 yuh. All rights reserved.
//

import UIKit
class TableViewCell : UITableViewCell
{
    
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet var bName: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
}
class SearchResult: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource
{
    
    var booknameArray = [String]()
    var authornameArray = [String]()
    var statusArray = [String]()
    var bookholderArray = [String]()
    var dateholderArray = [String]()
    var DH =  DataHandler()
    var M = Menu()
    @IBOutlet weak var resultTable: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        M.booknameArray.removeAll()
        M.dateArrary.removeAll()
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return booknameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell:TableViewCell = tableView.dequeueReusableCell(withIdentifier: "resultcell", for: indexPath) as! TableViewCell
        cell.bName.text = booknameArray[indexPath.row]
        cell.authorName.text = authornameArray[indexPath.row]
        cell.status.text = statusArray[indexPath.row]
        
        if (cell.status.text == "Out of stock")
        {
            cell.status.textColor = UIColor.red
        }
        if (cell.status.text == "In stock")
        {
            cell.status.textColor = UIColor.green
        }
       
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    @IBAction func newSearchBTN(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ns = storyboard.instantiateViewController(withIdentifier: "Search") as! Search
        ns.menubookArray.removeAll()
        ns.menudateArray.removeAll()
        ns.menubookArray = bookholderArray
        ns.menudateArray = dateholderArray
        
        self.show(ns, sender: nil)

    }
    @IBAction func rentBTN(_ sender: Any)
    {
        print("here"+DH.getEmail())
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ns = storyboard.instantiateViewController(withIdentifier: "Menu") as! Menu
        ns.booknameArray = bookholderArray
        ns.dateArrary = dateholderArray
        print("here"+DH.getEmail())
        self.present(ns, animated: true, completion: nil)
        //self.present(ns, animated: nil)
    }

   
}
