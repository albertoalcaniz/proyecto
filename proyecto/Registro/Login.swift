//
//  ViewController.swift
//  proyecto
//
//  Created by Alberto Alcañiz Díaz-Rullo on 21/01/2019.
//  Copyright © 2019 Marduk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class Login: UIViewController {
    
    //Outlets
    @IBOutlet weak var correoText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!

  
    @IBAction func entrarBoton(_ sender: Any) {
        if self.correoText.text == "" || self.passwordText.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Por favor, ingresa un correo y una contraseña", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }  else {
            Auth.auth().signIn(withEmail: self.correoText.text!, password: self.passwordText.text!){(user, error) in
                
                if error == nil {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Inicio")
                    self.present(vc!, animated: true, completion: nil)
                } else {
                    
                    
                    let alertController = UIAlertController(title: "Error", message: "Este correo no esta registrado", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    

    @IBAction func passOlvidado(_ sender: Any) {
        if self.correoText.text == ""{
            let alertController = UIAlertController(title: "Error", message: "Por favor, ingresa un correo", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController,animated: true, completion: nil)
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.correoText.text!) { error in
                if error == nil {
                    let alertController = UIAlertController(title: "Hecho", message: "Se ha enviado un correo a tu cuenta para que recuperes la contraseña", preferredStyle: .alert)
                    let defaulAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaulAction)
                    self.present(alertController, animated: true, completion: nil )
                } else {
                    let alertController = UIAlertController(title: "Error", message: "Este correo no esta registrado", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                    
                }
            }
 
    }

}

