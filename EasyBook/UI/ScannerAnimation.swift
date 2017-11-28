//
//  ScannerAnimation.swift
//  EasyBook
//
//  Created by yuh on 2/26/17.
//  Copyright © 2017 yuh. All rights reserved.
//

import UIKit

class ScannerAnimation: UIImageView {

    var check = false
    var animationRect: CGRect = CGRect.zero
    
    func startAnimatingWithRect (animationRect: CGRect, parentView: UIView, image: UIImage?)
    {
        self.animationRect = animationRect
        parentView.addSubview(self)
        self.isHidden = false;
        check = true;
    }
        func stopStepAnimating()
    {
        self.isHidden = true;
        check = false;
    }
    
    static open func instance()->ScannerAnimation
    {
        return ScannerAnimation()
    }
    
    deinit
    {
        stopStepAnimating()
    }
}
