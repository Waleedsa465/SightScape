//
//  MenuWebViewController.swift
//  SightScapUser
//
//  Created by Hunain on 22/09/2023.
//

import UIKit
import WebKit
import LanguageManager_iOS

class MenuWebViewController: UIViewController,WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate {

    //MARK: Outlets
    
    @IBOutlet weak var webMenu: WKWebView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    var strTitle = ""
    var strLink = ""
    
    //MARK: View Life Cycle Start here...
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    //MARK: Setup View
    func setupView() {
        
        if LanguageManager.shared.currentLanguage == .en{
            self.btnBack.setImage(UIImage(named: "btnBack"), for: .normal)
        }else{
            self.btnBack.setImage(UIImage(named: "btnBackArb"), for: .normal)
        }
        
        self.webMenu.scrollView.delegate = self
        self.lblTitle.text = self.strTitle
        
        let url = URL(string: "\(self.strLink)")!
        let request = NSMutableURLRequest(url: url as URL)
        self.webMenu.load(request as URLRequest)
        
        self.webMenu.allowsBackForwardNavigationGestures = false
        self.webMenu.navigationDelegate = self
        self.webMenu.uiDelegate = self
        
    }
    
    //MARK: Utility Methods
    
    //MARK: Button Action
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //MARK: API Methods
    
    //MARK: DELEGATE METHODS
    
    //MARK: TableView

    //MARK: CollectionView
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
    
    //MARK: Webview
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        self.activity.stopAnimating()
        let alert  = UIAlertController(title: nil, message: "Please reload the page".localiz(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localiz(), style: .default, handler: { (alert:UIAlertAction) in
            self.webMenu.reload()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
        self.activity.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        self.webMenu.isHidden = false
        self.activity.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated  {
                if let url = navigationAction.request.url,
                //let host = url.host, host.hasPrefix("domain.com") !=
                UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                    decisionHandler(.cancel)
                } else {
                    // Open in web view
                    decisionHandler(.allow)
                }
            } else {
                // other navigation type, such as reload, back or forward buttons
                decisionHandler(.allow)
        }
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
             scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    //MARK:- View Life Cycle End here...
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
