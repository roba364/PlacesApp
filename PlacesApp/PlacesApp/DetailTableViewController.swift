//
//  DetailTableViewController.swift
//  PlacesApp
//
//  Created by SofiaBuslavskaya on 25/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    
    //MARK: - Properties
    
    var newPlace: Place?
    var imageIsChanged = false
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    

    //MARK: - Actions
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
    }
    @IBAction func cancelButtonClicked(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
    //MARK: - Helper functions
    
    func saveNewPlace() {
        
        var image: UIImage?

        if imageIsChanged {
            image = placeImageView.image
        } else {
            image = UIImage(named: "imagePlaceholder")
        }
        
        newPlace = Place(name: nameTextField.text!,
                         location: locationTextField.text!,
                         type: typeTextField.text!,
                         image: placeImageView.image,
                         placeImage: nil)
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
        
        if nameTextField.text?.isEmpty == false {
            
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
