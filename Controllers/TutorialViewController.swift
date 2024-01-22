//
//  TutorialViewController.swift
//  SightScapeVendor
//
//  Created by Hunain on 12/06/2023.
//

import UIKit
import LanguageManager_iOS

class TutorialViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var pgControl: UIPageControl!
    
    //MARK: View Life Cycle Start here...
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    //MARK: Setup View
    func setupView() {
        self.pgControl = setPageControlUI(pgControl: self.pgControl)
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
    
    //MARK: Button Action
    @IBAction func btnGetStartedAction(_ sender: Any) {
        saveDefaultObject(obj: "1", forKey: strTutorial)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
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
