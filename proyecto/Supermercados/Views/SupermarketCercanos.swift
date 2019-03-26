//
//  SupermarketCercanos.swift
//  proyecto
//
//  Created by Alberto Alcañiz Díaz-Rullo on 22/03/2019.
//  Copyright © 2019 Marduk. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation
import SafariServices


private let reuseIdentifier = "SupermarketCell"

class SupermarketCercanos: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var locationManager:CLLocationManager?
    
    let minimumSpacing = CGFloat.init(15)
    let cellWidth:CGFloat = 250
    let radius = 1500
    var currentLocation : CLLocationCoordinate2D?
    var places: [SupermarketModel] = []
    
    var isLoading = false
    var response : ServicioResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.title = "Supermercados"
        
        collectionView?.contentInset = UIEdgeInsets.init(top: 0, left: minimumSpacing, bottom: 0, right: minimumSpacing)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        determineMyCurrentLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func canLoadMore() -> Bool {
        if isLoading {
            return false
        }
        
        if let response = self.response {
            if (!response.canLoadMore()) {
                return false
            }
        }
        
        return true
    }
    
    func loadPlaces(_ force:Bool) {
        
        if !force {
            if !canLoadMore() {
                return
            }
        }
        
        isLoading = true
        Servicio.getServicio(by: "supermarket" , coordinates: currentLocation!, radius: radius, token: self.response?.nextPageToken, completion: didReceiveResponse)
    }
    
    func didReceiveResponse(response:ServicioResponse?) -> Void {
        self.response = response
        if response?.status == "OK" {
            
            if let p = response?.places {
                places.append(contentsOf: p)
            }
            
            self.collectionView?.reloadData()
        } else {
            let alert = UIAlertController.init(title: "Error", message: "No se ha podido obtener supermercados cercanos", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Cancelar", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction.init(title: "Reintentar", style: .default, handler: { (action) in
                self.loadPlaces(true)
            }))
            present(alert, animated: true, completion: nil)
        }
        isLoading = false
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return places.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SupermarketCell
        
        let place = places[indexPath.row]
        cell.delegate = self
        cell.update(place: place)
        
        if indexPath.row == places.count - 1 {
            loadPlaces(false)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "maps-vc", sender: indexPath)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellPadding: CGFloat = 20.0
        let columnWidth:CGFloat = cellWidth
        let imageWidth = columnWidth
        let labelWidth = columnWidth - cellPadding * 2
        
        let photoHeight = heightForPhotoAtIndexPath(indexPath: indexPath, withWidth: imageWidth)
        let annotationHeight = heightForAnnotationAtIndexPath(indexPath: indexPath, withWidth: labelWidth)
        let height = photoHeight + annotationHeight
        
        return CGSize.init(width: columnWidth, height: height)
    }
    
    func heightForPhotoAtIndexPath(indexPath: IndexPath,
                                   withWidth width: CGFloat) -> CGFloat {
        
        var size = CGSize.init(width: CGFloat(MAXFLOAT), height: 1)
        let place = places[indexPath.row]
        
        guard let photo = place.photos?.first, place.photos?.first?.photoRef != nil else {
            return 0
        }
        
        size = CGSize.init(width: CGFloat(photo.width!), height: CGFloat(photo.height!))
        
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRect(aspectRatio: size, insideRect: boundingRect)
        
        return rect.size.height
    }
    
    func heightForAnnotationAtIndexPath(indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        
        let place = places[indexPath.row]
        let annotationPadding = CGFloat(5)
        
        let font = UIFont.systemFont(ofSize: 15)
        let commentHeight = place.heightForComment(font, width: width)
        
        let height = annotationPadding + commentHeight + annotationPadding
        
        return height
    }
    

    func didReceiveUserLocation(_ userLocation:CLLocation) {
        currentLocation = userLocation.coordinate
        
        loadPlaces(true)
    }
    
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "maps-vc" && sender is IndexPath {
            let dvc = segue.destination as! SupermarketMap
            dvc.index = (sender as! IndexPath).row
            dvc.places = places
            dvc.userLocation = currentLocation
        }
    }
}

extension SupermarketCercanos: CLLocationManagerDelegate {
    
    func determineMyCurrentLocation() {
        guard currentLocation == nil else {
            return
        }
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        didReceiveUserLocation(userLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
        errorGettingCurrentLocation(error.localizedDescription)
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager?.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        } else if status == .denied || status == .restricted {
            errorGettingCurrentLocation("Location access denied")
        }
    }
    
    func errorGettingCurrentLocation(_ errorMessage:String) {
        let alert = UIAlertController.init(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension SupermarketCercanos: SupermarketCellDelegate {
    func didClickWebsite(place: SupermarketModel) {
        Servicio.getPlaceDetails(place: place) { (place) in
            if let website = place.details?["website"] as? String, let url = URL(string: website) {
                let svc = SFSafariViewController.init(url: url)
                self.navigationController?.pushViewController(svc, animated: true)
            }
        }
    }
}
