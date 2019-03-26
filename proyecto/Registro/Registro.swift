//
//  Registro.swift
//  proyecto
//
//  Created by Alberto Alcañiz Díaz-Rullo on 14/03/2019.
//  Copyright © 2019 Marduk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class Registro: UIViewController {
    
    @IBOutlet weak var correoTexto: UITextField!
    @IBOutlet weak var passwordTexto: UITextField!
  
    @IBAction func registrarBoton(_ sender: Any) {
        if correoTexto.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Por favor, ingresa un correo y un contraseña", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: correoTexto.text!, password: passwordTexto.text!) { (user, error) in
                
                if error == nil {
                    print("You have successfully signed up")
               
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Este correo ya está registrado", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
  

}
