//
//  SplashViewController.swift
//  SightScapeVendor
//
//  Created by Hunain on 12/06/2023.
//

import UIKit

class SplashViewController: UIViewController {

    //MARK: Outlets
    
    //MARK: View Life Cycle Start here...
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if getDefaultObject(forKey: strTutorial) == "1"{
            if readUserFromArchive() {
                let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                let nav = UINavigationController(rootViewController: mainViewController)
                nav.navigationBar.isHidden = true
                self.view.window?.rootViewController = nav
            }else{
                let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                let nav = UINavigationController(rootViewController: mainViewController)
                nav.navigationBar.isHidden = true
                self.view.window?.rootViewController = nav
            }
        }else{
            let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "TutorialViewController") as! TutorialViewController
            let nav = UINavigationController(rootViewController: mainViewController)
            nav.navigationBar.isHidden = true
            self.view.window?.rootViewController = nav
        }
    }
    
    //MARK: Setup View
    func setupView() {
        
    }
    
    //MARK: Utility Methods
    
    //MARK: Button Action
    
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
