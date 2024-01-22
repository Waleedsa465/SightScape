//
//  LoginViewController.swift
//  SightScapeVendor
//
//  Created by Hunain on 12/06/2023.
//

import UIKit
import LanguageManager_iOS

class LoginViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var tfUsername: CustomTextField!
    @IBOutlet weak var tfPassword: CustomTextField!
    @IBOutlet weak var btnShowHidePass: UIButton!
    @IBOutlet weak var btnLanguage: UIButton!
    
    var isPassShow = false
    
    //MARK: View Life Cycle Start here...
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    //MARK: Setup View
    func setupView() {
        if LanguageManager.shared.currentLanguage == .en{
            self.tfUsername.textAlignment = .left
            self.tfPassword.textAlignment = .left
            self.btnLanguage.setTitle("عربي".localiz(), for: .normal)
        }else{
            self.tfUsername.textAlignment = .right
            self.tfPassword.textAlignment = .right
            self.btnLanguage.setTitle("English".localiz(), for: .normal)
        }
    }
    
    //MARK: Utility Methods
    
    //MARK: Button Action
    @IBAction func btnLoginAction(_ sender: Any) {
        if tfUsername.text?.count == 0{
            showLoafjetAlert(msg: "Username required".localiz(), inView: view)
            self.tfUsername.shake()
            return
        }
        if tfPassword.text?.count == 0{
            showLoafjetAlert(msg: "Password required".localiz(), inView: view)
            self.tfPassword.shake()
            return
        }
        self.loginAPI()
    }
    
    @IBAction func btnShowHidePassAction(_ sender: Any) {
        if self.isPassShow{
            self.isPassShow = false
            self.btnShowHidePass.setImage(UIImage(named: "btnPassHide"), for: .normal)
            self.tfPassword.isSecureTextEntry = true
        }else{
            self.isPassShow = true
            self.btnShowHidePass.setImage(UIImage(named: "btnPassShow"), for: .normal)
            self.tfPassword.isSecureTextEntry = false
        }
    }
    
    @IBAction func btnLanguageAction(_ sender: Any) {
        if LanguageManager.shared.currentLanguage == .en{
            LanguageManager.shared.setLanguage(language: .ar)
            saveDefaultObject(obj: "ar", forKey: strCurrentApplanguage)
        }else{
            LanguageManager.shared.setLanguage(language: .en)
            saveDefaultObject(obj: "en", forKey: strCurrentApplanguage)
        }
        
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let nav = UINavigationController(rootViewController: mainViewController)
        nav.navigationBar.isHidden = true
        self.view.window?.rootViewController = nav
    }
    
    //MARK: API Methods
    
    func loginAPI(){
        if connected() == false{
            let alert = showAlert(title: errorAlertTitle, message: strNoInternetAlertMsg.localiz())
            self.present(alert, animated: true, completion: nil)
            return
        }
        showHud(viewHud: self.view)
        APIHandler.sharedInstance.loginAPI(username: self.tfUsername.text!, password: self.tfPassword.text!) { result, responseObject in
            hideHud(viewHud: self.view)
            if result{
                
                let success = responseObject!["response"] as! String
                var msgAlert = ""
                if LanguageManager.shared.currentLanguage == .en{
                    msgAlert = responseObject!["alert_en"] as! String
                }else{
                    msgAlert = responseObject!["alert_ar"] as! String
                }
                if success == "FAIL"{
                    let alert = showAlert(title: errorAlertTitle, message: msgAlert)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let data = responseObject!["data"] as! [String:Any]
                    let usr = User(ID: data["ID"] as! Int, last_login: data["last_login"] as! String, session: data["session"] as! String, vendor_id: data["vendor_id"] as! Int, username: data["username"] as! String, role: data["role"] as! String, name: data["name"] as! String, archived: data["archived"] as! Bool, date_created: data["date_created"] as! String, exc_ids: data["exc_ids"] as! String)
                    saveUserToArchive(data: usr)
                    if readUserFromArchive(){
                        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                        let nav = UINavigationController(rootViewController: mainViewController)
                        nav.navigationBar.isHidden = true
                        self.view.window?.rootViewController = nav
                    }
                }
            }else{
                showLoafjetAlert(msg: strServerNotRespondMsg.localiz(), inView: self.view)
            }
        }
    }
    
    
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
