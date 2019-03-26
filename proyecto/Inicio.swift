//
//  Inicio.swift
//  proyecto
//
//  Created by Alberto Alcañiz Díaz-Rullo on 14/03/2019.
//  Copyright © 2019 Marduk. All rights reserved.
//

import UIKit

class Inicio: UIViewController {


    @IBOutlet var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.title = "FullCart"

        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
