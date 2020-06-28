//
//  UIViewController.swift
//  VirtualTourist
//
//  Created by M7md on 23/06/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title: String , message: String){
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default , handler: nil))
        DispatchQueue.main.async {
              self.present(alert, animated: true, completion: nil)
        }
      
    }
}
