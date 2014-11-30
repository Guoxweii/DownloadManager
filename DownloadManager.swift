//
//  DownloadManager.swift
//  DownloadManager
//
//  Created by gxw on 14/11/30.
//  Copyright (c) 2014年 b-star. All rights reserved.
//

import Foundation

class DownloadManager {
    class var sharedInstance: DownloadManager {
        struct Static {
            static var instance: DownloadManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token, {
            Static.instance = DownloadManager()
        })
        
        return Static.instance!
    }
    
    var tasks: Dictionary<String, AFDownloadRequestOperation?> = Dictionary<String, AFDownloadRequestOperation?>()
}