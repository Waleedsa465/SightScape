//
//  ScanViewController.swift
//  SightScapeVendor
//
//  Created by Hunain on 12/06/2023.
//

import UIKit
import Foundation
import AVFoundation
import LanguageManager_iOS

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{

    //MARK: Outlets
    @IBOutlet weak var imgScannerVector: UIImageView!
    @IBOutlet weak var viewNav: UIView!
    @IBOutlet weak var btnCancelScan: CustomButton!
    @IBOutlet weak var lblScanType: UILabel!
    @IBOutlet weak var btnCompleteScan: CustomButton!
    @IBOutlet weak var viewSuccess: UIView!
    @IBOutlet weak var lblSuccess: UILabel!
    
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var objPass = [String:Any]()
    var arrScan = [[String:String]]()
    var minScan = 0
    var maxScan = 0
    var currentScan = 0
    
    //MARK: View Life Cycle Start here...
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]  //[.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(previewLayer, at: 0)
        captureSession.startRunning()
        
        let rectOfInterest = previewLayer?.metadataOutputRectConverted(fromLayerRect: self.imgScannerVector.frame)
        //  videoPreviewLayer is AVCaptureVideoPreviewLayer
        metadataOutput.rectOfInterest = rectOfInterest ?? CGRect(x: 0, y: 0, width: 1, height: 1)
    }
    
    //MARK: Setup View
    func setupView() {
        self.setupAudioPlayers()
        if self.objPass["scan_type"] as! String == "single"{
            self.lblScanType.text = "Single Scan".localiz()
            self.btnCompleteScan.isHidden = true
        }else{
            self.minScan = self.objPass["group_activity_min_scans"] as! Int
            self.maxScan = self.objPass["group_activity_max_scans"] as! Int
            self.lblScanType.text = "Group Scan".localiz() + "(\(self.minScan)-\(self.maxScan))"
            self.btnCompleteScan.isHidden = false
            self.btnCompleteScan.backgroundColor = hexStringToUIColor(hex: "666666")
            self.btnCompleteScan.setTitle("Scaning...".localiz(), for: .normal)
            self.btnCompleteScan.isUserInteractionEnabled = false
        }
        self.lblSuccess.text = "Success".localiz()
    }
    
    //MARK: Utility Methods
    
    func setupAudioPlayers(){
        guard let url = Bundle.main.url(forResource: "fail", withExtension: "mp3") else { return }

            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                try AVAudioSession.sharedInstance().setActive(true)

                playerError = try AVAudioPlayer(contentsOf: url)

            } catch let error {
                print(error.localizedDescription)
            }
        
        guard let url = Bundle.main.url(forResource: "success", withExtension: "mp3") else { return }

            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                try AVAudioSession.sharedInstance().setActive(true)

                playerSuccess = try AVAudioPlayer(contentsOf: url)

            } catch let error {
                print(error.localizedDescription)
            }
    }
    
    //MARK: Button Action
    
    @IBAction func btnCancelScanAction(_ sender: Any) {
        self.dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name("PassScanClose"), object: nil)
    }
    
    @IBAction func btnCompleteScanAction(_ sender: Any) {
        let str = arrScan.toJSONString()
        let str2 = str.replacingOccurrences(of: "\\", with: "")
        print("after removing slashed \(str2)")
        var finalStr = ""
        if arrScan.count > 0{
            finalStr = str2
        }
        self.passScanAPI(objScan: finalStr)
    }
    
    @IBAction func btnCloseSuccessAction(_ sender: Any) {
        self.dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name("PassScanClose"), object: nil)
    }
    
    //MARK: API Methods
    
    func passScanAPI(objScan:String){
        if connected() == false{
            let alert = showAlert(title: errorAlertTitle, message: strNoInternetAlertMsg.localiz())
            self.present(alert, animated: true, completion: nil)
            return
        }
        showHud(viewHud: self.view)
        APIHandler.sharedInstance.venderPassScanAPI(scan: objScan, exc_id: "\(self.objPass["ID"] as! Int)") { result, responseObject in
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
                            let alert = UIAlertController(title: errorScanAlertTitle, message: msgAlert, preferredStyle: .alert)
                            let acOK = UIAlertAction(title: "OK".localiz(), style: .default) { (ac:UIAlertAction) in
                                DispatchQueue.main.async {
                                    if self.objPass["scan_type"] as! String == "single"{
                                        self.captureSession.startRunning()
                                    }
                                }
                            }
                            alert.addAction(acOK)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }else{
                    self.viewSuccess.isHidden = false
                }
            }else{
                showLoafjetAlert(msg: strServerNotRespondMsg.localiz(), inView: self.view)
            }
        }
    }
    
    func passCheckAPI(qrcode:String,time:String){
        if connected() == false{
            let alert = showAlert(title: errorAlertTitle, message: strNoInternetAlertMsg.localiz())
            self.present(alert, animated: true, completion: nil)
            return
        }
        showHud(viewHud: self.view)
        APIHandler.sharedInstance.vendorPassCheckAPI(qrcode: qrcode, scan_timestamp: time, exc_id: "\(self.objPass["ID"] as! Int)") { result, responseObject in
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
                            let alert = UIAlertController(title: errorScanAlertTitle, message: msgAlert, preferredStyle: .alert)
                            let acOK = UIAlertAction(title: "OK".localiz(), style: .default) { (ac:UIAlertAction) in
                                DispatchQueue.main.async {
                                    self.captureSession.startRunning()
                                }
                            }
                            alert.addAction(acOK)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }else{
                    self.captureSession.startRunning()
                    let obj = ["qrcode":qrcode,"scan_timestamp":time]
                    self.arrScan.append(obj)
                    self.currentScan = self.currentScan + 1
                    self.btnCompleteScan.setTitle("\(self.currentScan)x", for: .normal)
                    if self.currentScan >= self.minScan{
                        self.btnCompleteScan.setTitle("\("Complete Scan".localiz()) (\(self.currentScan)x)", for: .normal)
                        self.btnCompleteScan.isUserInteractionEnabled = true
                        self.btnCompleteScan.backgroundColor = hexStringToUIColor(hex: "505DA5")
                    }
                    if self.currentScan == self.maxScan{
                        self.captureSession.stopRunning()
                        self.btnCompleteScan.setTitle("\("Complete Scan".localiz()) (\(self.currentScan)x)", for: .normal)
                        self.btnCompleteScan.isUserInteractionEnabled = true
                        self.btnCompleteScan.backgroundColor = hexStringToUIColor(hex: "505DA5")
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
    
    //MARK: Scan Methods
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        } else {
            print("not support")
        }
    }
    
    func found(code: String) {
        print(code)
        captureSession.stopRunning()
        let array = code.components(separatedBy: "_")
        print(array)
        if array.count != 4{
            playerError?.play()
            let alert = UIAlertController(title: errorScanAlertTitle, message: "Not a valid SightScape pass".localiz(), preferredStyle: .alert)
            let acOK = UIAlertAction(title: "OK".localiz(), style: .default) { (ac:UIAlertAction) in
                DispatchQueue.main.async {
                    self.captureSession.startRunning()
                }
            }
            alert.addAction(acOK)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if self.objPass["scan_type"] as! String != "single"{
            if self.arrScan.count > 0{
                var isFound = false
                for obj in self.arrScan{
                    let previousCode = obj["qrcode"]
                    let preArray = previousCode!.components(separatedBy: "_")
                    if array[1] == preArray[1]{
                        isFound = true
                        break
                    }
                }
                if isFound{
                    playerError?.play()
                    let alert = UIAlertController(title: errorScanAlertTitle, message: "Pass already scanned".localiz(), preferredStyle: .alert)
                    let acOK = UIAlertAction(title: "OK".localiz(), style: .default) { (ac:UIAlertAction) in
                        DispatchQueue.main.async {
                            self.captureSession.startRunning()
                        }
                    }
                    alert.addAction(acOK)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
        }
        playerSuccess?.play()
        if self.objPass["scan_type"] as! String == "single"{
            self.arrScan.removeAll()
            let obj = ["qrcode":code,"scan_timestamp":generateUnixTimeStamp()]
            arrScan.append(obj)
            let str = arrScan.toJSONString()
            let str2 = str.replacingOccurrences(of: "\\", with: "")
            print("after removing slashed \(str2)")
            var finalStr = ""
            if arrScan.count > 0{
                finalStr = str2
            }
            self.passScanAPI(objScan: finalStr)
        }else{
            self.passCheckAPI(qrcode: code, time: generateUnixTimeStamp())
        }
    }
    
    func failed() {
        captureSession = nil
    }
    
    //MARK:- View Life Cycle End here...
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
