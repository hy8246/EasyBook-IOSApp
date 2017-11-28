//
//  ScannerView.swift
//  EasyBook
//
//  Created by yuh on 2/26/17.
//  Copyright © 2017 yuh. All rights reserved.
//

import UIKit

class ScannerView: UIView {

    
    var viewStyle:ScannerViewStyle = ScannerViewStyle()
    var scanRetangleRect:CGRect = CGRect.zero
    var scannerAnimation:ScannerAnimation?
    //ActivityIndicator, shows the app is running
    var activityView:UIActivityIndicatorView?
    //variable for status checks
    var check:Bool = false
    
    //intialize the scanner screen
    public init(frame:CGRect, vstyle:ScannerViewStyle )
    {
        viewStyle = vstyle
        var frameTmp = frame;
        frameTmp.origin = CGPoint.zero
        super.init(frame: frameTmp)
        backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect)
    {
        var frameTmp = frame;
        frameTmp.origin = CGPoint.zero
        super.init(frame: frameTmp)
        backgroundColor = UIColor.clear
    }
 
    required public init?(coder aDecoder: NSCoder)
    {
        self.init()
    }
 
    deinit
    {
        if (scannerAnimation != nil)
        {
            scannerAnimation!.stopStepAnimating()
        }
    }
    //scan start here
    func startScanAnimation()
    {
        if check
        {
            return
        }
        check = true
    }
    
    //for stop scan effects
    func stopScanAnimation()
    {
        check = false
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override open func draw(_ rect: CGRect)
    {
        // use as a pin point to indicate where the camera should focus on
        drawScanRect()
    }
    
    //Layout of the scanner
    //no change is needed in function
    func drawScanRect()
    {
        let XRetangleLeft = viewStyle.xScanRetangleOffset
        var sizeRetangle = CGSize(width: self.frame.size.width - XRetangleLeft*2.0, height: self.frame.size.width - XRetangleLeft*2.0)
        if viewStyle.whRatio != 1.0
        {
            let w = sizeRetangle.width;
            var h:CGFloat = w / viewStyle.whRatio
            let hInt:Int = Int(h)
            h = CGFloat(hInt)
            sizeRetangle = CGSize(width: w,height: h)
        }
        //y-axis coordinate
        let YMinRetangle = self.frame.size.height / 2.0 - sizeRetangle.height/2.0 - viewStyle.centerUpOffset
        let YMaxRetangle = YMinRetangle + sizeRetangle.height
        let XRetangleRight = self.frame.size.width - XRetangleLeft
        // print("frame:%@",NSStringFromCGRect(self.frame))
        let context:CGContext? = UIGraphicsGetCurrentContext()
        //set color to fill the parts
        context?.setFillColor(red: viewStyle.red_notRecoginitonArea, green: viewStyle.green_notRecoginitonArea,
                              blue: viewStyle.blue_notRecoginitonArea, alpha: viewStyle.alpa_notRecoginitonArea)
        //fill the top
        var rect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: YMinRetangle)
        context?.fill(rect)
        //fill the left
        rect = CGRect(x: 0, y: YMinRetangle, width: XRetangleLeft,height: sizeRetangle.height)
        context?.fill(rect)
        //fill the right
        rect = CGRect(x: XRetangleRight, y: YMinRetangle, width: XRetangleLeft,height: sizeRetangle.height)
        context?.fill(rect)
        //fill the bottom
        rect = CGRect(x: 0, y: YMaxRetangle, width: self.frame.size.width,height: self.frame.size.height - YMaxRetangle)
        context?.fill(rect)
        //execute
        context?.strokePath()
        scanRetangleRect = CGRect(x: XRetangleLeft, y: YMinRetangle, width: sizeRetangle.width, height: sizeRetangle.height)
        let wAngle = viewStyle.photoframeAngleW;
        let hAngle = viewStyle.photoframeAngleH;
        let linewidthAngle = viewStyle.photoframeLineW;
        let diffAngle = linewidthAngle/3;
        context?.setStrokeColor(viewStyle.colorAngle.cgColor);
        context?.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0);
        // Draw them with a 2.0 stroke width so they are a bit more visible.
        context?.setLineWidth(linewidthAngle);
        let leftX = XRetangleLeft - diffAngle
        let topY = YMinRetangle - diffAngle
        let rightX = XRetangleRight + diffAngle
        let bottomY = YMaxRetangle + diffAngle
        //upper left horizontal
        context?.move(to: CGPoint(x: leftX-linewidthAngle/2, y: topY))
        context?.addLine(to: CGPoint(x: leftX + wAngle, y: topY))
        //upper left vertical
        context?.move(to: CGPoint(x: leftX, y: topY-linewidthAngle/2))
        context?.addLine(to: CGPoint(x: leftX, y: topY+hAngle))
        //lower left horizontal
        context?.move(to: CGPoint(x: leftX-linewidthAngle/2, y: bottomY))
        context?.addLine(to: CGPoint(x: leftX + wAngle, y: bottomY))
        //lower left veritcal
        context?.move(to: CGPoint(x: leftX, y: bottomY+linewidthAngle/2))
        context?.addLine(to: CGPoint(x: leftX, y: bottomY - hAngle))
        //upper right horizontal
        context?.move(to: CGPoint(x: rightX+linewidthAngle/2, y: topY))
        context?.addLine(to: CGPoint(x: rightX - wAngle, y: topY))
        //upper right vertical
        context?.move(to: CGPoint(x: rightX, y: topY-linewidthAngle/2))
        context?.addLine(to: CGPoint(x: rightX, y: topY + hAngle))
        //lower right horizontal
        context?.move(to: CGPoint(x: rightX+linewidthAngle/2, y: bottomY))
        context?.addLine(to: CGPoint(x: rightX - wAngle, y: bottomY))
        //lower right vertical
        context?.move(to: CGPoint(x: rightX, y: bottomY+linewidthAngle/2))
        context?.addLine(to: CGPoint(x: rightX, y: bottomY - hAngle))
        context?.strokePath()
    }
}
