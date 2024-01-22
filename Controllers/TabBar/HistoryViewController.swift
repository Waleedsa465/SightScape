//
//  HistoryViewController.swift
//  SightScapeVendor
//
//  Created by Hunain on 12/06/2023.
//

import UIKit
import LanguageManager_iOS

class HistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: Outlets
    @IBOutlet weak var tblHistory: UITableView!
    @IBOutlet weak var lblMsg: UILabel!
    
    var arrHistory = [[String:Any]]()
    
    //MARK: View Life Cycle Start here...
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.arrHistory.removeAll()
        self.getHistory()
    }
    
    //MARK: Setup View
    func setupView() {
        self.tblHistory.rowHeight = 60
        //NotificationCenter.default.addObserver(self, selector: #selector(HistoryDetailClose), name: Notification.Name("HistoryDetailClose"), object: nil)
    }
    
    //MARK: Utility Methods
    
    /*@objc func HistoryDetailClose(notify : Notification){
        self.getHistory()
    }*/
    
    //MARK: Button Action
    
    //MARK: API Methods
    
    func getHistory(){
        if connected() == false{
            let alert = showAlert(title: errorAlertTitle, message: strNoInternetAlertMsg.localiz())
            self.present(alert, animated: true, completion: nil)
            return
        }
        showHud(viewHud: self.view)
        APIHandler.sharedInstance.getHistoryListAPI { result, responseObject in
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
                    var arrAll = [[String:Any]]()
                    var arrDatesSection = [String]()
                    arrAll = responseObject!["data"] as! [[String:Any]]
                    
                    for obj in arrAll{
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let objDate = formatter.date(from: obj["date_created"] as! String)
                        formatter.dateFormat = "yyyy-MM-dd"
                        let strDateMain = formatter.string(from: objDate!)
                        if arrDatesSection.count == 0{
                            arrDatesSection.append(obj["date_created"] as! String)
                        }else{
                            var isFound = false
                            for dt in arrDatesSection{
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let objDate = formatter.date(from: dt)
                                formatter.dateFormat = "yyyy-MM-dd"
                                let strDate = formatter.string(from: objDate!)
                                if strDate == strDateMain{
                                    isFound = true
                                    break
                                }
                            }
                            if !isFound{
                                arrDatesSection.append(obj["date_created"] as! String)
                            }
                        }
                    }
                    print(arrDatesSection)
                    /*for obj in dates{
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let objDate = formatter.date(from: obj)
                        formatter.dateFormat = "yyyy-MM-dd"
                        let strDateMain = formatter.string(from: objDate!)
                        var isFound = false
                        for var i in 0..<arr.count{
                            let items = arr[i]
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let objDate = formatter.date(from: items["date_created"] as! String)
                            formatter.dateFormat = "yyyy-MM-dd"
                            let strDate = formatter.string(from: objDate!)
                            if strDate == strDateMain{
                                isFound = true
                                break
                            }
                        }
                    }*/
                    //self.arrHistory = responseObject!["data"] as! [[String:Any]]
                    for var i in 0..<arrDatesSection.count{
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let objDate = formatter.date(from: arrDatesSection[i])
                        formatter.dateFormat = "yyyy-MM-dd"
                        let strDateMain = formatter.string(from: objDate!)
                        var arr = [[String:Any]]()
                        for obj in arrAll{
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let objDate = formatter.date(from: obj["date_created"] as! String)
                            formatter.dateFormat = "yyyy-MM-dd"
                            let strDate = formatter.string(from: objDate!)
                            if strDateMain == strDate{
                                arr.append(obj)
                            }
                        }
                        let obj = ["header":arrDatesSection[i],"data":arr]
                        self.arrHistory.append(obj)
                    }
                    
                    
                    self.tblHistory.reloadData()
                    if self.arrHistory.count == 0{
                        self.tblHistory.isHidden = true
                        self.lblMsg.isHidden = false
                    }else{
                        self.tblHistory.isHidden = false
                        self.lblMsg.isHidden = true
                    }
                }
            }else{
                showLoafjetAlert(msg: strServerNotRespondMsg.localiz(), inView: self.view)
            }
        }
    }
    
    //MARK: DELEGATE METHODS
    
    //MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrHistory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = self.arrHistory[section]["data"] as! [[String:Any]]
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        let arr = self.arrHistory[indexPath.section]["data"] as! [[String:Any]]
        let obj = arr[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let objDate = formatter.date(from: obj["date_created"] as! String)
        formatter.dateFormat = "hh:mm a"
        let strTime = formatter.string(from: objDate!)
        
        cell.lblTime.text = strTime
        
        if (obj["names"] as! [String]).count > 1{
            cell.lblName.text = "Group Scan".localiz() + " (\((obj["names"] as! [String]).count)x)"
        }else{
            if (obj["names"] as! [String]).count == 0{
                cell.lblName.text = "Single Scan".localiz()
            }else{
                cell.lblName.text = (obj["names"] as! [String])[0]
            }
        }
        
        if obj["cancelled"] as! Bool{
            cell.viewContainer.backgroundColor = hexStringToUIColor(hex: "B10101")
            cell.viewContainer.borderColor = .clear
            cell.viewContainer.borderWidth = 0
            cell.lblName.textColor = .white
            cell.lblTime.textColor = .white
            if LanguageManager.shared.currentLanguage == .en{
                cell.imgArrow.image = UIImage(named: "arrowNextWhite")
            }else{
                cell.imgArrow.image = UIImage(named: "arrowNextWhiteArb")
            }
        }else{
            cell.viewContainer.backgroundColor = .white
            cell.viewContainer.borderColor = hexStringToUIColor(hex: "505DA5")
            cell.viewContainer.borderWidth = 1.5
            cell.lblName.textColor = .black
            cell.lblTime.textColor = hexStringToUIColor(hex: "999999")
            if LanguageManager.shared.currentLanguage == .en{
                cell.imgArrow.image = UIImage(named: "arrowNextPurple")
            }else{
                cell.imgArrow.image = UIImage(named: "arrowNextPurpleArb")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HistoryHeaderTableViewCell") as! HistoryHeaderTableViewCell
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let objDate = formatter.date(from: self.arrHistory[section]["header"] as! String)
        formatter.dateFormat = "dd MMM yyyy"
        let strDateMain = formatter.string(from: objDate!)
        headerCell.lblDate.text = strDateMain
        return headerCell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arr = self.arrHistory[indexPath.section]["data"] as! [[String:Any]]
        let obj = arr[indexPath.row]
        if obj["cancelled"] as! Bool{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelledHistoryDetailViewController") as! CancelledHistoryDetailViewController
            vc.objPass = obj
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryDetailViewController") as! HistoryDetailViewController
            vc.objPass = obj
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
