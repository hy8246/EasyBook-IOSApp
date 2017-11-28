//
//  Login.swift
//  EasyBook
//
//  Created by yuh on 1/28/17.
//  Copyright © 2017 yuh. All rights reserved.
//

import UIKit

class Login: UIViewController,UITextFieldDelegate
{

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var LoginOutlet: UIButton!
    
    var baseMessage: String?
    var messageObject = Messages ()
    var alertController: UIAlertController?
    var booklist:Array<book> = []
    var datelist:Array<date> = []
    private static var booknameArray = [String]()
    var bookholder = [String]()
    var dateholder = [String]()
    let mygroup = DispatchGroup()
    let DH = DataHandler()
    struct book
    {
        var bookname = ""
        
    }
    struct date
    {
        var dates = ""
    }
    /////////////////////////////////////////////////////////////
    //////////valid Email Check here////Below
    //////////////////////////////////////////////////////////////////
    
    
    @IBAction func emailFieldEditingChanged(_ sender: Any)
    {
        if(!(email.text?.isEmpty)! && (!(password.text?.isEmpty)!))
        {
            if (validateEmail(candidate: email.text!) == true)
            {
                LoginOutlet.isUserInteractionEnabled = true
                LoginOutlet.isEnabled = true
            }
        }
        else{
            LoginOutlet.isUserInteractionEnabled = false
            LoginOutlet.isEnabled = false
        }


    }
    
    @IBAction func passwordFieldEditingChanged(_ sender: Any)
    {
        if(!(email.text?.isEmpty)! && (!(password.text?.isEmpty)!))
        {
            LoginOutlet.isUserInteractionEnabled = true
            
        }

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
       
        if(!(email.text?.isEmpty)! && (!(password.text?.isEmpty)!))
        {
            LoginOutlet.isUserInteractionEnabled = true
            
        }
    }
    
    func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        if(!(email.text?.isEmpty)! && (!(password.text?.isEmpty)!))
        {
            if (validateEmail(candidate: email.text!) == true)
            {
                LoginOutlet.isUserInteractionEnabled = true
                LoginOutlet.isEnabled = true
            }
        }
        else{
            LoginOutlet.isUserInteractionEnabled = false
            LoginOutlet.isEnabled = false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if(!(email.text?.isEmpty)! && (!(password.text?.isEmpty)!))
        {
            if (validateEmail(candidate: email.text!) == true)
            {
            LoginOutlet.isUserInteractionEnabled = true
            LoginOutlet.isEnabled = true
            }
        }
        else{
            LoginOutlet.isUserInteractionEnabled = false
            LoginOutlet.isEnabled = false
        }
        self.view.endEditing(true)
        return false
    }
    func validateEmail(candidate: String) -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    /////////////////////////////////////////////////////////////
    //////////valid Email Check here////Above
    //////////////////////////////////////////////////////////////////
    override func viewDidLoad()
    {
        super.viewDidLoad()
      
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        email.delegate = self
        password.delegate = self
        
        LoginOutlet.isUserInteractionEnabled = false
        LoginOutlet.isEnabled = false
        
    }

    
    @IBAction func registerBTN(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Register")
        self.show(vc, sender: nil)
    }
    @IBAction func loginBTN(_ sender: Any)
    {
        
        
        let para1 = "email=\(email.text!)&password=\(password.text!)"
        let para2 = "email=\(email.text!)"
        DH.set_email(e: email.text!)
        var request1 = URLRequest(url: URL(string: "http://www.easybook2017.com/xcode/signin?\(para1)")!)
        let request2 = URLRequest(url: URL(string: "http://www.easybook2017.com/xcode/returnrentalrecord?\(para2)")!)
       
       
        request1.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request1)
        { data, response, error in
            
           if (error != nil)
           {
            self.Alert(title: "ERROR: ", message: "Server is currently down!")
            }
            self.mygroup.enter()
            if error == nil
            {
                let responseString = String(data: data!, encoding: .utf8)
               // print(responseString)
                if (responseString == "0")
                {
                    //Start from here 
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
                                //print (self.booklist)
                              //  print(self.datelist)
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
                                self.dateholder.append(expirationString)
                                self.bookholder.append(self.booklist[index].bookname)
                                
                         
                              
                                
                            }
                        
                          
                        }
                        else
                        {
                            print("error: \(String(describing: error))")
                        }
                        self.mygroup.leave()
                    }
                    task2.resume()
                    task2.suspend()
                    self.mygroup.notify(queue: .main, execute:
                    {
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vm = storyboard.instantiateViewController(withIdentifier: "Menu") as! Menu
                       
                        vm.booknameArray = self.bookholder
                        vm.dateArrary = self.dateholder
                        print("Login: \(self.bookholder)")
                        print("Login: \(self.dateholder)")
                        DispatchQueue.main.async(execute:
                        {
                            self.present(vm, animated: false, completion: nil)
                        })
                       
                    })
                }
                if (responseString == "1")
                {
                     DispatchQueue.main.async {
                        self.Alert(title: "Error: ", message: "Account does not exist!")
                    }
                }
                if (responseString == "2")
                {
                    DispatchQueue.main.async
                        {
                        self.Alert(title: "Error: ", message: "Wrong password!")
                    }

                }
                
            }
            else
            {
                print("error: \(String(describing: error))")
            }
        }
        task.resume()
        task.suspend()
        
    }
    
    func Alert(title: String, message: String)
    {
        
        guard (self.alertController == nil) else {
            print("Alert already displayed")
            return
        }
        
        self.baseMessage = message
       
        
        self.alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Alert was cancelled")
            self.alertController=nil;
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vm = storyboard.instantiateViewController(withIdentifier: "Login")
            self.present(vm, animated: false, completion: nil)
            
        }
        
        self.alertController!.addAction(cancelAction)
 
        self.present(self.alertController!, animated: true, completion: nil)
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

   
    
    
    
    
    
}
