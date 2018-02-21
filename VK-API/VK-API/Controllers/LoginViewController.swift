//
//  LoginViewController.swift
//  VK-API
//
//  Created by Андрей Фоменко on 20.02.2018.
//  Copyright © 2018 Андрей Фоменко. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UIWebViewDelegate {

    typealias LoginCompletionBlock = ( _ token : AccessToken?) -> Void
    var completion : LoginCompletionBlock = {_ in }
    
    func initWithCompletionBlock(completion : @escaping ( _ token : AccessToken?) -> Void ) -> LoginViewController {
        
        self.completion = completion;
            
        return self;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var rect = self.view.bounds
        rect.origin = CGPoint.zero;
        
        let webView = UIWebView(frame: rect)
        webView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.addSubview(webView)
        
        let item = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelLoginView))
        
        self.navigationItem.setRightBarButton(item, animated:true)
        self.navigationItem.title = "Login"
        
        let urlString = "https://oauth.vk.com/authorize?" +
        "client_id=4395172&" +
        "scope=4199692&" +
        "redirect_uri=https://oauth.vk.com/blank.html&" +
        "display=mobile&" +
        "v=5.73&" +
        "response_type=token&" + "test_mode=1"
        
        let url = URL.init(string: urlString)
        
        let request = URLRequest.init(url: url!)
        
        webView.delegate = self
        
        webView.loadRequest(request)
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        print(request.url?.description)
        print("/n")
        if ((request.url?.description.range(of: "#access_token=")) != nil) {
            let token = AccessToken()
            
            var query = request.url?.description
            
            let array = query?.components(separatedBy: "#")
            
            if (array?.count)! > 1 {
                query = array?.last
            }
            
            let pairs = query?.components(separatedBy: "&")
            
            for pair in pairs! {
                
                let values = pair.components(separatedBy: "=")
                
                if values.count == 2 {
                    let key = values.first
                    
                    if key == "access_token" {
                        token.token = values.last
                    } else if key == "expires_in" {
                        let interval : TimeInterval
                        if let val = TimeInterval(values.last!) {
                            interval = val
                            token.expirationDate = Date.init(timeIntervalSinceNow: interval)
                        }
                        
                    } else if key == "user_id" {
                        
                        token.userId = values.last
                    }
                }
            }
            webView.delegate = nil
            
            if (completion != nil) {
                
                self.completion(token);
                self.dismiss(animated: true, completion: nil)
            }
            return false
        }
        return true
    }
    
    @objc func cancelLoginView(sender: UIBarButtonItem) {
    
        if completion != nil {
            completion = {token in
                token?.token = nil
                token?.userId = nil
                token?.expirationDate = nil
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
