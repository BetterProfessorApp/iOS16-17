//
//  PhotoDetailViewController.swift
//  BetterProfessor
//
//  Created by Bhawnish Kumar on 6/23/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit
import Photos

class PhotoDetailViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {

    var photoController: PhotoController?
    var photo: Photo?
    var student: Student?
    var viewTitle = "Create Photo"
     // swiftlint:disable:next identifier_name
    let 🖼 = UIImagePickerController()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var theTextField: UITextField!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var subjectLabel: UILabel!
    
    @IBAction func save(_ sender: Any) {
        // TODO: Unless you use an unwind, a segue always presents a new view controller each time it is called.
        navigationController?.popViewController(animated: true)
    }

    @IBAction func addPhoto(_ sender: Any) {
        🖼.allowsEditing = false
        🖼.delegate = self
        present(🖼, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        🖼.delegate = self
        self.title = viewTitle

        // Do any additional setup after loading the view.
        updateViews()
    }
    
    func updateViews() {
        guard let student = student else { return }
    }

    // MARK: Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.originalImage] as? UIImage {
            
            imageView.image = image
        }
        
        // TODO: Why did call this remove PhotoDetailViewController?
        // navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
