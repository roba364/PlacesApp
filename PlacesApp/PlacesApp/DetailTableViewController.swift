//
//  DetailTableViewController.swift
//  PlacesApp
//
//  Created by SofiaBuslavskaya on 25/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Cosmos

class DetailTableViewController: UITableViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var cosmosView: CosmosView!
    
    //MARK: - Properties
    
    var imageIsChanged = false
    var currentPlace: Place!
    var currentRating: Double = 0.0
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: tableView.frame.size.width,
                                                         height: 1))
        saveButton.isEnabled = false
        
        // cosmos view settings
        
        cosmosView.settings.fillMode = .half
        cosmosView.didTouchCosmos = { [weak self] rating in
            
            guard let self = self else { return }
            
            self.currentRating = rating
        }
        
        placeTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        setupEditScreen()
    }
    

    //MARK: - Actions
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
    }
    @IBAction func cancelButtonClicked(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    //MARK: - Helper functions
    
    func savePlace() {
        
        guard let placeName = placeTextField.text else { return }

        var image: UIImage?

        if imageIsChanged {
            image = placeImageView.image
        } else {
            image = UIImage(named: "imagePlaceholder")
        }
        
        let imageData = image?.pngData()
        
        let newPlace = Place(name: placeName,
                             location: locationTextField.text,
                             type: typeTextField.text,
                             imageData: imageData,
                             rating: currentRating)
        
        // check VC - add new place or edit place
        if currentPlace != nil {
            
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            }
        } else {
            
            StorageManager.saveObject(newPlace)
        }
    }
    
    private func setupEditScreen() {
         
        if currentPlace != nil {
            setupNavigationBar()
            imageIsChanged = true
            guard
                let data = currentPlace?.imageData,
                let image = UIImage(data: data)
                else { return }
            
            placeImageView.image = image
            placeImageView.contentMode = .scaleAspectFill
            placeTextField.text = currentPlace?.name
            locationTextField.text = currentPlace?.location
            typeTextField.text = currentPlace?.type
            cosmosView.rating = currentPlace.rating
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
    
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let cameraIcon = UIImage(named: "camera")
            let photoIcon = UIImage(named: "photo")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] (_) in
                
                guard let self = self else { return }
                
                self.chooseImagePicker(source: .camera)
            }
            cameraAction.setValue(cameraIcon, forKey: "image")
            cameraAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photoAction = UIAlertAction(title: "Photo", style: .default) { [weak self] (_) in
                
                guard let self = self else { return }
                
                self.chooseImagePicker(source: .photoLibrary)
                
            }
            photoAction.setValue(photoIcon, forKey: "image")
            photoAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(cameraAction)
            actionSheet.addAction(photoAction)
            actionSheet.addAction(cancelAction)
            
            present(actionSheet, animated: true)
        }
    }
    
    
    
}

    //MARK: - Textfield delegate

extension DetailTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        
        if placeTextField.text?.isEmpty == false {
            
            saveButton.isEnabled = true
        } else {
            
            saveButton.isEnabled = false
        }
    }
}

    //MARK: - UIImagePicker

extension DetailTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        placeImageView.image = info[.editedImage] as? UIImage
        placeImageView.contentMode = .scaleAspectFill
        placeImageView.clipsToBounds = true
        imageIsChanged = true
        dismiss(animated: true)
    }
}
