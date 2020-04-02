//
//  ChatViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 19/02/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController
import MobileCoreServices
import AVKit

class ChatViewController: JSQMessagesViewController {

    var messages = [JSQMessage]()
    var avatarDict = [String: JSQMessagesAvatarImage]()
    var usersRef = Database.database().reference().child("users")
    var messageRef = Database.database().reference().child("users").child("messages")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentUser = Auth.auth().currentUser {
            self.senderId = currentUser.uid
        }
        
        self.senderDisplayName = "RobRob"
        
        observeMessages()
    }
    
    private func observeUser(id: String) {
       
        Database.database().reference().child("users").observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {

                let avatarUrl = dict["profileUrl"] as! String

                self.setupAvatar(url: avatarUrl, messageId: id)
            }
        }
    }
    
    private func setupAvatar(url: String, messageId: String) {

        if url != "" {
            
            let fileUrl = URL(string: url)

            let data = try? Data(contentsOf: fileUrl!)
            let image = UIImage(data: data!)
            let userImg = JSQMessagesAvatarImage.avatar(with: image)
            avatarDict[messageId] = userImg
            
        } else {
            
            //TODO: - Set friend's avatar
            
            avatarDict[messageId] = JSQMessagesAvatarImage.avatar(with: UIImage(named: "gen_user"))
        }
        
        collectionView.reloadData()
    }
    
    private func observeMessages() {
        
        DispatchQueue.main.async {
            self.messageRef.observe(.childAdded) { [weak self] (snapshot) in
                
                guard let self = self else { return }
                
                if let dict = snapshot.value as? [String: AnyObject] {
                    let mediaType = dict["MediaType"] as! String
                    let senderId = dict["senderId"] as! String
                    let senderName = dict["senderName"] as! String
                    
                    self.observeUser(id: senderId)
                    
                    switch mediaType {
                        
                    case "TEXT":
                        
                        let text = dict["text"] as! String
                        self.messages.append(JSQMessage(senderId: senderId, displayName: senderName, text: text))
                        
                    case "PHOTO":
                        
                        let photo = JSQPhotoMediaItem(image: nil)
                        let fileUrl = dict["fileUrl"] as! String
                        guard let url = URL(string: fileUrl) else { return }
                        DispatchQueue.global().async {
                            let data = try? Data(contentsOf: url)
                            let image = UIImage(data: data!)
                            photo?.image = image
                            self.collectionView.reloadData()
                            print("This will be printed after")
                        }
                        print("This will be printed before")
                        
                        
                        
                        self.messages.append(JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: photo))
                        
                        if self.senderId == senderId {
                            
                            photo?.appliesMediaViewMaskAsOutgoing = true
                        } else {
                            photo?.appliesMediaViewMaskAsOutgoing = false
                        }
                        
                    case "VIDEO":
                        
                        let fileUrl = dict["fileUrl"] as! String
                        let video = URL(string: fileUrl)
                        let videoItem = JSQVideoMediaItem(fileURL: video, isReadyToPlay: true)
                        self.messages.append(JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: videoItem))
                        
                        if self.senderId == senderId {
                            
                            videoItem?.appliesMediaViewMaskAsOutgoing = true
                        } else {
                            videoItem?.appliesMediaViewMaskAsOutgoing = false
                        }
                        
                    default:
                        print("Unknown data type")
                    }
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Press buttons

    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let newMessage = messageRef.childByAutoId()
        let messageData = ["text": text, "senderId": senderId, "senderName": senderDisplayName, "MediaType": "TEXT"]
        newMessage.setValue(messageData)
        self.finishSendingMessage()
    }
    
    
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        print("didPressAccessoryButton")
        
        let sheet = UIAlertController(title: "Media Messages", message: "Please select a media", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { (alert) in
            
        }
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { [weak self] (alert) in
            
            guard let self = self else { return }
            
            self.getMediaFrom(type: kUTTypeImage)
        }
        
        let videoLibrary = UIAlertAction(title: "Video Library", style: .default) { [weak self] (alert) in
                       
            guard let self = self else { return }
                       
            self.getMediaFrom(type: kUTTypeMovie)
        }
        
        sheet.addAction(photoLibrary)
        sheet.addAction(videoLibrary)
        sheet.addAction(cancel)
        
        present(sheet, animated: true, completion: nil)

    }
    
    private func getMediaFrom(type: CFString) {
        print(type)
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.mediaTypes = [type as String]
        self.present(mediaPicker, animated: true, completion: nil)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("messages count - \(messages.count)")
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = messages[indexPath.item]
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        if message.senderId == self.senderId {
            
            return bubbleFactory?.outgoingMessagesBubbleImage(with: .blue)
        } else {
            
            return bubbleFactory?.incomingMessagesBubbleImage(with: .green)
        }
        
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        print("didTapMessageBubbleAt : \(indexPath.item)")
        let message = messages[indexPath.item]
        
        if message.isMediaMessage {
            if let mediaItem = message.media as? JSQVideoMediaItem {
                let player = AVPlayer(url: mediaItem.fileURL)
                let playerVC = AVPlayerViewController()
                playerVC.player = player
                present(playerVC, animated: true, completion: nil)
            }
            
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = messages[indexPath.item]
        
        return avatarDict[message.senderId]
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell
    }
    
    private func sendMedia(picture: UIImage?, video: URL?) {
        
        if let picture = picture {
            let filePath = "\(Auth.auth().currentUser!)/\(Date.timeIntervalSinceReferenceDate)"
            
            let data = picture.jpegData(compressionQuality: 0.1)
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            DispatchQueue.main.async {
                Storage.storage().reference().child(filePath).putData(data!, metadata: metadata) { (metadata, error) in
                    if error != nil {
                        print("Failed to storage data/metadata at sendMedia :", error?.localizedDescription)
                        return
                    }
                    
                    metadata?.storageReference?.downloadURL(completion: { [weak self] (url, error) in
                        
                        guard let self = self else { return }
                        
                        if error != nil {
                            print("Failed to storageRef by downloading URL :", error?.localizedDescription)
                            return
                        }
                        
                        if let fileUrl = url?.absoluteString {
                            guard let senderId = self.senderId,
                                let senderDisplayName = self.senderDisplayName
                                else { print("SOME NIL OBJECT HERE")
                                    return }
                            print("FILE URL---->\(fileUrl)")
                            let newMessage = self.messageRef.childByAutoId()
                            let messageData = ["fileUrl": fileUrl, "senderId": senderId, "senderName": senderDisplayName, "MediaType": "PHOTO"] as [String : Any]
                            newMessage.setValue(messageData)
                        }
                    })
                }
            }
        } else if let video = video {
            
            let filePath = "\(Auth.auth().currentUser!)/\(Date.timeIntervalSinceReferenceDate)"

            let data = try? Data(contentsOf: video)
            let metadata = StorageMetadata()
            metadata.contentType = "video/mp4"
            DispatchQueue.main.async {
                Storage.storage().reference().child(filePath).putData(data!, metadata: metadata) { (metadata, error) in
                        if let error = error {
                            print("Failed to storage data/metadata at sendMedia :", error.localizedDescription)
                            return
                        }
                        
                    metadata?.storageReference?.downloadURL(completion: { [weak self] (url, error) in
                        
                        guard let self = self else { return }
                        
                        if error != nil {
                            print("Failed to storageRef by downloading URL :", error?.localizedDescription)
                            return
                        }
                        
                        if let fileUrl = url?.absoluteString {
                            guard let senderId = self.senderId,
                                  let senderDisplayName = self.senderDisplayName
                                else { print("SOME NIL OBJECT HERE")
                                    return }
                            print("FILE URL---->\(fileUrl)")
                            let newMessage = self.messageRef.childByAutoId()
                            let messageData = ["fileUrl": fileUrl, "senderId": senderId, "senderName": senderDisplayName, "MediaType": "VIDEO"] as [String : Any]
                            newMessage.setValue(messageData)
                        }
                    })
                    
                        
                        
                    }
                }
        }
    }
    
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("did finish picking")
        // get image
        
        if let picture = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            sendMedia(picture: picture, video: nil)
        } else if let video = info[UIImagePickerController.InfoKey.mediaURL] as? URL {

            sendMedia(picture: nil, video: video)
        }
        
        
        self.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
    
    
}
