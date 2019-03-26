//
//  ListaCompraTable.swift
//  proyecto
//
//  Created by Alberto Alcañiz Díaz-Rullo on 18/03/2019.
//  Copyright © 2019 Marduk. All rights reserved.
//

import UIKit
import CoreData

class ListaCompraTable: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    var fetchResultController: NSFetchedResultsController<Productos>!
    var searchController: UISearchController!
    
    var productos: [Productos] = []
    var searchResults: [Productos] = []
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Lista de la Compra"

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.placeholder = "Buscar productos"
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor(red: 21.0/255.0, green: 103.0/255.0, blue: 164.0/255.0, alpha: 1.0)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableView.automaticDimension
        
        //Cargar los datos de CoreData
        let fetchRequest: NSFetchRequest<Productos> = Productos.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "nombreProducto", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects
                {
                    productos = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
 
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = false

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return searchResults.count
        } else {
            return productos.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListaCompraCell
        
        let productosSuper = productos[indexPath.row]
        

        cell.nombreProducto.text = productosSuper.nombreProducto
        cell.marcaProducto.text = productosSuper.marcaProducto
        
       if (productosSuper.tipoProducto == "Ave") {
        cell.tipoProducto.image = UIImage(imageLiteralResourceName: "ave")
       } else if (productosSuper.tipoProducto == "Carne") {
        cell.tipoProducto.image = UIImage(imageLiteralResourceName: "Carne")
       } else if (productosSuper.tipoProducto == "Pescado") {
        cell.tipoProducto.image = UIImage(imageLiteralResourceName: "pescado")
       } else if (productosSuper.tipoProducto == "Lácteos") {
        cell.tipoProducto.image = UIImage(imageLiteralResourceName: "Lácteos")
       } else if (productosSuper.tipoProducto == "Droguería") {
        cell.tipoProducto.image = UIImage(imageLiteralResourceName: "drogueria")
       } else if (productosSuper.tipoProducto == "Verduras y Frutas") {
        cell.tipoProducto.image = UIImage(imageLiteralResourceName: "Verduras y Fruta")
        }

        
        return cell
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let shareAction = UITableViewRowAction(style: .default, title: "Compartir") {
            (action, indexPath) in
            
            let texto = "¿Me puedes comprar " + self.productos[indexPath.row].nombreProducto! +
                " de la marca " +
                self.productos[indexPath.row].marcaProducto! + "?"
            let activityController = UIActivityViewController(activityItems: [texto], applicationActivities: nil)
            self.present(activityController, animated: true)
        }
        
        
        

        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {

                let context  = appDelegate.persistentContainer.viewContext
       
                let restauranteABorrar = self.fetchResultController.object(at: indexPath)
       
                context.delete(restauranteABorrar)
             
                appDelegate.saveContext()
            }
        }
        
    
      shareAction.backgroundColor = UIColor.green
        deleteAction.backgroundColor = UIColor.red

        return [deleteAction, shareAction]
    }

    
    
    @IBAction func cancelar(_ sender: UIStoryboardSegue) {
    }
    

    

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            productos = fetchedObjects as! [Productos]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    

    func filterContent(for searchText: String) {
        searchResults = productos.filter({ (productos) -> Bool in
            if let name = productos.nombreProducto {
                let isMatch = name.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            return false
        })
    }

    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
}


