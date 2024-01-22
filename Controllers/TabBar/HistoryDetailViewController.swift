//
//  HistoryDetailViewController.swift
//  SightScapeVendor
//
//  Created by Hunain on 12/06/2023.
//

import UIKit
import LanguageManager_iOS

class HistoryDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: Outlets
    
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var viewPassType: CustomView!
    @IBOutlet weak var lblPassType: UILabel!
    @IBOutlet weak var lblScanType: UILabel!
    @IBOutlet weak var lblExcursion: UILabel!
    @IBOutlet weak var lblScannedBy: UILabel!
    @IBOutlet weak var viewScanType: CustomView!
    @IBOutlet weak var tblNames: UITableView!
    @IBOutlet weak var constraintTblNamesHeight: NSLayoutConstraint!
    @IBOutlet weak var lblNames: UILabel!
    @IBOutlet weak var btnCancel: CustomButton!
    @IBOutlet weak var btnBack: UIButton!
    
    var objPass = [String:Any]()
    var arrNames = [String]()
    
    //MARK: View Life Cycle Start here...
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    override func viewWillLayoutSubviews() {
        DispatchQueue.main.async {
            super.updateViewConstraints()
            self.constraintTblNamesHeight.constant = self.tblNames.contentSize.height //325*2
        }
    }
    
    //MARK: Setup View
    func setupView() {
        self.arrNames = self.objPass["names"] as! [String]
        self.tblNames.reloadData()
        
        if self.arrNames.count > 1{
            self.lblNames.text = "Names".localiz()
        }else{
            self.lblNames.text = "Name".localiz()
        }
        
        self.lblScannedBy.text = self.objPass["scanned_by"] as! String
        if self.objPass["scan_type"] as! String == "group"{
            self.lblScanType.text = "Group Scan".localiz()
            self.btnCancel.setTitle("Cancel Group Scan".localiz(), for: .normal)
        }else{
            self.lblScanType.text = "Single Scan".localiz()
            self.btnCancel.setTitle("Cancel Scan".localiz(), for: .normal)
        }
        
        /*if self.objPass["pass_type"] as! String == "Adventure"{
            self.lblPassType.text = "Adventure Pass".localiz()
            self.viewPassType.backgroundColor = hexStringToUIColor(hex: "505DA5")
            self.viewScanType.backgroundColor = hexStringToUIColor(hex: "2B3259")
        }else{
            self.lblPassType.text = "All-Inclusive Pass".localiz()
        }*/
        
        var exc = ""
        if LanguageManager.shared.currentLanguage == .en{
            exc = self.objPass["exc_name_en"] as! String
            self.btnBack.setImage(UIImage(named: "btnBack"), for: .normal)
        }else{
            exc = self.objPass["exc_name_ar"] as! String
            self.btnBack.setImage(UIImage(named: "btnBackArb"), for: .normal)
        }
        self.lblExcursion.text = exc
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let objDate = formatter.date(from: self.objPass["date_created"] as! String)
        formatter.dateFormat = "dd MMM yyyy - hh:mm a"
        let strTime = formatter.string(from: objDate!)
        self.lblDateTime.text = strTime
    }
    
    
    //MARK: Utility Methods
    
    //MARK: Button Action
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        let alert = UIAlertController(title: "Cancel Scan".localiz(), message: "Are you sure you want to cancel? This action cannot be reversed".localiz(), preferredStyle: .alert)
        let acYes = UIAlertAction(title: "Yes".localiz(), style: .default) { (ac:UIAlertAction) in
            self.cancelScanAPI()
        }
        let acCancel = UIAlertAction(title: "Cancel".localiz(), style: .default) { (ac:UIAlertAction) in
            
        }
        alert.addAction(acYes)
        alert.addAction(acCancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: API Methods
    
    func cancelScanAPI(){
        if connected() == false{
            let alert = showAlert(title: errorAlertTitle, message: strNoInternetAlertMsg.localiz())
            self.present(alert, animated: true, completion: nil)
            return
        }
        showHud(viewHud: self.view)
        APIHandler.sharedInstance.cancelScanAPI(scan_id: "\(self.objPass["scan_id"] as! Int)") { result, responseObject in
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
                    self.navigationController?.popViewController(animated: true)
                    //NotificationCenter.default.post(name: Notification.Name("HistoryDetailClose"), object: nil)
                }
            }else{
                showLoafjetAlert(msg: strServerNotRespondMsg.localiz(), inView: self.view)
            }
        }
    }
    
    //MARK: DELEGATE METHODS
    
    //MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NamesTableViewCell", for: indexPath) as! NamesTableViewCell
        cell.lblName.text = self.arrNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
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
