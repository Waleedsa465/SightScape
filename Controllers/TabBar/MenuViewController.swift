//
//  MenuViewController.swift
//  SightScapeVendor
//
//  Created by Hunain on 12/06/2023.
//

import UIKit
import LanguageManager_iOS

class MenuViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var btnLanguage: UIButton!
    
    var lang = ""
    
    //MARK: View Life Cycle Start here...
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    //MARK: Setup View
    func setupView() {
        if LanguageManager.shared.currentLanguage == .en{
            self.btnLanguage.setTitle("عربي".localiz(), for: .normal)
        }else{
            self.btnLanguage.setTitle("English".localiz(), for: .normal)
        }
        if LanguageManager.shared.currentLanguage == .en{
            self.lang = "en"
        }else{
            self.lang = "ar"
        }
    }
    
    func showWebController(link:String,title:String){
        if connected() == false{
            return
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuWebViewController") as! MenuWebViewController
        vc.strTitle = title
        vc.strLink = link
        self.present(vc, animated: true)
    }
    
    //MARK: Button Action
    @IBAction func btnSupportAction(_ sender: Any) {
        self.showWebController(link: "\(serverURL)API/support.php?lang=\(self.lang)&API_KEY=\(serverAPIKey)&app=vendor", title: "Support".localiz())
    }
    @IBAction func btnHowItWorkAction(_ sender: Any) {
        self.showWebController(link: "\(serverURL)API/how_it_works.php?lang=\(self.lang)&API_KEY=\(serverAPIKey)&app=vendor", title: "How it works?".localiz())
    }
    @IBAction func btnFaqAction(_ sender: Any) {
        self.showWebController(link: "\(serverURL)API/FAQ.php?lang=\(self.lang)&API_KEY=\(serverAPIKey)&app=vendor", title: "FAQs".localiz())
    }
    @IBAction func btnLogoutAction(_ sender: Any) {
        DispatchQueue.main.async {
            deleteDefaultObject(forKey: strLoginData)
            let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let nav = UINavigationController(rootViewController: mainViewController)
            nav.navigationBar.isHidden = true
            self.view.window?.rootViewController = nav
        }
    }
    
    @IBAction func btnPrivacyAction(_ sender: Any) {
        self.showWebController(link: "\(serverURL)API/privacy_policy.php?lang=\(self.lang)&API_KEY=\(serverAPIKey)&app=vendor", title: "Privacy Policy".localiz())
    }
    @IBAction func btnTermAction(_ sender: Any) {
        self.showWebController(link: "\(serverURL)API/terms_and_conditions.php?lang=\(self.lang)&API_KEY=\(serverAPIKey)&app=vendor", title: "Terms and Conditions".localiz())
    }
    @IBAction func btnLanguageAction(_ sender: Any) {
        if LanguageManager.shared.currentLanguage == .en{
            LanguageManager.shared.setLanguage(language: .ar)
            saveDefaultObject(obj: "ar", forKey: strCurrentApplanguage)
        }else{
            LanguageManager.shared.setLanguage(language: .en)
            saveDefaultObject(obj: "en", forKey: strCurrentApplanguage)
        }
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        let nav = UINavigationController(rootViewController: mainViewController)
        nav.navigationBar.isHidden = true
        self.view.window?.rootViewController = nav
    }
    
    //MARK: API Methods
    
    //MARK: DELEGATE METHODS
    
    //MARK: TableView

    //MARK: CollectionView
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
    
    
    
    //MARK:- View Life Cycle End here...
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
