//
//  DownloadViewController.swift
//  DownloadManager
//
//  Created by gxw on 14/11/29.
//  Copyright (c) 2014年 b-star. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController {

    @IBOutlet var urlField: UITextField!
    
    @IBAction func submitButton(sender: AnyObject) {
        if (urlField.text.isEmpty) { return }
        
        var fetcher = Task.lazyFetcher().limit(1).whereField("url", equalToValue: urlField.text)
        if (fetcher.fetchRecords().count == 1) {
            println("exist!")
            return
        }
        
        var task = Task.newRecord()
        task.url = urlField.text
        if task.save() {
            println("save success")
            println(Task.allRecords())
            performSegueWithIdentifier("downloadSegue", sender: nil)
        } else {
            println(task.errors())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
