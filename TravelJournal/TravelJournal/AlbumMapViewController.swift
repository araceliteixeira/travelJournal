//
//  AlbumMapViewController.swift
//  TravelJournal
//
//  Created by MacStudent on 2017-11-10.
//  Copyright © 2017 Araceli Teixeira. All rights reserved.
//

import UIKit
import MapKit

class AlbumMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapObj: MKMapView!
    
    var album: Album?
    var annotations: [CustomPointAnnotation] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let existAlbum = album {
            navigationItem.title = existAlbum.title
            
            for a in existAlbum.getAnnotations() {
                annotations.append(a)
                mapObj.addAnnotation(a)
            }
            mapObj.showAnnotations(annotations, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "marker"
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
