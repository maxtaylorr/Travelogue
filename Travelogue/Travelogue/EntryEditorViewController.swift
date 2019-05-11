//
//  EntryEditorViewController.swift
//  Travelogue
//
//  Created by Max Taylor on 5/10/19.
//  Copyright © 2019 Max Taylor. All rights reserved.
//

import UIKit
import CoreData

class EntryEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentTextField: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var dateFormatter = DateFormatter()
    let newEntryDateFormatter = DateFormatter()
    var entry: Entry?
    var trip: Trip?
    var image: UIImage?
    
    let newNoteDateFormatter = DateFormatter()
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        newEntryDateFormatter.dateStyle = .medium
        
        if let entry = entry {
            titleField.text = entry.name
            contentTextField.text = entry.content
            image = entry.image
            imageView.image = image
        } else {
            titleField.text = ""
            contentTextField.text = ""
            imageView.image = nil
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func selectImage(_ sender: Any) {
        selectImageSource()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleField.text?.trimmingCharacters(in: .whitespaces), !title.isEmpty else {
            alertNotifyUser(message: "Please enter a title before saving the note.")
            return
        }
        
        if let entry = entry {
            entry.name = titleField.text
            entry.content = contentTextField.text
            entry.image = image
        } else {
            entry = Entry(name: titleField.text, content: contentTextField.text, image: image, trip: trip!)
        }
        
        if let entry = entry {
            do {
                let managedContext = entry.managedObjectContext
                try managedContext?.save()
            } catch {
                alertNotifyUser(message: "The entry could not be saved.")
            }
            
        } else {
            alertNotifyUser(message: "The entry could not be created.")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func selectImageSource() {
        let alert = UIAlertController(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            (alertAction) in
            self.takePhotoUsingCamera()
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {
            (alertAction) in
            self.selectPhotoFromLibrary()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func takePhotoUsingCamera() {
        if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
            alertNotifyUser(message: "This device has no camera.")
            return
        }
        
        imagePickerController.sourceType = .camera
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func selectPhotoFromLibrary() {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            imagePickerController.dismiss(animated: true, completion: nil)
        }
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        image = selectedImage
        imageView.image = image
        if let entry = entry {
            entry.image = selectedImage
        }
    }
    
    func alertNotifyUser(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
