//
//  DownloadViewCell.swift
//  DownloadManager
//
//  Created by gxw on 14/11/29.
//  Copyright (c) 2014年 b-star. All rights reserved.
//

import UIKit

class DownloadViewCell: UITableViewCell {
    
    @IBOutlet var urlLabel: UILabel!
    @IBOutlet var downloadProgress: UIProgressView!
    
    var operation: AFDownloadRequestOperation!
    var task: Task!
    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
    
    @IBAction func download(sender: AnyObject) {
        if (operation != nil) {
            operation.resume()
        }
        
        var fetcher = Task.lazyFetcher().limit(1).whereField("url", equalToValue: urlLabel.text)
        var task = fetcher.fetchRecords().first as Task
        
        var url = NSURL(string: urlLabel.text!)
        if (url == nil) {
            return
        }
        
        var filename = url!.lastPathComponent
        var path = documentsPath.stringByAppendingPathComponent(filename)
        
        var request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 7200)
        operation = AFDownloadRequestOperation(request: request, targetPath: path, shouldResume: true)
        operation.setCompletionBlockWithSuccess({ (operation: AFHTTPRequestOperation!, data: AnyObject!) -> Void in
            println("download completed")
        }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("error happened")
            println(error)
        })
        
        operation.setProgressiveDownloadProgressBlock { (operation: AFDownloadRequestOperation!, bytesRead: Int, totalBytesRead: Int64, totalBytesExpected: Int64, totalBytesReadForFile: Int64, totalBytesExpectedToReadForFile: Int64) -> Void in
            println("progressive")
            var currentBytes = NSNumber(longLong: totalBytesReadForFile)
            var totalBytes = NSNumber(longLong: totalBytesExpectedToReadForFile)
            
            var progress =  currentBytes.doubleValue / totalBytes.doubleValue
            self.downloadProgress.progress = Float(progress)
            
            println(progress)
            
        }
        operation.start()
    }
    
    @IBAction func pause(sender: AnyObject) {
        if (operation != nil) {
            operation.cancel()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
