//
//  Menu.swift
//  proyecto
//
//  Created by Alberto Alcañiz Díaz-Rullo on 14/03/2019.
//  Copyright © 2019 Marduk. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData

class Menu: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }



    @IBAction func cerrarSesion(_ sender: AnyObject) {
        let firebaseAuth = Auth.auth()
          let cerrar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login")
        
        
        if Auth.auth().currentUser != nil {
            
            
            do {
               
            try firebaseAuth.signOut()
                present(cerrar, animated: true, completion: nil)
                
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            
            } 
        
 
    }
    

}
