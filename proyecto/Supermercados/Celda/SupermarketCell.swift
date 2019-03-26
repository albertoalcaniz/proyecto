//
//  SupermarketCell.swift
//  proyecto
//
//  Created by Alberto Alcañiz Díaz-Rullo on 22/03/2019.
//  Copyright © 2019 Marduk. All rights reserved.
//

import UIKit
import AlamofireImage
import SafariServices

class SupermarketCell: UICollectionViewCell {

    let maxWidht = 230
    
    @IBOutlet weak var webButton: UIButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    weak var delegate: SupermarketCellDelegate?
    var place: SupermarketModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        container.layer.borderWidth = 1
        container.layer.cornerRadius = 5
        container.clipsToBounds = true
        webButton.layer.borderWidth = 1
        webButton.layer.cornerRadius = 30
        webButton.clipsToBounds = true
        
        
   
    }
    
    func update(place: SupermarketModel) {
        self.place = place
        label.text = place.getDescription()
        imageView.image = nil
        
        if let url = place.photos?.first?.getPhotoURL(maxWidth: maxWidht) {
            imageView.af_setImage(withURL: url)
        }
    }
    @IBAction func callbackWebsiteButton(_ sender: Any) {
        if let place = place, let delegate = delegate {
            delegate.didClickWebsite(place: place)
        }
        
    }
}

protocol SupermarketCellDelegate: class {
    func didClickWebsite(place: SupermarketModel)
}
