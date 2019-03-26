//
//  SupermarketMap.swift
//  proyecto
//
//  Created by Alberto Alcañiz Díaz-Rullo on 22/03/2019.
//  Copyright © 2019 Marduk. All rights reserved.
//

import UIKit
import GoogleMaps

class SupermarketMap: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var bottomInfoView: UIView!
    
    var userLocation:CLLocationCoordinate2D?
    var places:[SupermarketModel] = []
    var index:Int = -1
    
    var mapView:GMSMapView!
    var marker:GMSMarker?
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard index >= 0, places.count > 0 else {
            return
        }
        
        let place = places[index]
        let lat = place.location?.latitude ?? 1.310844
        let lng = place.location?.longitude ?? 103.866048
        
    
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 12.5)
        mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        self.containerView.addSubview(mapView)
        
       
        addSwipeGesture()
        
        didSelect(place: place)
        if userLocation != nil {
            addMarkerAtCurrentLocation(userLocation!)
        }
    }
    
 
    func addSwipeGesture() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
            gesture.direction = direction
            self.bottomInfoView.addGestureRecognizer(gesture)
        }
    }
    
    func addMarkerAtCurrentLocation(_ userLocation: CLLocationCoordinate2D)  {
        let marker = GMSMarker()
        marker.position = userLocation
        marker.title = "Mi Ubicación"
        marker.map = mapView
    }
    
    func didSelect(place:SupermarketModel) {
        
        guard let coordinates = place.location else {
            return
        }
        
    
        marker?.map = nil

        marker = GMSMarker()
        marker?.position = coordinates
        marker?.title = place.name
        marker?.map = mapView
        mapView.selectedMarker = marker
        moveToMarker(marker!)
        
     
        let desc = place.getDescription()
        descriptionLabel.text = desc.characters.count > 0 ? desc : "-"
        distanceLabel.text = "-"
        
 
        if userLocation != nil {
            let dist = distance(from: userLocation!, to: coordinates)
            distanceLabel.text = String.init(format: "Distance %.2f meters", dist)
        }
        
        title = place.name
    }
    
    func moveToMarker(_ marker: GMSMarker) {
        let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude,
                                              longitude: marker.position.longitude,
                                              zoom: 12.5)
        self.mapView.animate(to: camera)
    }
    

    func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer) {
        
        guard index >= 0, places.count > 0 else {
            return
        }
        
        if sender.direction == .left {
            if index < places.count - 2 {
                index += 1
                didSelect(place: places[index])
            }
        } else if sender.direction == .right {
            if index > 1 {
                index -= 1
                didSelect(place: places[index])
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
