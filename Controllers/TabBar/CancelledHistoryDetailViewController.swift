//
//  CancelledHistoryDetailViewController.swift
//  SightScapeVendor
//
//  Created by Hunain on 01/10/2023.
//

import UIKit
import LanguageManager_iOS

class CancelledHistoryDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
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
    @IBOutlet weak var lblCancelBy: UILabel!
    @IBOutlet weak var lblCancelDateTime: UILabel!
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
        self.lblCancelBy.text = self.objPass["cancelled_by"] as! String
        if self.objPass["scan_type"] as! String == "group"{
            self.lblScanType.text = "Group Scan".localiz()
        }else{
            self.lblScanType.text = "Single Scan".localiz()
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
        let objDateCancel = formatter.date(from: self.objPass["date_cancelled"] as! String)
        formatter.dateFormat = "dd MMM yyyy - hh:mm a"
        let strTime = formatter.string(from: objDate!)
        let strTimeCancel = formatter.string(from: objDateCancel!)
        self.lblDateTime.text = strTime
        self.lblCancelDateTime.text = strTimeCancel
    }
    
    
    //MARK: Utility Methods
    
    //MARK: Button Action
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: API Methods
    
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
