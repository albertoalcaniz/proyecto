//
//  ListaCompraCell.swift
//  proyecto
//
//  Created by Alberto Alcañiz Díaz-Rullo on 15/03/2019.
//  Copyright © 2019 Marduk. All rights reserved.
//

import UIKit

class ListaCompraCell: UITableViewCell {


    @IBOutlet weak var tipoProducto: UIImageView!
    
    @IBOutlet weak var marcaProducto: UILabel!
    
    @IBOutlet weak var nombreProducto: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
