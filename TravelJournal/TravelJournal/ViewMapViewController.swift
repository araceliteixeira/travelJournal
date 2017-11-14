//
//  AlbumMapViewController.swift
//  TravelJournal
//
//  Created by MacStudent on 2017-11-10.
//  Copyright © 2017 Araceli Teixeira. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapObj: MKMapView!
    
    var album: Album?
    var record: Record?
    var previousCoordinate: CLLocationCoordinate2D?
    var annotations: [CustomPointAnnotation] = []
    
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        
        mapObj.delegate = self
        
        if let existAlbum = album {
            navigationItem.title = existAlbum.title
            navigationItem.rightBarButtonItems = []
            annotations = existAlbum.getAnnotations()
            mapObj.showAnnotations(annotations, animated: true)
        } else if let existRecord = record {
            navigationItem.title = existRecord.title
            navigationItem.rightBarButtonItem?.isEnabled = false
            if let coordinate = previousCoordinate {
                let annotation = existRecord.getAnnotation()
                annotation.coordinate = coordinate
                annotations = [annotation]
                mapObj.showAnnotations(annotations, animated: true)
            } else if existRecord.latitude == nil || existRecord.longitude == nil {
                locationManager = CLLocationManager()
                locationManager!.delegate = self
                locationManager!.desiredAccuracy = kCLLocationAccuracyBest
                locationManager!.requestWhenInUseAuthorization()
                locationManager!.startUpdatingLocation()
                mapObj.showsUserLocation = true
            } else {
                annotations = [existRecord.getAnnotation()]
                mapObj.showAnnotations(annotations, animated: true)
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.2,0.2)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        
        mapObj.setRegion(region, animated: true)
        
    }

    @objc func saveLocation() {
        if let existRecord = record {
            existRecord.setLatitude(annotations[0].coordinate.latitude)
            existRecord.setLongitude(annotations[0].coordinate.longitude)
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "marker"
        if #available(iOS 11.0, *) {
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKMarkerAnnotationView
            
            if view == nil {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                view?.annotation = annotation
            }
            if let customPointAnnotation = annotation as? CustomPointAnnotation {
                view?.markerTintColor = customPointAnnotation.pointColor
                view?.titleVisibility = .visible
            }
            return view
        } else {
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView
            
            if view == nil {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                view?.annotation = annotation
            }
            if let customPointAnnotation = annotation as? CustomPointAnnotation {
                view?.pinTintColor = customPointAnnotation.pointColor
            }
            return view
        }
    }
    
    @IBAction func pinPoint(_ sender: UILongPressGestureRecognizer) {
        if let existRecord = record {
            if sender.state == .began {
                let touchPoint = sender.location(in: mapObj)
                let annotation = CustomPointAnnotation(existRecord.color)
                annotation.coordinate = mapObj.convert(touchPoint, toCoordinateFrom: mapObj)
                annotation.title = existRecord.title
                annotation.subtitle = existRecord.getDate()
                
                mapObj.removeAnnotations(annotations)
                annotations = [annotation]
                mapObj.showAnnotations(annotations, animated: true)
                navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
