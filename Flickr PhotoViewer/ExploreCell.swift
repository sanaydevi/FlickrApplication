//
//  ExploreCell.swift
//  Flickr PhotoViewer
//
//  Created by Sanay Devi

import UIKit
import MapleBacon

class ExploreCell: UICollectionViewCell {
    
    //Identifier
    static let identifier = "ExploreCell"
    //MARK: Outlets
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    @IBOutlet weak var imageView : UIImageView!
    
    
    var photoURL : URL?{
        
    didSet{
    DispatchQueue.main.async(execute: {
                if let URL = self.photoURL  {
        self.activityIndicator.startAnimating()
        self.imageView.setImage(withUrl: URL, placeholder: nil, crossFadePlaceholder: false, cacheScaled: false, completion: { (image, error) in
        self.activityIndicator.stopAnimating()
                    })
                }
            })
        }
        
    }
    
    
    
}
