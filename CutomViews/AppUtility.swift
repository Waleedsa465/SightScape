//
//  AppUtility.swift
//  Leenpay
//
//  Created by Hunain on 01/08/2022.
//

import Foundation
import UIKit
import SideMenu
import NVActivityIndicatorView
import Loafjet
import LanguageManager_iOS
import AVFoundation
import Reachability

let AppName = "SightScape Vendor"
let errorAlertTitle = "ERROR"
let errorScanAlertTitle = "Error"
let invalidSessionAlertTitle = "Invalid Session"
let strPicURL = "https://sightscape.com/"
//let strPicURL = "http://tahakhan.ddns.net:2020/"
let serverURL = "https://sightscape.com/"
//let serverURL = "http://tahakhan.ddns.net:2020/"
let serverAPIKey = "1367c930a07446b15f2f014c5312c185dc184bae4632d8939a31c908c4097d61"
let strTutorial = "strTutorial"
let strSkipLogin = "strSkipLogin"
let strLoginData = "strLoginData"
let strCurrentSession = "strCurrentSession"
let strApplanguageInitialSetting = "strApplanguageInitialSetting"
let strCurrentApplanguage = "strCurrentApplanguage"
let strNoInternetAlertMsg = "Establish Internet connection to resume interaction with the app."
let strServerNotRespondMsg = "Oops, something went wrong"
let strUpdateAlertTitle = "Update Available!"
let strUpdateAlertMsg = "A new version of SightScape Vendor is available. To continue using this app, please update to the latest version."
var isLoginProcessFromCart = false
var isProductSharingLink = false
var isNewAppVersionAvailable = false
var globalIsLoading = true
var strAppStoreVersion = ""
var globalLat = ""
var globalLong = ""
var strShareProductID = ""
var arrGlobalFilters = [[String:Any]]()
var arrAllProducts = [[String:Any]]()
var arrAllCategories = [[String:Any]]()
var arrAllWishList = [String]()
let ud = UserDefaults.standard
var strTokenAPNS = ""
var dataLogin = User()
var playerError: AVAudioPlayer?
var playerSuccess: AVAudioPlayer?

var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
var hudContainer = UIView(frame: CGRect(x:0, y:0, width: 50, height: 50))

//var UtilityUser: [User]? {didSet {}}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

internal func createActivityIndicator(_ uiView : UIView)->UIView{
    
    let container: UIView = UIView(frame: CGRect.zero)
    container.layer.frame.size = uiView.frame.size
    container.center = CGPoint(x: uiView.bounds.width/2, y: uiView.bounds.height/2)
    container.backgroundColor = UIColor(white: 0.2, alpha: 0.3)
    
    let loadingView: UIView = UIView()
    loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
    loadingView.center = container.center
    loadingView.backgroundColor = UIColor(white:0.1, alpha: 0.7)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    loadingView.layer.shadowRadius = 5
    loadingView.layer.shadowOffset = CGSize(width: 0, height: 4)
    loadingView.layer.opacity = 2
    loadingView.layer.masksToBounds = false
    loadingView.layer.shadowColor = UIColor.red.cgColor    //primary UIColor(red: 149/255, green: 116/255, blue: 205/255, alpha: 1)
    
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    actInd.clipsToBounds = true
    actInd.style = .whiteLarge
    
    actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
    loadingView.addSubview(actInd)
    container.addSubview(loadingView)
    container.isHidden = true
    container.isUserInteractionEnabled = true
    uiView.addSubview(container)
    uiView.bringSubviewToFront(container)
    actInd.startAnimating()
    
    return container
    
}

func isEmail(_ email:String  ) -> Bool
{
    let strEmailMatchstring = "\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"
    let regExPredicate = NSPredicate(format: "SELF MATCHES %@", strEmailMatchstring)
    if(!isEmpty(email as String?) && regExPredicate.evaluate(with: email))
    {
        return true;
    }
    else
    {
        return false;
    }
}

func isEmpty(_ thing : String? )->Bool {
    
    if (thing?.count == 0) {
        return true
    }
    return false;
}

internal func showAlert(title : String? ,message : String?, handler : ((UIAlertAction) -> Void)? = nil)->UIAlertController{
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title:  "OK".localiz(), style: .default, handler: handler))
    return alert
}

