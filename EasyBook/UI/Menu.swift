//
//  Menu.swift
//  EasyBook
//
//  Created by yuh on 1/28/17.
//  Copyright © 2017 yuh. All rights reserved.
//

import UIKit
class CustomTableViewCell : UITableViewCell
{
    @IBOutlet weak var dateLabel: UILabel!
    
}
class Menu: UIViewController,UITableViewDelegate,UITableViewDataSource{

    struct book
    {
        var bookname = ""
        
    }
    struct date
    {
        var dates = ""
    }
 
    var booknameArray = [String]()
    var dateArrary = [String]()
    var booklist:Array<book> = []
    var datelist:Array<date> = []

    let DH = DataHandler()
    @IBOutlet weak var table: UITableView!
   
    override func viewDidDisappear(_ animated: Bool) {
       // booknameArray.removeAll()
        //dateArrary.removeAll()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        /*
        let para2 = "email=\(DH.get_email())"
       
        var request2 = URLRequest(url: URL(string: "http://www.easybook2017.com/xcode/returnrentalrecord?\(para2)")!)
        
        
        request2.httpMethod = "GET"
        let task2 = URLSession.shared.dataTask(with: request2)
        {data, response, error in
            if error == nil
            {
                    let responseString2 = String(data: data!, encoding: .utf8)
                    let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                            
                    let testers = String(describing: json)
                    let data: NSData = testers.data(using: String.Encoding.utf8)! as NSData
                            
                    do{
                                // convert NSData to 'AnyObject'
                        let anyObj: Any? = try JSONSerialization.jsonObject(with: data as Data)
                        self.booklist = self.parseJsonBook(anyObj: anyObj as AnyObject)
                        self.datelist = self.parseJsonDate(anyObj: anyObj as AnyObject)
                       
                    }
                    catch
                    {
                        print("Error: \(error)")
                    }
                    // convert 'AnyObject' to Array<Business>
                            
                            
                    let count = self.booklist.count
                            
                    for index in 0..<count
                    {
                                
                        
                                let tempDate = self.datelist[index].dates
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                                let date = dateFormatter.date(from:tempDate)!
                                let calendar = Calendar.current
                                let components = calendar.dateComponents([.year, .month, .day], from: date)
                                let finalDate = calendar.date(from:components)
                                let expiration =  calendar.date(byAdding: .day, value: 31, to: finalDate!)
                                let com = calendar.dateComponents([.year, .month, .day], from: expiration!)
                                let expirationString = "\(com.month!)/\(com.day!)/\(com.year!)"
                                self.dateArrary.append(expirationString)
                                self.booknameArray.append(self.booklist[index].bookname)
                    }
                            
                            print(self.booknameArray)
                            print(self.dateArrary)
                
            }
            else
            {
                print(error)
            }

        }
        task2.resume()
        task2.suspend()
 */
    }
    func parseJsonBook(anyObj:AnyObject) -> Array<book>{
        
        var booklist:Array<book> = []
        
        if  anyObj is Array<AnyObject> {
            
            var b:book = book()
            for json in anyObj as! Array<AnyObject>{
                b.bookname = (json["bookname"] as AnyObject? as? String) ?? "" ;// to get rid of null
                booklist.append(b)
                
                
            }// for
            
        } // if
        
        return booklist
        
    }//func
    func parseJsonDate(anyObj:AnyObject) -> Array<date>{
        
        var datelist:Array<date> = []
        
        if  anyObj is Array<AnyObject> {
            
            var b:date = date()
            for json in anyObj as! Array<AnyObject>{
                b.dates = (json["date"] as AnyObject? as? String) ?? "" ;// to get rid of null
                datelist.append(b)
                
                
            }// for
            
        } // if
        
        return datelist
        
    }//func

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
       // print(booknameArray.count)
        return booknameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        
        let cell:CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.textLabel?.text = booknameArray[indexPath.row]
        cell.dateLabel.text = dateArrary[indexPath.row]
        
        return cell
        
    }
    @IBAction func SearchBTN(_ sender: Any){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ns = storyboard.instantiateViewController(withIdentifier: "Search") as! Search
        ns.menubookArray = booknameArray
        ns.menudateArray = dateArrary
        print("Inside menu : \(booknameArray)")
        print("Inside menu: \(dateArrary)")
        self.show(ns, sender: nil)
    }

    @IBAction func LogoutBTN(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ns = storyboard.instantiateViewController(withIdentifier: "Login")
        self.show(ns, sender: nil)
    }
    @IBAction func RentBTN(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ns = storyboard.instantiateViewController(withIdentifier: "Camera") as! BarcodeViewController
        ns.storageEmail =  "\(DH.get_email())"
        ns.bookholder = booknameArray
        ns.dateholder = dateArrary
        self.show(ns, sender: nil)
        
    }
    

}
