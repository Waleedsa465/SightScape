//
//  TabBarViewController.swift
//  SightScapeVendor
//
//  Created by Hunain on 12/06/2023.
//

import UIKit

class TabBarViewController: UITabBarController {

    //MARK: Outlets
    
    //MARK: View Life Cycle Start here...
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupView()
    }
    
    //MARK: Setup View
    func setupView() {
        self.selectedIndex = 1
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
