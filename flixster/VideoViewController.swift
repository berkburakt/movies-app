//
//  VideoViewController.swift
//  flixster
//
//  Created by Berk Burak Tasdemir on 2/13/21.
//

import UIKit
import WebKit

class VideoViewController: UIViewController, WKNavigationDelegate {

    var urlPath: String?
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        if let urlPath = urlPath {
            let url = URL(string: urlPath)!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = true
        }
    }
}
