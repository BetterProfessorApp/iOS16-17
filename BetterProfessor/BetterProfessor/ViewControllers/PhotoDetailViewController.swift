//
//  PhotoDetailViewController.swift
//  BetterProfessor
//
//  Created by Bhawnish Kumar on 6/23/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit
import Photos

class PhotoDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var imageView = UIImageView()
    private var titleTextField = UITextField()
    private var addButton = UIButton()
    private var barButton = UIBarButtonItem()
    
    var photo: Photo? {
        didSet {
            updateViews()
        }
    }
    var photoController: PhotoController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
        
    }

    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        guard let image = info[.originalImage] as? UIImage else { return }

        imageView.image = image
    }

    // MARK: - Subviews
    private func setUpSubviews() {
        // Adding subview
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        view.addSubview(titleTextField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.rightBarButtonItem = barButton

        // adding targets && titles
        imageView.image = UIImage(named: "addImage")
        addButton.setTitle("Add Image", for: .normal)
        addButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        addButton.backgroundColor = .blue
        titleTextField.placeholder = "Give this photo a title"
        barButton.title = "Save Photo"
        barButton.action = #selector(savePhoto)
        title = "Create Photo"
        titleTextField.textAlignment = .center
        titleTextField.textColor = .black
        // Constraints
        // Image view
        imageView.backgroundColor = .gray
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0).isActive = true

        //add button
        addButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true

        // textfield
        titleTextField.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true


    }

// MARK: - Update views

    // MARK: - Private Methods

    @objc private func addImage() {

        let authorizationStatus = PHPhotoLibrary.authorizationStatus()

        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()

        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in

                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    return
                }
                self.presentImagePickerController()
            }
        default:
            break
        }
    }

    @objc private func savePhoto() {

        guard let image = imageView.image,
            let imageData = image.pngData()
else { return }
        
        if let photo = photo {
            photoController?.update(photo: photo, with: imageData)
        } else {
            photoController?.createPhoto(with: imageData)
        }
        
        navigationController?.popViewController(animated: true)
    }

    private func updateViews() {
        guard let photo = photo else {
            title = "Create Photo"
            return
        }

        imageView.image = UIImage(data: photo.imageData)

    }

    private func presentImagePickerController() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let imagePicker = UIImagePickerController()

        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self

        present(imagePicker, animated: true, completion: nil)
    }
}
