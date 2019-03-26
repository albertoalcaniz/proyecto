//
//  SupermarketModel.swift
//  proyecto
//
//  Created by Alberto Alcañiz Díaz-Rullo on 22/03/2019.
//  Copyright © 2019 Marduk. All rights reserved.
//

import UIKit
import CoreLocation

private let geometryKey = "geometry"
private let locationKey = "location"
private let latitudeKey = "lat"
private let longitudeKey = "lng"
private let nameKey = "name"
private let openingHoursKey = "opening_hours"
private let openNowKey = "open_now"
private let vicinityKey = "formatted_address"
private let typesKey = "types"
private let photosKey = "photos"

class SupermarketModel: NSObject {
    
    var placeId: String
    var location: CLLocationCoordinate2D?
    var name: String?
    var photos: [SupermarketPhoto]?
    var vicinity: String?
    var isOpen: Bool?
    var types: [String]?
    
    var details: [String : Any]?
    
    init(placeInfo:[String: Any]) {
        // id
        placeId = placeInfo["place_id"] as! String
        
        // coordinates
        if let g = placeInfo[geometryKey] as? [String:Any] {
            if let l = g[locationKey] as? [String:Double] {
                if let lat = l[latitudeKey], let lng = l[longitudeKey] {
                    location = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)
                }
            }
        }
        

        name = placeInfo[nameKey] as? String
  
        if let oh = placeInfo[openingHoursKey] as? [String:Any] {
            if let on = oh[openNowKey] as? Bool {
                isOpen = on
            }
        }
        

        vicinity = placeInfo[vicinityKey] as? String

        photos = [SupermarketPhoto]()
        if let ps = placeInfo[photosKey] as? [[String:Any]] {
            for p in ps {
                photos?.append(SupermarketPhoto.init(photoInfo: p))
            }
        }
    }
    
    func getDescription() -> String {
        
        var s : [String] = []
        
        if let name = name {
            s.append("Nombre: \(name)")
        }
        
        if let vicinity = vicinity {
            s.append("Dirección: \(vicinity)")
        }
        
        if let isOpen = isOpen {
            s.append(isOpen ? "Abierto" : "Cerrado")
            
        }
        
        return s.joined(separator: "\n")
    }
    
    func heightForComment(_ font: UIFont, width: CGFloat) -> CGFloat {
        let desc = getDescription()
        let rect = NSString(string: desc).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(rect.height)
    }
    
}