internal func setPageControlUI(pgControl:UIPageControl)->UIPageControl{
    if #available(iOS 14.0, *) {
        pgControl.currentPageIndicatorTintColor = hexStringToUIColor(hex: "505DA5")
        pgControl.pageIndicatorTintColor = hexStringToUIColor(hex: "CCCCCC")
            } else {
                // Fallback on earlier versions
                for index: Int in 0...pgControl.numberOfPages-1 {
                    //guard pgControl.subviews.count > index else { return }
                    let dot: UIView = pgControl.subviews[index]
                    dot.layer.cornerRadius = dot.frame.size.height / 2
                    if index == pgControl.currentPage {
                        dot.backgroundColor = hexStringToUIColor(hex: "505DA5")
                        dot.layer.borderWidth = 0
                    } else {
                        dot.backgroundColor = UIColor.clear
                        dot.layer.borderColor = hexStringToUIColor(hex: "505DA5").cgColor
                        dot.layer.borderWidth = 1
                    }
                }
    }
    return pgControl
}

/*func showMenu(controller:UIViewController){
    let story = UIStoryboard(name: "Main", bundle: nil)
    let menuVC = story.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
    menuVC.controllerLast = controller
    let drawerWidth = 300.0
    let menu = SideMenuNavigationController(rootViewController: menuVC)
    
    if LanguageManager.shared.currentLanguage == .en{
        menu.leftSide = true
    }else{
        menu.leftSide = false
    }
    //menu.leftSide = true
    menu.navigationBar.isHidden = true
    menu.statusBarEndAlpha = 0
    menu.alwaysAnimate = true
    menu.presentationStyle = SideMenuPresentationStyle.menuSlideIn
    menu.presentationStyle.presentingEndAlpha = 0.8
    menu.presentationStyle.onTopShadowOpacity = 0.5
    menu.presentationStyle.onTopShadowRadius = 5
    menu.presentationStyle.onTopShadowColor = .black
    menu.pushStyle = .popWhenPossible;
    menu.menuWidth = CGFloat(drawerWidth)
    SideMenuManager.default.addPanGestureToPresent(toView: controller.view)
    SideMenuManager.default.rightMenuNavigationController = nil
    controller.present(menu, animated: true, completion: nil)
}*/

//MARK: FullMaterialLoader Hud Methods

func showHud(viewHud:UIView){
    hudContainer.frame = viewHud.frame
    hudContainer.backgroundColor = hexStringToUIColor(hex: "FFFFFF").withAlphaComponent(0.5)
    hudContainer.isUserInteractionEnabled = true
    activityIndicatorView.color = hexStringToUIColor(hex: "505DA5")
    activityIndicatorView.center = viewHud.center
    hudContainer.addSubview(activityIndicatorView)
    viewHud.addSubview(hudContainer)
    //viewHud.bringSubviewToFront(hudContainer)
    activityIndicatorView.startAnimating()
}

func hideHud(viewHud:UIView){
    //viewHud.isUserInteractionEnabled = true
    activityIndicatorView.stopAnimating()
    hudContainer.removeFromSuperview()
}

//MARK: LoafJet Alert
func showLoafjetAlert(msg:String, inView:UIView){
    Loaf.PlainLoaf(message: msg, position: .top, loafWidth: 250, loafHeight: 40, cornerRadius: 10, fontStyle: "SF-Pro-Display-Medium", fontSize: 16, bgColor: .systemRed, fontColor: .white, alphaValue: 1.0, loafImage: nil, animationDirection: .Top, duration: 2, loafjetView: inView)
}

func showLoafjetSuccessAlert(msg:String, inView:UIView){
    Loaf.PlainLoaf(message: msg, position: .top, loafWidth: 250, loafHeight: 40, cornerRadius: 10, fontStyle: "SF-Pro-Display-Medium", fontSize: 16, bgColor: .systemGreen, fontColor: .white, alphaValue: 1.0, loafImage: nil, animationDirection: .Top, duration: 2, loafjetView: inView)
}

//MARK: Get & Set Methods For UserDefaults

func saveDefaultObject(obj:String,forKey strKey:String){
    ud.set(obj, forKey: strKey)
}

