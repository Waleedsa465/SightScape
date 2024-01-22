//
//  ExcursionListViewController.swift
//  SightScapeVendor
//
//  Created by Hunain on 30/09/2023.
//

import UIKit
import LanguageManager_iOS
import SDWebImage

class ExcursionListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: Outlets
    
    @IBOutlet weak var tblPasses: UITableView!
    
    var arrExcursions = [[String:Any]]()
    
    //MARK: View Life Cycle Start here...
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if readUserFromArchive(){
            self.getPasses()
        }
    }
    
    //MARK: Setup View
    func setupView() {
        NotificationCenter.default.addObserver(self, selector: #selector(PassScanClose), name: Notification.Name("PassScanClose"), object: nil)
        
        if isNewAppVersionAvailable{
            let alert = UIAlertController(title: strUpdateAlertTitle.localiz(), message: strUpdateAlertMsg.localiz(), preferredStyle: .alert)
            let actionUpdate = UIAlertAction(title: "Update".localiz(), style: .default) { (a:UIAlertAction) in
                isNewAppVersionAvailable = false
                if let url = URL(string: "https://apps.apple.com/us/app/sightscape-vendor/id6470340053") {
                    UIApplication.shared.open(url)
                }
            }
            alert.addAction(actionUpdate)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    //MARK: Utility Methods
    
    @objc func PassScanClose(notify : Notification){
        self.getPasses()
    }
    
    //MARK: Button Action
    
    //MARK: API Methods
    
    func getPasses(){
        if connected() == false{
            let alert = showAlert(title: errorAlertTitle, message: strNoInternetAlertMsg.localiz())
            self.present(alert, animated: true, completion: nil)
            return
        }
        showHud(viewHud: self.view)
        APIHandler.sharedInstance.getExcursionListAPI { result, responseObject in
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
                    
                    if let error = responseObject!["error"] as? String{
                        if error == "SESSION_INVALID"{
                            let alert = UIAlertController(title: invalidSessionAlertTitle, message: msgAlert, preferredStyle: .alert)
                            let acOK = UIAlertAction(title: "OK".localiz(), style: .default) { (ac:UIAlertAction) in
                                DispatchQueue.main.async {
                                    deleteDefaultObject(forKey: strLoginData)
                                    let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                    let nav = UINavigationController(rootViewController: mainViewController)
                                    nav.navigationBar.isHidden = true
                                    self.view.window?.rootViewController = nav
                                }
                            }
                            alert.addAction(acOK)
                            self.present(alert, animated: true, completion: nil)
                        }else{
                            let alert = showAlert(title: errorAlertTitle, message: msgAlert)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }else{
                    self.arrExcursions = responseObject!["data"] as! [[String:Any]]
                    self.tblPasses.reloadData()
                }
            }else{
                showLoafjetAlert(msg: strServerNotRespondMsg.localiz(), inView: self.view)
            }
        }
    }
    
    //MARK: DELEGATE METHODS
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrExcursions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
        var name = ""
        //var categry = ""
        if LanguageManager.shared.currentLanguage == .en{
            name = self.arrExcursions[indexPath.row]["name_en"] as! String
            //categry = self.arrExcursions[indexPath.row]["cat_en"] as! String
        }else{
            name = self.arrExcursions[indexPath.row]["name_ar"] as! String
            //categry = self.arrExcursions[indexPath.row]["cat_ar"] as! String
        }
        cell.lblBoldtitle.text = name
        cell.lblRegularTitle.text = ""
        let imgURL = self.arrExcursions[indexPath.row]["images"] as! String
        let picURL = "\(strPicURL)\(imgURL)"
        cell.imgExc.sd_setImage(with: URL(string: picURL), placeholderImage: UIImage(named: "PlaceHolderBanner"))
        
        cell.viewSponcered.isHidden = true
        cell.constraintPremiumTop.constant = 10
        if self.arrExcursions[indexPath.row]["premium"] as! Bool{
            cell.viewPremium.isHidden = false
        }else{
            cell.viewPremium.isHidden = true
        }
        
        cell.viewBookingReq.isHidden = true
        if self.arrExcursions[indexPath.row]["group_activity"] as! Bool{
            cell.viewGroupActivity.isHidden = false
        }else{
            cell.viewGroupActivity.isHidden = true
        }
        
        /*if self.arrFiltered[indexPath.row]["group_activity"] as! Bool && self.arrFiltered[indexPath.row]["booking_required"] as! Bool{
            //cell.constraintStackWidth.constant = 225
            cell.viewBookingReq.isHidden = false
            cell.viewGroupActivity.isHidden = false
        }else if !(self.arrFiltered[indexPath.row]["group_activity"] as! Bool) && !(self.arrFiltered[indexPath.row]["booking_required"] as! Bool){
            //cell.constraintStackWidth.constant = 0
            cell.viewBookingReq.isHidden = true
            cell.viewGroupActivity.isHidden = true
        }else{
            if self.arrFiltered[indexPath.row]["group_activity"] as! Bool{
                //cell.constraintStackWidth.constant = 112.5
                cell.viewBookingReq.isHidden = true
                cell.viewGroupActivity.isHidden = false
            }
            if self.arrFiltered[indexPath.row]["booking_required"] as! Bool{
                //cell.constraintStackWidth.constant = 112.5
                cell.viewBookingReq.isHidden = false
                cell.viewGroupActivity.isHidden = true
            }
        }*/
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ScanViewController") as! ScanViewController
        vc.objPass = self.arrExcursions[indexPath.row]
        self.present(vc, animated: true)
    }

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
