//
//  StudentTableViewCell.swift
//  BetterProfessor
//
//  Created by Bhawnish Kumar on 6/23/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet var photoImage: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var photo: Photo? {
        didSet {
            updatePhoto()
        }
    }
    
    var student: Student? {
        didSet {
            updateViews()
        }
    }

    private func updateViews() {
        guard let student = student else { return }
        nameLabel.text = student.name
     
    }
        
        private func updatePhoto() {
            guard let photo = photo else {
                return
            }
            photoImage.image = UIImage(data: photo.imageData)
        }
  
    
    private func addImagePickerView() {
          guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
          let imagePickerView = UIImagePickerController()
          imagePickerView.sourceType = .photoLibrary
          imagePickerView.delegate = self

      }
    

}
extension StudentTableViewCell: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       if let image = info[.originalImage] as? UIImage {
        photoImage.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension StudentTableViewCell: UINavigationControllerDelegate {
    
}

