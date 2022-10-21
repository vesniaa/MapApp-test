//
//  MapsViewController.swift
//  MapApp
//
//  Created by Евгения Аникина on 21.06.2022.
//

import UIKit
import GoogleMaps

class MapsViewController: UIViewController {
    
    var mapView: GMSMapView!
    let network = NetworkDecode()
    var arrayMapsAppModel: [MapsApp] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createMap()
    }
    // создаем карту с шириной и долготой
    func createMap() {
        let defaultLocation = CLLocation(latitude: 49.07070102, longitude: 9.76366923)
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: 25)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        
        mapView.settings.myLocationButton = false
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(mapView)
        
        DispatchQueue.main.async {
            self.getRequest()
        }
        
        drawPoint()
        
    }
    // получение запроса со свойствами с сети
    func getRequest() {
        network.getDecode { result in
            switch result {
            case .success(let success):
                guard let success = success else { return }
                self.arrayMapsAppModel = [success]
                
                self.arrayMapsAppModel.forEach { $0.points.forEach { result in
                    let long = result.geometry.coordinates[0]
                    let lat = result.geometry.coordinates[1]
                    let marker = GMSMarker()
                    
                    let r = result.properties.color[0]
                    let g = result.properties.color[1]
                    let b = result.properties.color[2]
                    
                    let alpha = result.properties.color[3]
                    
                    marker.icon = GMSMarker.markerImage(with: UIColor(red: r, green: g, blue: b, alpha: alpha))
                    marker.position = CLLocationCoordinate2DMake(lat, long)
                    marker.map = self.mapView
                    }
                }
        
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    //отрисовка координат карты, линии
    func drawPoint() {
        let path = GMSMutablePath()
        
        path.add(CLLocationCoordinate2D(latitude: 49.07065733, longitude: 9.76360944))
        path.add(CLLocationCoordinate2D(latitude: 49.07063189, longitude: 9.76390329))
        
      /*path.add(CLLocationCoordinate2D(latitude: 49.07064725, longitude: 9.76380536))
        path.add(CLLocationCoordinate2D(latitude: 49.07059658, longitude: 9.76391426))
        path.add(CLLocationCoordinate2D(latitude: 49.07071667, longitude: 9.76370879))
        path.add(CLLocationCoordinate2D(latitude: 49.07065308, longitude: 9.76367193))
        path.add(CLLocationCoordinate2D(latitude: 49.07058402, longitude: 9.76381858))
        path.add(CLLocationCoordinate2D(latitude: 49.07070122, longitude: 9.76380622))
        path.add(CLLocationCoordinate2D(latitude: 49.07063616, longitude: 9.76385633))
        path.add(CLLocationCoordinate2D(latitude: 49.07070102, longitude: 9.76366923))*/
        
    
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeColor = .black
        polyLine.strokeWidth = 10.0
        polyLine.map = mapView
    }
}
