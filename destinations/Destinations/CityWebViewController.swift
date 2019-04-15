//
//  CityWebViewController.swift
//  QiuyangNieAssign2
//
//  Created by Qiuyang Nie on 13/04/2019.
//  Copyright © 2019 Qiuyang Nie. All rights reserved.
//

import UIKit
import WebKit
import CoreData


class CityWebViewController: UIViewController, WKNavigationDelegate {
    
    // CoreData
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var entity: NSEntityDescription! = nil
    var citiesManagedObject: Cities! = nil
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if (citiesManagedObject == nil) {
            let urlData = "https://www.lonelyplanet.com"
            let url = URL(string: urlData)
            let request = URLRequest(url: url!)
            webView.load(request)
            webView.navigationDelegate = self
        } else if (citiesManagedObject.url == nil) {
            let urlData = "https://www.lonelyplanet.com"
            let url = URL(string: urlData)
            let request = URLRequest(url: url!)
            webView.load(request)
            webView.navigationDelegate = self
        } else {
            let urlData = citiesManagedObject.url
            let url = URL(string: urlData!)
            let request = URLRequest(url: url!)
            webView.load(request)
            webView.navigationDelegate = self
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    
    

    
    

    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
