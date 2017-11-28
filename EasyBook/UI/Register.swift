//
//  Register.swift
//  EasyBook
//
//  Created by yuh on 1/28/17.
//  Copyright © 2017 yuh. All rights reserved.
//

import UIKit

class Register: UIViewController,UITextFieldDelegate
{

    var alertController: UIAlertController?
    var alertTimer: Timer?
    var remainingTime = 0
    var baseMessage: String?
    var gen = "Male"
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var Cpassword: UITextField!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBAction func gender(_ sender: Any)
    {
      if ((sender as AnyObject).selectedSegmentIndex == 0)
      {
        self.gen = "Male"
        print(gen)
        
       }
        if ((sender as AnyObject).selectedSegmentIndex == 1)
        {
            self.gen = "Female"
            print(gen)
        }
        
    }
    
    @IBAction func submitBTN(_ sender: Any)
    {
       errorChecking()
    }
    @IBAction func cancelBTN(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vm = storyboard.instantiateViewController(withIdentifier: "Login")
        self.present(vm, animated: false, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
   
    func errorChecking()
    {
        if(!((email.text?.isEmpty)! || (password.text?.isEmpty)! || (Cpassword.text?.isEmpty)! || (firstname.text?.isEmpty)! || (lastname.text?.isEmpty)! || (id.text?.isEmpty)!))
        {
            if (password.text==Cpassword.text)
            {
                if (validateEmail(candidate: email.text!) == true)
                {
                    
                                   
                    let para2 = "email=\(email.text!)&password=\(Cpassword.text!)&firstname=\(firstname.text!)&lastname=\(lastname.text!)&gender=\(gen)&iid=\(id.text!)&phone=\(phone.text!)"
                    
                    var request2 = URLRequest(url: URL(string: "http://www.easybook2017.com/xcode/signup?\(para2)")!)
                    
                    
                    request2.httpMethod = "GET"
                    let task2 = URLSession.shared.dataTask(with: request2)
                    {data, response, error in
                        if error == nil
                        {
                            let responseString2 = String(data: data!, encoding: .utf8)
                            if (responseString2 == "0")
                            {
                                self.dismiss(animated: true, completion: nil)
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vm = storyboard.instantiateViewController(withIdentifier: "Login")
                                self.present(vm, animated: false, completion: nil)
                            }
                            if (responseString2 == "1")
                            {
                                self.Alert(title: "Error: ", message: "Account Already Exists!", time: 3)

                            }
                            
                        }
                        else
                        {
                            print(error)
                        }
                        
                    }
                    task2.resume()
                    task2.suspend()

                    
                    
                    
                    
                    
                   
                }
                else if (validateEmail(candidate: email.text!) == false)
                {
                    Alert(title: "Error: Email", message: "Invalid Email !", time: 3)
                }
                
            }
            if (password.text != Cpassword.text)
            {
                Alert(title: "Error: Password", message: "Password doesn't match !", time: 3)
            }
        }
        if(((email.text?.isEmpty)! || (password.text?.isEmpty)! || (Cpassword.text?.isEmpty)! || (firstname.text?.isEmpty)! || (lastname.text?.isEmpty)! || (id.text?.isEmpty)!))
        {
            Alert(title: "Error: Empty Field Detected!!", message: "You must fill out the required field '*'", time: 3)
        }
    }
    func dataHandler()
    {
        //Upload User Info here
    }
    
    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Action Reaction Function Below//
    func dismissKeyboard()
    {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func validateEmail(candidate: String) -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    
    func Alert(title: String, message: String, time: Int) {
        
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
    
    @objc func countDown()
    {
        
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
        return(message+"\(self.remainingTime)")
    }

}
