//
//  GalleryCollectionViewCell.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 03/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "Cell"
    
    let mainImageView: UIImageView = {
        
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
        
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(mainImageView)
        
        mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
