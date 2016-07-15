//
//  UtilManager.swift
//  redcircle
//
//  Created by zhan on 16/7/12.
//  Copyright © 2016年 zhan. All rights reserved.
//

import Foundation


class UtilManager: NSObject {
//    
//    class func random(min:UInt32,max:UInt32)->UInt32{
//        return  arc4random_uniform(max-min)+min
//    }
    
    class func randomString(len:Int)->String{
//        let min:UInt32=33,max:UInt32=127
        var string=""
        for _ in 0..<len {
            let randomNumber = random() % 26 + 97
            let randomChar = Character(UnicodeScalar(randomNumber))
            string.append(randomChar)
        }
        return string
        
    }

}