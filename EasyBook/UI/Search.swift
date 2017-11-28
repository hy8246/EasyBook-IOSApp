//
//  Search.swift
//  EasyBook
//
//  Created by yuh on 1/28/17.
//  Copyright © 2017 yuh. All rights reserved.
//

import UIKit

class Search: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var BookNameOutlet: UITextField!
    @IBOutlet weak var AuthorNameOutlet: UITextField!
    var baseMessage: String?
    var messageObject = Messages ()
    var alertController: UIAlertController?
    var alertTimer: Timer?
    var remainingTime = 0
    var menubookArray = [String]()
    var menudateArray = [String]()
    var booknameArray = [String]()
    var statusArrary = [String]()
    var authorArrary = [String]()
    var booklist:Array<book> = []
    var authorlist:Array<author> = []
    var statuslist:Array<status> = []
    let mygroup = DispatchGroup()
    struct book
    {
        var bookname = ""
        
    }
    struct author
    {
        var authorname = ""
        
    }
    struct status
    {
        var status = true
    }

    override func viewDidDisappear(_ animated: Bool)
    {
        //menubookArray.removeAll()
       // menudateArray.removeAll()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        print(menubookArray)
        print(menudateArray)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func MenuBTN(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ns = storyboard.instantiateViewController(withIdentifier: "Menu") as! Menu
               
        ns.booknameArray = menubookArray
        ns.dateArrary = menudateArray
        
        self.present(ns, animated: true, completion: nil)
        
    }
    @IBAction func SearchBTN(_ sender: Any)
    {
       
        let fixbook = BookNameOutlet.text!.replacingOccurrences(of: " ",with: "%20")
        let fixauthor = AuthorNameOutlet.text!.replacingOccurrences(of: " ",with: "%20")
        if ((BookNameOutlet.text?.isEmpty)! && (AuthorNameOutlet.text?.isEmpty)!)
        {
            searchAlert(title: "Error", message: "You must fill in at least one field", time: 5)
        }
        if (!(BookNameOutlet.text?.isEmpty)! || !(AuthorNameOutlet.text?.isEmpty)!)
        {
            
            ////////////////////////////////////////////////////////////
            let para2 = "bookname=\(fixbook.lowercased())&authorname=\(fixauthor.lowercased())"
            
            var request2 = URLRequest(url: URL(string: "http://www.easybook2017.com/xcode/search?\(para2)")!)
            
            
            request2.httpMethod = "GET"
            let task2 = URLSession.shared.dataTask(with: request2)
            {data, response, error in
                self.mygroup.enter()
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
                            self.authorlist = self.parseJsonAuthor(anyObj: anyObj as AnyObject)
                            self.statuslist = self.parseJsonStatus(anyObj: anyObj as AnyObject)
                        }
                        catch
                        {
                            print("Error: \(error)")
                        }
                        // convert 'AnyObject' to Array<Business>
                        let count = self.booklist.count
                    
                        for index in 0..<count
                        {
                        
                            self.booknameArray.append(self.booklist[index].bookname)
                            self.authorArrary.append(self.authorlist[index].authorname)
                        
                            let tempStatus = self.statuslist[index].status
                            var statusholder = ""
                            if (tempStatus == true)
                            {
                                statusholder = "In stock"
                            }
                            if (tempStatus == false)
                            {
                                statusholder = "Out of Stock"
                            }
                            self.statusArrary.append(statusholder)
                        }
                    
                }
                else
                {
                    print(error as Any)
                }
                self.mygroup.leave()
                self.mygroup.notify(queue: .main, execute:
                    {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let nss = storyboard.instantiateViewController(withIdentifier: "SearchResult") as! SearchResult
                        print(self.booknameArray)
                        print(self.authorArrary)
                        print(self.statusArrary)
                        nss.booknameArray = self.booknameArray
                        nss.authornameArray = self.authorArrary
                        nss.statusArray = self.statusArrary
                        nss.bookholderArray = self.menubookArray
                        nss.dateholderArray = self.menudateArray
                        self.show(nss, sender: nil)
                        
                })

            }
                
        
            task2.resume()
            task2.suspend()
            
            
        
            }
           
    

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
        
    }
    func parseJsonAuthor(anyObj:AnyObject) -> Array<author>{
        
        var booklist:Array<author> = []
        
        if  anyObj is Array<AnyObject> {
            
            var b:author = author()
            for json in anyObj as! Array<AnyObject>{
                b.authorname = (json["author"] as AnyObject? as? String) ?? "" ;// to get rid of null
                booklist.append(b)
                
                
            }// for
            
        } // if
        
        return booklist
        
    }//func
    func parseJsonStatus(anyObj:AnyObject) -> Array<status>{
        
        var datelist:Array<status> = []
        
        if  anyObj is Array<AnyObject> {
            
            var b:status = status()
            for json in anyObj as! Array<AnyObject>{
                b.status = (json["status"] as AnyObject? as? Bool )!// to get rid of null
                datelist.append(b)
                
                
            }// for
            
        } // if
        
        return datelist
        
    }//func

    
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
    
    
    
    func searchAlert(title: String, message: String, time: Int)
    {
        
        guard (self.alertController == nil) else {
            print("Alert already displayed")
            return
        }
        
        self.baseMessage = message
        self.remainingTime = time
        
        self.alertController = UIAlertController(title: title, message: self.alertMessage(), preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Alert was cancelled")
            self.alertController=nil;
            self.alertTimer?.invalidate()
            self.alertTimer=nil
        }
        
        self.alertController!.addAction(cancelAction)
        
        
        self.alertTimer = Timer.scheduledTimer(timeInterval: 1.9, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
        self.present(self.alertController!, animated: true, completion: nil)
    }
    
    @objc func countDown() {
        
        self.remainingTime -= 1
        if (self.remainingTime < 0) {
            self.alertTimer?.invalidate()
            self.alertTimer = nil
            self.alertController!.dismiss(animated: true, completion: {
                self.alertController = nil
            })
        } else {
            self.alertController!.message = self.alertMessage()
            
        }
        
    }
    
    func alertMessage() -> String {
        var message=""
        if let baseMessage=self.baseMessage {
            message=baseMessage+" "
        }
        return(message+"\n Timeout: \(self.remainingTime)")
    }

   
   
}
