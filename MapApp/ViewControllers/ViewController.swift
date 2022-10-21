//
//  ViewController.swift
//  MapApp
//
//  Created by Евгения Аникина on 20.06.2022.
//
//  Тестовое задание
//
//  нужно подключить google карты в приложении, отрисовать на главном экране карту. по дефолту отобразить точкой себя в режиме реального времени с изменением. добавить кнопку импорта точек с сервера, один GET запрос, в котором есть 10 точек и 5 линий, вытянуть с сервера и отобразить на карте, точки одного цвета, линии другого, ну и запрос на сервер сделать асинхронно и с помощью callback


import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class ViewController: UIViewController {
    
    var mapView: GMSMapView!

    let network = NetworkDecode()
    var arrayPoints: [MapsApp] = []
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    var exactLocationScale: Float = 15.0
    var approximatelyLocationScale: Float = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        let myLocationIsNow = CLLocation(latitude: 57.14955, longitude: 65.58411)
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? exactLocationScale : approximatelyLocationScale
        let camera = GMSCameraPosition.camera(withLatitude: myLocationIsNow.coordinate.latitude,
                                              longitude: myLocationIsNow.coordinate.longitude,
                                              zoom: zoomLevel)
        
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        view.addSubview(mapView)
        mapView.isHidden = true

    }
    
    //показывает представление, анимация
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    // действие запроса
    @objc func requestAction() {
        network.getDecode { result in
            switch result {
            case .success(let success):
                guard let success = success else { return }
                self.arrayPoints = [success]
            case .failure(let error):
                print("decode data error: \(error.localizedDescription)")
            }
        }
    }
    //создает пин
    func createPin(coordinate: CLLocationCoordinate2D) {
        let pin = GMSMarker(position: coordinate)
        pin.icon = GMSMarker.markerImage(with: .systemPink)
        pin.map = mapView
    }
    
}

// MARK: - MapViewDelegate
extension ViewController: GMSMapViewDelegate {
    @objc func asd() {
        let mapsVC = MapsViewController()
        mapsVC.modalPresentationStyle = .fullScreen
        present(mapsVC, animated: true, completion: nil)
    }
}

// MARK: - LocationManager
//для обработки событий местоположения
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? exactLocationScale : approximatelyLocationScale
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    //Обрабатывает авторизацию для диспетчера местоположений и статус авторизации
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let accuracy = manager.accuracyAuthorization
        switch accuracy {
        case .fullAccuracy:
            print("Location accuracy is precise.")
        case .reducedAccuracy:
            print("Location accuracy is not precise.")
        @unknown default:
            fatalError()
        }
        
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            fatalError()
        }
    }
    
    //для обработки ошибок диспетчера местоположения
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}
