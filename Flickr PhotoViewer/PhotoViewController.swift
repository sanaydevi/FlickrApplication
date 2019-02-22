//
//  PhotoViewController.swift
//  Flickr PhotoViewer
//
//  Created by Sanay Devi on 2/15/19.

import Foundation
import FlickrKit
import Toast
import UIKit


class PhotoViewController: UIViewController {
    
    var flickrPhoto: FlickrPhoto!
    var flickrPhotoMeta:FlickrPhotoMeta!
    var flickrHelperTwo : FlickrPhotoMeta!
    var UserAddCommentReturn : Comments!
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet var numberOfComments: UILabel!
    @IBOutlet var userComment: UITextField!
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var date: UILabel!
    @IBAction func addComment(_ sender: Any) {
        let userCommentString = userComment.text!
        print(userCommentString)
        let addCommentFn = FKFlickrPhotosCommentsAddComment()
        addCommentFn.comment_text = userCommentString
        addCommentFn.photo_id = flickrPhoto.photoId
        FlickrKit.shared().call(addCommentFn){ (response, error) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                if let response = response{
                    print(response)
                    let commentAddedAlert = UIAlertController(title: "Success", message: "Comment Added", preferredStyle: .alert)
                    let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                    commentAddedAlert.addAction(dismissAction)
                    self.present(commentAddedAlert, animated: true, completion: nil)
                    
                } else {
                    // Iterating over specific errors for each service
                    if let error = error as? NSError {
                        print(error)
                        
                        }
                }
            })
        }
    }
    struct Keys {
        static let flickrKey = "2a83295107d057cf2a23e799a08f9ad7"
    }
    
    struct Errors {
        static let invalidAccessErrorCode = 100
    }
    
    
    func setP(flickrPhoto: String) {
        imageTitle.text = flickrPhoto
        
    }
    func setMetaInfo(flickr : FlickrPhotoMeta!){
        username.text = flickr.username
        numberOfComments.text = flickr.numberOfComments
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getMetaInfo(photoId: flickrPhoto.photoId)
        photoImageView.sd_setImage(with: flickrPhoto.photoUrl as URL!)
        setP(flickrPhoto: flickrPhoto.title)
    
    }
    
    func getMetaInfo(photoId: String){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        FlickrProvider.getMetaData(photoId: photoId, onCompletion:{(error: NSError?, flickrMeta: FlickrPhotoMeta?)-> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if error == nil{
                self.flickrPhotoMeta = flickrMeta!
            }
            else{
                self.flickrPhotoMeta = nil
                if (error!.code == FlickrProvider.Errors.invalidAccessErrorCode) {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.showErrorAlert()
                    })
                }
            }
            DispatchQueue.main.async(execute: { () -> Void in
            self.username.text = flickrMeta?.username
            self.numberOfComments.text = flickrMeta?.numberOfComments
            self.location.text = flickrMeta?.location
            self.date.text = flickrMeta?.date
            
            
                })
        })
    }
    

    
    
    func showErrorAlert() {
        let alertController = UIAlertController(title: "Search Error", message: "Invalid API Key", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    
}
