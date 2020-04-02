//
//  RootMyBetsViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 06/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

class RootMyBetsViewController: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var pendingView: UIView!
    @IBOutlet weak var confirmedView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startPageView()
        
        segmentedControl.layer.borderWidth = 1
        segmentedControl.layer.cornerRadius = 5
        segmentedControl.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    //MARK: - Actions
    
    @IBAction func switchViews(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            ownerView.alpha = 1
            pendingView.alpha = 0
            confirmedView.alpha = 0
        } else if sender.selectedSegmentIndex == 1 {
            ownerView.alpha = 0
            pendingView.alpha = 1
            confirmedView.alpha = 0
        } else {
            ownerView.alpha = 0
            pendingView.alpha = 0
            confirmedView.alpha = 1
        }
    }
    
    final func startPageView() {
        ownerView.alpha = 1
        pendingView.alpha = 0
        confirmedView.alpha = 0
    }
    

}
