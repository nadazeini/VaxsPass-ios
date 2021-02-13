//
//  HomeViewController.swift
//  VaxsPass
//
//  Created by Pushpinder Pal Singh on 13/02/21.
//

import UIKit
import Vision

class HomeViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let image = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.delegate = self
        image.allowsEditing = false
    }
    
    @IBAction func addDocumentsPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose a Source", message: "From where would you like to add the document?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.image.sourceType = .camera
            self.present(self.image, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.image.sourceType = .photoLibrary
            self.present(self.image, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
}
