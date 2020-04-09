//
//  StartViewController.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 09/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import TinyConstraints
import Gifu

class StartViewController: UIViewController {
    
    //MARK: - Properties

    var networkManager = NetworkManager()
    
    var loadingTimer: Timer?
    
    lazy var loadingGif: GIFImageView = {
        
        let view = GIFImageView()
        view.contentMode = .scaleAspectFit
        view.animate(withGIFNamed: "loading2")
        
        return view
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.getFeed(url: WORLDWIDE_URL)
        
        setupViews()
        
        loadingTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(goToTabbar), userInfo: nil, repeats: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        loadingGif.stopAnimatingGIF()
        
    }
    
    //MARK: - Setup UI
    
    private func setupViews() {
        
        view.backgroundColor = .black
        
        view.addSubview(loadingGif)
        
        loadingGif.centerInSuperview()
        loadingGif.width(view.frame.width)
        loadingGif.height(view.frame.width)
        loadingGif.leftToSuperview()
        loadingGif.rightToSuperview()
        
    }
    
    //MARK: - Selector
    
    @objc private func goToTabbar() {
        
        performSegue(withIdentifier: "toTabbar", sender: nil)
    }


}
