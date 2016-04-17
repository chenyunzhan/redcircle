//
//  VerifyButtonStatus.swift
//  redcircle
//
//  Created by CLOUD on 16/4/17.
//  Copyright © 2016年 zhan. All rights reserved.
//

import Foundation
import SwiftyButton

class VerifyButtonStatus: NSObject {
    
    var sendButton: SwiftyButton!
    
    var countdownTimer: NSTimer?
    
    
    
    var remainingSeconds: Int = 0 {
        willSet {
            sendButton.setTitle("\(newValue)", forState: .Normal)
            
            if newValue <= 0 {
                sendButton.setTitle("重新获取", forState: .Normal)
                isCounting = false
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTime:", userInfo: nil, repeats: true)
                
                remainingSeconds = 100
                
                sendButton.buttonColor  = UIColor.grayColor()
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
                sendButton.buttonColor  = UIColor.redColor()
            }
            
            sendButton.enabled = !newValue
        }
    }
    
    
    func updateTime(timer: NSTimer) {
        remainingSeconds -= 1
    }
    
}
