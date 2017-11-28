//
//  GeneralVariableFunction.swift
//  EasyBook
//
//  Created by yuh on 2/4/17.
//  Copyright © 2017 yuh. All rights reserved.
//

import UIKit

class GeneralVariableAndFunction: UIViewController
{
    private static var barcode = ""
    private static var email = ""
    private static var password = ""
    private static var firstName = ""
    private static var lastName = ""
    private static var ID = ""
    private static var phoneNumber = ""
    private static var gender = ""

    //Get function to return variable value
    public func get_barcode() -> String
    {
        return GeneralVariableAndFunction.barcode
    }
    public func get_email() -> String
    {
        return GeneralVariableAndFunction.email
    }
    public func get_password() -> String
    {
        return  GeneralVariableAndFunction.password
    }
    public func get_firstName() -> String
    {
        return  GeneralVariableAndFunction.firstName
    }
    public func get_lastName() -> String
    {
        return  GeneralVariableAndFunction.lastName
    }
    public func get_ID() -> String
    {
        return  GeneralVariableAndFunction.ID
    }
    public func get_phoneNumber() -> String
    {
        return  GeneralVariableAndFunction.phoneNumber
    }
    public func get_gender() -> String
    {
        return  GeneralVariableAndFunction.gender
    }
    
    //Set function to config the variable value
    public func set_barcode (s: String)
    {
        GeneralVariableAndFunction.barcode = s
    }
    public func set_email (s: String)
    {
        GeneralVariableAndFunction.email = s
    }
    public func set_password (s: String)
    {
        GeneralVariableAndFunction.password = s
    }
    public func set_firstName (s: String)
    {
        GeneralVariableAndFunction.firstName = s
    }
    public func set_lastName (s: String)
    {
        GeneralVariableAndFunction.lastName = s
    }
    public func set_ID (s: String)
    {
        GeneralVariableAndFunction.ID = s
    }
    public func set_phoneNumber (s: String)
    {
        GeneralVariableAndFunction.phoneNumber = s
    }
    public func set_gender (s: String)
    {
        GeneralVariableAndFunction.gender = s
    }
    
    
}
