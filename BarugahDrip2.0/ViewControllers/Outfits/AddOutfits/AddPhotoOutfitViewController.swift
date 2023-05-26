//
//  AddPhotoOutfitViewController.swift
//  BarugahDrip2.0
//
//  Created by Eskay Yap on 19/5/2023.
//

import UIKit

class AddPhotoOutfitViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var selectedGarments = [Garment]()
    
    @IBOutlet weak var imageView: UIImageView!
    
    weak var databaseController: DatabaseProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        databaseController = appDelegate?.databaseController
    }
    
    @IBAction func pickPhotoButton(_ sender: Any) {
        let controller = UIImagePickerController()
        controller.allowsEditing = false
        controller.delegate = self
        
        let actionSheet = UIAlertController(title: nil, message: "Select Option:", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
            controller.sourceType = .camera
            self.present(controller, animated: true, completion: nil)
        }
        
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
            controller.sourceType = .photoLibrary
            self.present(controller, animated: true, completion: nil)
        }
        
        let albumAction = UIAlertAction(title: "Photo Album", style: .default) { action in
            controller.sourceType = .savedPhotosAlbum
            self.present(controller, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(cameraAction)
        }
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(albumAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func nextButton(_ sender: Any) {
        guard let _ = imageView.image else {
            displayMessage(title: "Error", message: "Cannot save until an image has been selected!")
            return
        }
        self.performSegue(withIdentifier: "addOutfitName", sender: self)
        
    }
        
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addOutfitName"{
            let destination = segue.destination as! AddOutfitViewController
            destination.selectedImage = self.imageView.image
            destination.selectedGarments = selectedGarments
        }
    }
    
    

}
