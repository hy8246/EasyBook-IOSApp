//
//  ScannerViewStyle.swift
//  EasyBook
//
//  Created by yuh on 2/26/17.
//  Copyright © 2017 yuh. All rights reserved.
//
import UIKit

public enum ScannerViewAnimationStyle
{
    case lineMove
    case lineStill
    case none
}

public enum ScannerViewPhotoframeAngleStyle
{
    case inner
    case outer
    case on
}


public struct ScannerViewStyle
{
    
    
    public var isNeedShowRetangle:Bool = true
    
    //default ratio as squre
    public var whRatio:CGFloat = 1.0
    
    public var centerUpOffset:CGFloat = 44
    
    public var xScanRetangleOffset:CGFloat = 60
    
    //default frame color
    public var colorRetangleLine = UIColor.white
    
    public var photoframeAngleStyle = ScannerViewPhotoframeAngleStyle.outer  //outer
    
    public var colorAngle = UIColor(red: 0.0, green: 167.0/255.0, blue: 231.0/255.0, alpha: 1.0)
    
    
    public var photoframeAngleW:CGFloat = 24.0   //24.0
    public var photoframeAngleH:CGFloat = 24.0  //24.0
    
    public var photoframeLineW:CGFloat = 6  //6

    public var red_notRecoginitonArea:CGFloat    = 0.0
    public var green_notRecoginitonArea:CGFloat  = 0.0
    public var blue_notRecoginitonArea:CGFloat   = 0.0
    public var alpa_notRecoginitonArea:CGFloat   = 0.5
    
    public init()
    {
        
    }
    
    
}




