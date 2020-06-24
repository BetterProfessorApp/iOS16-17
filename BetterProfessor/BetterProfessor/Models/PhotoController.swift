//
//  PhotoController.swift
//  BetterProfessor
//
//  Created by Bhawnish Kumar on 6/23/20.
//  Copyright © 2020 Bhawnish Kumar. All rights reserved.
//

import Foundation

class PhotoController {
    
    func createPhoto(with imageData: Data) {
        let photo = Photo(imageData: imageData)
        
        photos.append(photo)
    }
    
    func update(photo: Photo, with imageData: Data) {
        guard let index = photos.firstIndex(of: photo) else { return }
        
        var scratch = photo
        
        scratch.imageData = imageData
        
        photos.remove(at: index)
        photos.insert(scratch, at: index)
    }

    var photos: [Photo] = []
}
