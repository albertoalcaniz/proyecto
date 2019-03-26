//
//  AddListaCompra.swift
//  proyecto
//
//  Created by Alberto Alcañiz Díaz-Rullo on 18/03/2019.
//  Copyright © 2019 Marduk. All rights reserved.
//

import UIKit
import CoreData

class AddListaCompra: UITableViewController, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
  
     var tipo = ["---Seleccionar---", "Ave", "Carne", "Pescado", "Lácteos", "Drogueria", "Verduras y Frutas"]
    
    var productos: Productos!
  
    @IBOutlet weak var tvNombreP: UITextField!
    
    @IBOutlet weak var tvMarcaP: UITextField!
    
    @IBOutlet weak var tvTipoP: UITextField!

    
    
  
  
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tipo.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tipo[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tvTipoP.text = tipo[row]
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        tvTipoP.inputView = pickerView
      
        self.title = "Añadir Producto"

        
    }



    
    @IBAction func botonGuardar(_ sender: Any) {
        if(tvNombreP.text == ""){
            let alertController = UIAlertController(title: "Error", message: "Por favor, ingresa un Producto", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
      
        } else if (tvTipoP.text == "Ave" || tvTipoP.text == "Carne" || tvTipoP.text == "Drogueria" || tvTipoP.text == "Verduras y Frutas" || tvTipoP.text == "Pescado" || tvTipoP.text == "Lácteos" && tvNombreP.text != "") {
            guardarProducto()
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        } else if(tvTipoP.text != "Ave" || tvTipoP.text != "Carne" || tvTipoP.text != "Drogueria" || tvTipoP.text != "Verduras y Frutas" || tvTipoP.text != "Pescado" || tvTipoP.text != "Lácteos"){
            let alertController = UIAlertController(title: "Error", message: "Por favor, ingresa un Tipo válido", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    func guardarProducto() {
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            productos = Productos(context: appDelegate.persistentContainer.viewContext)
            productos.nombreProducto = tvNombreP.text
        
            productos.marcaProducto = tvMarcaP.text
            productos.tipoProducto = tvTipoP.text
        
          
            //Guardar en el Context
            print("Guardando en Core Data")
            appDelegate.saveContext()
        }
    }

}
