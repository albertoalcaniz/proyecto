//
//  SupermarketPhoto.swift
//  proyecto
//
//  Created by Alberto Alcañiz Díaz-Rullo on 22/03/2019.
//  Copyright © 2019 Marduk. All rights reserved.
//

import UIKit

private let widthKey = "width"
private let heightKey = "height"
private let photoReferenceKey = "photo_reference"

class SupermarketPhoto: NSObject {
    
    var width: Int?
    var height: Int?
    var photoRef: String?
    
    init(photoInfo: [String:Any]) {
        height = photoInfo[heightKey] as? Int
        width = photoInfo[widthKey] as? Int
        photoRef = photoInfo[photoReferenceKey] as? String
    }
    
    func getPhotoURL(maxWidth:Int) -> URL? {
        if let ref = self.photoRef {
            return Servicio.googlePhotoURL(photoReference: ref, maxWidth: maxWidth)
        }
        return nil
    }
}
