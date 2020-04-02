//
//  GalleryCollectionView.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 03/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase

class GalleryCollectionView: UICollectionView {
    
    //MARK: - Properties

    var cells = [Cash]()
    let currentUser = Auth.auth().currentUser
    var selectedCash: Cash?

    //MARK: - Init
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .clear
        delegate = self
        dataSource = self
        
        layout.minimumLineSpacing = Constants.galleryMinimumLineSpacing
        contentInset = UIEdgeInsets(top: 0, left: Constants.leftDistanceToSuperView, bottom: 0, right: Constants.rightDistanceToSuperView)
        register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseId)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(cells: [Cash]) {
        
        self.cells = cells
    }
}

extension GalleryCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseId, for: indexPath) as? GalleryCollectionViewCell else { fatalError() }
        
        cell.mainImageView.image = cells[indexPath.row].mainImage
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let currentUserUID = currentUser?.uid else { return }
        
        let cash = Cash.fetchCash()[indexPath.row]
        selectedCash = cash
        
        //FIXME: - realized selected cash logic 
        print("Index selected : \(indexPath.row)")
    }
}

extension GalleryCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: Constants.galleryItemWidth, height: frame.height * 0.8)
    }
}
