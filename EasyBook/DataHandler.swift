//
//  DataHandler.swift
//  EasyBook
//
//  Created by yuh on 3/3/17.
//  Copyright © 2017 yuh. All rights reserved.
//

import Foundation
import UIKit

class DataHandler: UIViewController
    
{
    private static var email = ""
    private static var confirmation = ""
    private static var emaildata = ""
    private static var passworddata = ""
    private static var booknameArray = [String]()
    private static var duedateArray = [Date]()
    var baseMessage: String?
    var messageObject = Messages ()
    var alertController: UIAlertController?
    let pass = GeneralVariableAndFunction()
    
    public func get_email() ->String
    {
        return DataHandler.email
    }
    public func set_email(e: String)
    {
        DataHandler.email = e
    }
    public func getConfirmation() ->String
    {
        return DataHandler.confirmation
    }
    public func getEmail() ->String
    {
        return DataHandler.emaildata
    }
    public func getPassword() ->String
    {
        return DataHandler.passworddata
    }
    public func getBookNameArray() ->Array<Any>
    {
        return DataHandler.booknameArray
    }
    public func getDueDateArray() ->Array<Any>
    {
        return DataHandler.duedateArray
    }
    public func appendBookNameArray(b: String)
    {
        DataHandler.booknameArray.append(b)
    }
    public func appendDueDateArray(b: Date)
    {
        DataHandler.duedateArray.append(b)
    }
    public func setEmail(e: String)
    {
        DataHandler.emaildata = e
    }
    public func setPassword(p: String)
    {
        DataHandler.passworddata = p
    }
    
    
    
    
    
    func anthentication (parameters: String)
    {
        var request = URLRequest(url: URL(string: "http://www.easybook2017.com/xcode/signin?\(parameters)")!)
        print (URL(string: "http://www.easybook2017.com/xcode/signin?\(parameters)")!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request)
        { data, response, error in
            
            if error == nil
                
            {
                let responseString = String(data: data!, encoding: .utf8)
                if (responseString == "0")
                {
                 //   DataHandler.confirmation = "0"
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vm = storyboard.instantiateViewController(withIdentifier: "Menu")
                    self.present(vm, animated: false, completion: nil)
                }
                if (responseString == "1")
                {
                    //DataHandler.confirmation = "1"
                    var alert = UIAlertController(title: "Error", message: "Account does not exist!", preferredStyle: .alert)
                        //(title: "Er  ror", message: "User account does not exist!!")
                    DispatchQueue.main.sync {
                        self.present(alert, animated: true, completion: nil)}
                }
                if (responseString == "2")
                {
                    //DataHandler.confirmation = "2"
                    var alert = UIAlertController(title: "Error", message: "Password does not match with the account information!", preferredStyle: .alert)
                    //(title: "Er  ror", message: "User account does not exist!!")
                    self.present(alert, animated: true, completion: nil)
                }

                
            }
            else
            {
                print("error: \(String(describing: error))")
            }
        }
        task.resume()
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
            
        }
        
        self.alertController!.addAction(cancelAction)
        
        self.present(self.alertController!, animated: true, completion: nil)
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    /*func get()
    {
        request.httpMethod = "GET"
        let body = ""
        request.httpBody = body.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request)
        { data, response, error in
            
            if error == nil
                
            {
                let responseString = String(data: data!, encoding: .utf8)
                print(responseString!)
            }
            else
            {
                print("error: \(String(describing: error))")
            }
        }
        task.resume()
        
    }
    func addItem(check: String, serial: String, host: String, categ: String, type: String, model: String, manuf: String, status: String, user: String, dept: String, location: String,phone: String) -> Void
    {
        
        request.httpMethod = "POST"
        let body = "Check=\(check)&SerialNumber=\(serial)&Category=\(categ)&Hostname=\(host)&Type=\(type)&Model=\(model)&Manufacturer=\(manuf)&Status=\(status)&User=\(user)&Department=\(dept)&Location=\(location)&Phone=\(phone)"
        request.httpBody = body.data(using: String.Encoding.utf8)
        if (check == "1")
        {
            let task = URLSession.shared.dataTask(with: request)
            { data, response, error in
                
                if error == nil
                    
                {
                    let responseString = String(data: data!, encoding: .utf8)
                    print(responseString!)
                }
                else
                {
                    print("error: \(String(describing: error))")
                }
            }
            task.resume()
            
        }
    }
    
    func checkOnly(check: String, s: String, c: String)
    {
        request.httpMethod = "POST"
        let body = "Check=\(check)&SerialNumber=\(s)&Category=\(c)"
        request.httpBody = body.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request)
        { data, response, error in
            
            if error == nil
            {
                let responseString = String(data: data!, encoding: .utf8)
/*
                self.pass.Set_respond(r: responseString!)
                if(responseString == "1")
                {
                    self.pass.Set_Checker(c: "Yes")
                    print(self.pass.Get_Checker())
                }
                else
                {
                    self.pass.Set_Checker(c: "No")
                    print(self.pass.Get_Checker())
                    
             
                }
 */
            }
            else
            {
                print("error: \(String(describing: error))")
            }
        }
        task.resume()
    }
    func getdata(check: String, s: String, c: String)
    {
        request.httpMethod = "POST"
        let body = "Check=\(check)&SerialNumber=\(s)&Category=\(c)"
        request.httpBody = body.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request)
        { data, response, error in
            
            if error == nil
            {
                
                DispatchQueue.main.async
                    {
                        do
                        {
                            //get the result
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            //assign json to new var parseJSON in secured way
                            guard let parseJSON = json else
                            {
                                print("Error while parsing")
                                return
                            }
                            // get type from parseJSON dictionary
                            let serial = parseJSON["SerialNumber"]
                            let hostname = parseJSON["Hostname"]
                            let categorie = parseJSON["Category"]
                            let type = parseJSON["Type"]
                            let model = parseJSON["Model"]
                            let manufacturer = parseJSON["Manufacturer"]
                            let status = parseJSON["Status"]
                            let user = parseJSON["User"]
                            let dept = parseJSON["Department"]
                            let location = parseJSON["Location"]
                            let phone = parseJSON["Phone"]
                            let date = parseJSON["UpdateTime"]
                      /*
                            self.pass.Set_Serial(s: serial as! String)
                            self.pass.Set_Host(h: hostname as! String)
                            self.pass.Set_Category(c: categorie as! String)
                            self.pass.Set_Type(t: type as! String)
                            self.pass.Set_Model(m: model as! String)
                            self.pass.Set_Manufacturer(m: manufacturer as! String)
                            self.pass.Set_Status(s: status as! String)
                            self.pass.Set_User(u: user as! String)
                            self.pass.Set_Department(d: dept as! String)
                            self.pass.Set_Location(l: location as! String)
                            self.pass.Set_Date(d: date as! String)
                            self.pass.Set_Phone(d: phone as! String)
 */
                        }
                        catch
                        {
                            print("Caught an error: \(error)")
                        }
                }
            }
            else
            {
                print("error: \(error)")
            }
            //let responseString = String(data: data!, encoding: .utf8)
            //print("responseString = \(responseString)")
        }
        task.resume()
    }
    
    
    
    
  */  
}
