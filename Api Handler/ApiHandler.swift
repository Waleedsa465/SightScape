
//  ApiHandler.swift
//  Logigates
//
//  Created by Jawad Saud on 22/12/2021.
//

import UIKit
import Foundation
import Alamofire

private let SharedInstance = APIHandler()

class APIHandler: NSObject {
    
    var baseApiPath:String!

    
    class var sharedInstance : APIHandler {
        return SharedInstance
    }
    
    override init() {
        self.baseApiPath = "\(serverURL)API/?API_KEY=\(serverAPIKey)"
    }
    
    //MARK: User
    func loginAPI(username: String, password: String, completionHandler: @escaping (_ result: Bool, _ responseObject: NSDictionary?) -> Void) {
        
        var parameters = [String: String]()
        parameters = [
            "action": "vendor_user_signin",
            "username": username,
            "password": password,
            "device_token": strTokenAPNS,
            "lang": getDefaultObject(forKey: strCurrentApplanguage)
        ]
        print(parameters)
        
        let finalURL = "\(self.baseApiPath!)"
        print(finalURL)
        
        AF.request(finalURL, method: .post, parameters: parameters, encoder: URLEncodedFormParameterEncoder.default).response { response in
            switch response.result {
            case .success(let data):
                if let str = String(data: data ?? Data(), encoding: .utf8) {
                    print(str)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: .mutableContainers)
                        let dict = json as? NSDictionary
                        print(dict)
                        completionHandler(true, dict)
                    } catch {
                        completionHandler(false, nil)
                    }
                } else {
                    completionHandler(false, nil)
                }
            case .failure(_):
                completionHandler(false, nil)
            }
        }
    }
    //MARK: Excursions
    func getExcursionListAPI(completionHandler: @escaping (_ result: Bool, _ responseObject: NSDictionary?) -> Void) {

        guard let session = dataLogin.session else {
            // Handle the case where session is nil
            completionHandler(false, nil)
            return
        }

        var parameters = [
            "action": "vendor_exc_list",
            "session": session,
            "lang": getDefaultObject(forKey: strCurrentApplanguage) ?? "en"
        ]
        print(parameters)

        guard let finalURL = self.baseApiPath else {
            // Handle the case where baseApiPath is nil
            completionHandler(false, nil)
            return
        }

        print(finalURL)

        AF.request(finalURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .response { response in
                switch response.result {
                case .success(let data):
                    let str = String(decoding: data!, as: UTF8.self)
                    print(str)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        if let dict = json as? NSDictionary {
                            print(dict)
                            completionHandler(true, dict)
                        } else {
                            completionHandler(false, nil)
                        }
                    } catch {
                        completionHandler(false, nil)
                    }

                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completionHandler(false, nil)
                }
            }
    }

    func venderPassScanAPI(scan: String, exc_id: String, completionHandler: @escaping (_ result: Bool, _ responseObject: NSDictionary?) -> Void) {

        guard let session = dataLogin.session else {
            // Handle the case where session is nil
            completionHandler(false, nil)
            return
        }

        var parameters = [
            "action": "vendor_pass_scan",
            "session": session,
            "exc_id": exc_id,
            "scan": scan,
            "lang": getDefaultObject(forKey: strCurrentApplanguage) ?? "en"
        ]
        print(parameters)

        guard let finalURL = self.baseApiPath else {
            // Handle the case where baseApiPath is nil
            completionHandler(false, nil)
            return
        }

        print(finalURL)

        AF.request(finalURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .response { response in
                switch response.result {
                case .success(let data):
                    let str = String(decoding: data!, as: UTF8.self)
                    print(str)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        if let dict = json as? NSDictionary {
                            print(dict)
                            completionHandler(true, dict)
                        } else {
                            completionHandler(false, nil)
                        }
                    } catch {
                        completionHandler(false, nil)
                    }

                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completionHandler(false, nil)
                }
            }
    }
    func vendorPassCheckAPI(qrcode: String, scan_timestamp: String, exc_id: String, completionHandler: @escaping (_ result: Bool, _ responseObject: NSDictionary?) -> Void) {

        guard let session = dataLogin.session else {
            // Handle the case where session is nil
            completionHandler(false, nil)
            return
        }

        var parameters = [
            "action": "vendor_pass_check",
            "session": session,
            "exc_id": exc_id,
            "scan_timestamp": scan_timestamp,
            "qrcode": qrcode,
            "lang": getDefaultObject(forKey: strCurrentApplanguage) ?? "en"
        ]
        print(parameters)

        guard let finalURL = self.baseApiPath else {
            // Handle the case where baseApiPath is nil
            completionHandler(false, nil)
            return
        }

        print(finalURL)

        AF.request(finalURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .response { response in
                switch response.result {
                case .success(let data):
                    let str = String(decoding: data!, as: UTF8.self)
                    print(str)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        if let dict = json as? NSDictionary {
                            print(dict)
                            completionHandler(true, dict)
                        } else {
                            completionHandler(false, nil)
                        }
                    } catch {
                        completionHandler(false, nil)
                    }

                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completionHandler(false, nil)
                }
            }
    }
    func getHistoryListAPI(completionHandler: @escaping (_ result: Bool, _ responseObject: NSDictionary?) -> Void) {

        guard let session = dataLogin.session else {
            // Handle the case where session is nil
            completionHandler(false, nil)
            return
        }

        var parameters = [
            "action": "vendor_pass_history",
            "session": session,
            "lang": getDefaultObject(forKey: strCurrentApplanguage) ?? "en"
        ]
        print(parameters)

        guard let finalURL = self.baseApiPath else {
            // Handle the case where baseApiPath is nil
            completionHandler(false, nil)
            return
        }

        print(finalURL)

        AF.request(finalURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .response { response in
                switch response.result {
                case .success(let data):
                    let str = String(decoding: data!, as: UTF8.self)
                    print(str)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        if let dict = json as? NSDictionary {
                            print(dict)
                            completionHandler(true, dict)
                        } else {
                            completionHandler(false, nil)
                        }
                    } catch {
                        completionHandler(false, nil)
                    }

                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completionHandler(false, nil)
                }
            }
    }
    
    func cancelScanAPI(scan_id: String, completionHandler: @escaping (_ result: Bool, _ responseObject: NSDictionary?) -> Void) {

        guard let session = dataLogin.session else {
            // Handle the case where session is nil
            completionHandler(false, nil)
            return
        }

        var parameters = [
            "action": "vendor_scan_cancel",
            "session": session,
            "scan_id": scan_id,
            "lang": getDefaultObject(forKey: strCurrentApplanguage) ?? "en"
        ]
        print(parameters)

        guard let finalURL = self.baseApiPath else {
            // Handle the case where baseApiPath is nil
            completionHandler(false, nil)
            return
        }

        print(finalURL)

        AF.request(finalURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .response { response in
                switch response.result {
                case .success(let data):
                    let str = String(decoding: data!, as: UTF8.self)
                    print(str)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                        if let dict = json as? NSDictionary {
                            print(dict)
                            completionHandler(true, dict)
                        } else {
                            completionHandler(false, nil)
                        }
                    } catch {
                        completionHandler(false, nil)
                    }

                case .failure(let error):
                    print("Request failed with error: \(error)")
                    completionHandler(false, nil)
                }
            }
    }
}

