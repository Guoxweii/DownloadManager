//
//  Task.swift
//  DownloadManager
//
//  Created by gxw on 14/11/29.
//  Copyright (c) 2014年 b-star. All rights reserved.
//

import UIKit

class Task: ActiveRecord {
    var url: NSString!
    var progress: NSNumber! = 0
}