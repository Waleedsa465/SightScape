//
//  ModelObjects.swift
//  VCard
//
//  Created by Hunain on 24/07/2023.
//

import Foundation


//MARK: User
struct LoginResponse: Codable{
    var alert_en: String?
    var alert_ar: String?
    var data: User?
}

struct User: Codable{
    var ID: Int?
    var last_login: String?
    var session: String?
    var vendor_id: Int?
    var username: String?
    var role: String?
    var name: String?
    var archived: Bool?
    var date_created: String?
    var exc_ids: String?
}

//MARK: Save User Archive Methods

func saveUserToArchive(data: User) {
    do {
        // Create JSON Encoder
        let encoder = JSONEncoder()
        // Encode Note
        let data = try encoder.encode(data)
        // Write/Set Data
        UserDefaults.standard.set(data, forKey: strLoginData)
    } catch {
        print("Unable to Encode Note (\(error))")
    }
}

func readUserFromArchive()-> Bool{
    if let data = UserDefaults.standard.data(forKey: strLoginData) {
        do {
            // Create JSON Decoder
            let decoder = JSONDecoder()
            // Decode Note
            let loginData = try decoder.decode(User.self, from: data)
            dataLogin = loginData
            return true
        } catch {
            print("Unable to Decode Note (\(error))")
            return false
        }
    }else{
        return false
    }
}
