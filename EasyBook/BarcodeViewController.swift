//
//  BarcodeViewController.swift
//  EasyBook
//
//  Created by yuh on 2/25/17.
//  Copyright © 2017 yuh. All rights reserved.
//
import UIKit
import AVFoundation

protocol BarcodeDelegate
{
    func barcodeReaded(barcode: String)
}

class BarcodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate
{
    
    
    var delegate: BarcodeDelegate?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?

    open var scanStyle: ScannerViewStyle? = ScannerViewStyle()
    open var ScanView: ScannerView?
    var videoCaptureDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    var device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    var output = AVCaptureMetadataOutput()
    var previewLayer: AVCaptureVideoPreviewLayer?

    var captureSession = AVCaptureSession()
    var code: String?
    var dataControl = GeneralVariableAndFunction ()
    var alertController: UIAlertController?
    var baseMessage: String?
    var bookN = ""
    let mygroup = DispatchGroup()
    let DH = DataHandler()
    var storageEmail = ""
    var rentparas = ""
    var bookholder = [String]()
    var dateholder = [String]()
    
    
       override func viewDidLoad()
    {
        super.viewDidLoad()
       
        setstyle()
        
        self.view.backgroundColor = UIColor.clear
      
        self.setupCamera()
        
        
    }
    
   
    func buttonActionsss(sender: UIButton!)
    {
       
        var btnsendtag: UIButton = sender
               // btnsendtag.alignmentRect(forFrame: rect)
                if btnsendtag.tag == 1
        {
            
            //do anything here
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vm = storyboard.instantiateViewController(withIdentifier: "Menu") as! Menu
            vm.booknameArray.removeAll()
            vm.dateArrary.removeAll()
            vm.booknameArray = bookholder
            vm.dateArrary = dateholder
            self.present(vm, animated: false, completion: nil)
           
        }
    }

    
    private func setupCamera()
    {
        
        let input = try? AVCaptureDeviceInput(device: videoCaptureDevice)
        
        if self.captureSession.canAddInput(input)
        {
            self.captureSession.addInput(input)
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        if let videoPreviewLayer = self.previewLayer {
            videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer.frame = self.view.bounds
            view.layer.addSublayer(videoPreviewLayer)
         
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        if self.captureSession.canAddOutput(metadataOutput) {
            self.captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode,
                                                  AVMetadataObjectTypeEAN13Code,
                                                  AVMetadataObjectTypeCode128Code,
                                                  AVMetadataObjectTypeUPCECode,
                                                  AVMetadataObjectTypeCode39Code,
                                                  AVMetadataObjectTypeCode39Mod43Code,
                                                  AVMetadataObjectTypeEAN8Code,
                                                  AVMetadataObjectTypeCode93Code,
                                                  AVMetadataObjectTypePDF417Code,
                                                  AVMetadataObjectTypeAztecCode,
                                                  AVMetadataObjectTypeInterleaved2of5Code,
                                                  AVMetadataObjectTypeITF14Code,
                                                  AVMetadataObjectTypeDataMatrixCode]
        } else {
            print("Could not add metadata output")
        }
       
        ScanView?.startScanAnimation()
       
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if (captureSession.isRunning == false)
        {
           
            captureSession.startRunning();
          
        }
    }
    override open func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        //start the startup animations
       drawScanView()
        let btn: UIButton = UIButton(frame: CGRect(x: 150, y: 500, width: 100, height: 50))
        btn.backgroundColor = UIColor.green
        btn.setTitle("Cancel", for: .normal)
        btn.addTarget(self, action: #selector(buttonActionsss(sender:)), for: .touchUpInside)
        btn.tag = 1
        
        self.view.addSubview(btn)
  
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        if (captureSession.isRunning == true)
        {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            captureSession.stopRunning();
            
        }
    }
    open func setstyle()
    {
        scanStyle?.centerUpOffset = 44;
        scanStyle?.photoframeAngleStyle = ScannerViewPhotoframeAngleStyle.inner;
        scanStyle?.photoframeLineW = 2;
        scanStyle?.photoframeAngleW = 18;
        scanStyle?.photoframeAngleH = 18;
        scanStyle?.isNeedShowRetangle = false;
        scanStyle?.colorAngle = UIColor(red: 0.0/255, green: 200.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        
    }

    open func drawScanView()
    {
        if ScanView == nil
        {
            ScanView = ScannerView(frame: self.view.frame,vstyle:scanStyle! )
            self.view.addSubview(ScanView!)
        }
        
    }

    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // This is the delegate'smethod that is called when a code is readed
        for metadata in metadataObjects
        {
            let readableObject = metadata as! AVMetadataMachineReadableCodeObject
            dataControl.set_barcode(s: readableObject.stringValue)
                        self.delegate?.barcodeReaded(barcode: dataControl.get_barcode())
            let para2 = "serial=\(dataControl.get_barcode())"
            var request1 = URLRequest(url: URL(string: "http://www.easybook2017.com/xcode/getBookName?\(para2)")!)
           
            request1.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request1)
            { data, response, error in
                self.mygroup.enter()
                if error == nil
                {
                    let responseString2 = String(data: data!, encoding: .utf8)
                    self.mygroup.leave()
                    self.mygroup.notify(queue: .main, execute:
                        {
                            self.bookN = responseString2!
                            let fixbookN = self.bookN.replacingOccurrences(of: " ", with: "%20")
                            if (self.bookN == "1")
                            {
                                self.bookN = "Book Not Exist!"
                            }
                            self.Alert(title: "Serial: \(self.dataControl.get_barcode())", message: "Bookname: \(self.bookN)")
                            self.rentparas = "serial=\(self.dataControl.get_barcode())&email=\(self.storageEmail)&bookname=\(fixbookN)"
                           

                    })
                    
                }
                else
                {
                    print("error: \(String(describing: error))")
                }
               
            }
            task.resume()
            task.suspend()
            
            
        }
        

       //Alert(title: dataControl.get_barcode(), message: "\(bookN)")
       

    }
    func Alert(title: String, message: String)
    {
        
        guard (self.alertController == nil) else {
            return
        }
        
        self.baseMessage = message
        self.alertController = UIAlertController(title: title, message: self.alertMessage(), preferredStyle: .alert)
       

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        { (action) in
            print("Alert was cancelled")
            self.alertController=nil;
           
        }
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default)
        { (action) in
            
             var request2 = URLRequest(url: URL(string: "http://www.easybook2017.com/xcode/rent?\(self.rentparas)")!)
            request2.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request2)
            { data, response, error in
                
                if error == nil
                {
                    let responseString = String(data: data!, encoding: .utf8)
                    print("respo : \(String(describing: responseString!))")
                    if (responseString == "0")
                    {
                        self.dismiss(animated: true, completion: nil)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "Menu")
                        self.present(vc, animated: false, completion: nil)
                        self.alertController=nil;
                    }
                    if (responseString == "1")
                    {
                        self.alertController = nil
                        self.Alert1(title: "Error:", message: "Please bring this book to front desk to change status!")
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
        self.alertController!.addAction(cancelAction)
        self.alertController!.addAction(confirmAction)
        self.present(self.alertController!, animated: true, completion: nil)
    }
    func Alert1(title: String, message: String)
    {
        
        guard (self.alertController == nil) else {
            return
        }
        
        self.baseMessage = message
        self.alertController = UIAlertController(title: title, message: self.alertMessage(), preferredStyle: .alert)
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        { (action) in
            print("Alert was cancelled")
            self.alertController=nil;
            
        }
        
        self.alertController!.addAction(cancelAction)
        
        self.present(self.alertController!, animated: true, completion: nil)
    }
      func alertMessage() -> String
    {
        var message=""
        if let baseMessage=self.baseMessage
        {
            message=baseMessage+" "
        }
        return(message)
    }

}
