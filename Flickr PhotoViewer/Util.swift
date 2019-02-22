//
//  Util.swift
//  Flickr PhotoViewer
//
//  Created by Sanay Devi

import UIKit

class Util: NSObject {
    //Screen bounds
    static let bounds = UIScreen.main.bounds
    //General alert
    static func showAlert(sender: UIViewController, title: String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        sender.present(alert, animated: true, completion: nil)
        
        
    }
 
    
    
   }