func getDefaultObject(forKey strKey:String) -> String {
    if let obj = ud.value(forKey: strKey) as? String{
        let obj2 = ud.value(forKey: strKey) as! String
        return obj2
    }else{
        return ""
    }
}

func deleteDefaultObject(forKey strKey:String) {
    ud.set(nil, forKey: strKey)
}

//MARK: Check Internet
import Reachability

func connected() -> Bool {
    let reachability = try? Reachability()

    do {
        try reachability?.startNotifier()
    } catch {
        print("Unable to start notifier")
    }

    guard let currentReachabilityStatus = reachability?.connection else {
        return false
    }

    return currentReachabilityStatus != .unavailable
}


//MARK: JSON String Method
func json(from object:Any) -> String? {
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
        return ""
    }
    return String(data: data, encoding: String.Encoding.utf8)
}

//MARK: Fource Logout

/*func fourceLogout(controllerView:UIView){
    arrAllWishList.removeAll()
    arrAllProducts.removeAll()
    UtilityUser = User.readUserFromArchive()
    UtilityUser?.remove(at: 0)
    UtilityProducts = Products.readProductsFromArchive()
    if (UtilityProducts != nil && UtilityProducts?.count != 0){
        UtilityProducts?.removeAll()
        if Products.saveProductsToArchive(products: UtilityProducts!){
        }
    }
    if User.saveUserToArchive(user: UtilityUser!){
        deleteDefaultObject(forKey: strCurrentSession)
        let story = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = story.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        let nav = UINavigationController(rootViewController: mainViewController)
        nav.navigationBar.isHidden = true
        controllerView.window?.rootViewController = nav
    }
}*/

//MARK: Convert Date Format
func changeDateFormat(oldFormat:String,newFormat:String,dt:String)->String{
    let formatter = DateFormatter()
    formatter.dateFormat = oldFormat
    let oldDate = formatter.date(from: dt)
    formatter.dateFormat = newFormat
    /*if LanguageManager.shared.currentLanguage == .en{
        formatter.locale = Locale(identifier: "en")
    }else{
        formatter.locale = Locale(identifier: "ar")
    }*/
    let formattedDate = formatter.string(from: oldDate!)
    return formattedDate
}

func generateUnixTimeStamp() -> String{
    let now = Date()
    let formatter = DateFormatter()
    //formatter.timeZone = TimeZone(abbreviation: "GMT+3")
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    var dateString = formatter.string(from: now)
    print(dateString)
    /*formatter.dateFormat = "ss"
    let dateString2 = formatter.string(from: now)
    var sec = Double(dateString2)
    sec = floor(sec! / 15.0) * 15.0
    let finalS = Int(sec!)
    dateString = dateString+":\(finalS)"
    print(dateString)
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"*/
    let dt = formatter.date(from: dateString)
    print(Int64(dt!.timeIntervalSince1970))
    return "\(Int64(dt!.timeIntervalSince1970))"
}

enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}

func isUpdateAvailable(completion: @escaping (Bool?, Error?) -> Void) throws -> URLSessionDataTask {
    guard let info = Bundle.main.infoDictionary,
        let currentVersion = info["CFBundleShortVersionString"] as? String,
        let identifier = info["CFBundleIdentifier"] as? String,
        let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
            throw VersionError.invalidBundleInfo
    }
    //Log.debug(currentVersion)
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        do {
            if let error = error { throw error }
            guard let data = data else { throw VersionError.invalidResponse }
            let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
            guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                throw VersionError.invalidResponse
            }
            strAppStoreVersion = version
            var update = false
            if Float(version)! > Float(currentVersion)!{
                update = true
            }
            completion(update, nil)
        } catch {
            completion(nil, error)
        }
    }
    task.resume()
    return task
}
func setBackButtonForArabic(mainview:UIView){
    for subview:AnyObject in mainview.subviews
    {
        if (subview.isKind(of: UIView.self))
        {
            let sView = subview as! UIView
            for subview:AnyObject in sView.subviews
            {
                if (subview.isKind(of: UIButton.self))
                {
                    let btn = subview as! UIButton
                    if btn.tag == 10 && LanguageManager.shared.currentLanguage == .ar{
                        btn.setImage(UIImage(named: "btnBackArb"), for: .normal)
                    }
                }
            }
        }
    }
}
