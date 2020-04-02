//
//  FindYourFriendsViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 25/02/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

class FindYourFriendsViewController: UIViewController {

    @IBOutlet weak var allUsersView: UIView!
    @IBOutlet weak var friendsView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.cornerRadius = 5
        segmentedControl.layer.borderColor = UIColor.lightGray.cgColor
        
        startPageView()
    }
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            friendsView.alpha = 0
            allUsersView.alpha = 1
        } else {
            friendsView.alpha = 1
            allUsersView.alpha = 0
        }
    }
    
    final func startPageView() {
        friendsView.alpha = 0
        allUsersView.alpha = 1
    }

}
