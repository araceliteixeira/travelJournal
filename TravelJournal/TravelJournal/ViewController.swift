//
//  ViewController.swift
//  TravelJournal
//
//  Created by Araceli Teixeira on 06/11/17.
//  Copyright © 2017 Araceli Teixeira. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapObj: MKMapView!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var btnWrite: UIButton!
    
    var data: [Album] = []
    var annotations: [CustomPointAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        
        mapObj.delegate = self
        
        btnView!.titleEdgeInsets = UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 0)
        btnWrite.titleEdgeInsets = UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 0)
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        drawAnnotations()
    }

    func loadData() {
        let album1 = Album("Europe Trip", UIImage(named: "london1")!, UIColor.blue)
        album1.setStartDate("2015-10-24")
        album1.setEndDate("2015-11-01")
        album1.setDescrption("First time overseas! Just my husband and I, a lovely trip!")
        
        var record = Record("London day 1", "2015-10-26", UIColor.blue)
        record.setText("Today we visited the city. We loved the view, the Big Ben is really cool. We also saw those famous telephone cabins.")
        record.setLatitude(51.506)
        record.setLongitude(-0.115)
        record.addPhoto(UIImage(named: "london1")!)
        record.addPhoto(UIImage(named: "london2")!)
        album1.addRecord(record)
        record = Record("London day 2", "2015-10-27", UIColor.blue)
        record.setText("Today we went sightseeing in those typical red London buses. Later, we went to the London Eye, where we had a great view of the city.")
        record.setLatitude(51.506)
        record.setLongitude(-0.115)
        record.addPhoto(UIImage(named: "london3")!)
        record.addPhoto(UIImage(named: "london4")!)
        record.addPhoto(UIImage(named: "london5")!)
        album1.addRecord(record)
        record = Record("London day 3", "2015-10-28", UIColor.blue)
        record.setText("Last day in the city. I took a photo of an Underground sign to keep as a souvenir.")
        record.setLatitude(51.506)
        record.setLongitude(-0.115)
        record.addPhoto(UIImage(named: "london6")!)
        album1.addRecord(record)
        record = Record("Paris", "2015-10-29", UIColor.blue)
        record.setText("We went sightseeing in the morning. In the afternoon, we went to the Eiffel Tower. It was amazing!")
        record.setLatitude(48.859)
        record.setLongitude(2.295)
        record.addPhoto(UIImage(named: "paris1")!)
        record.addPhoto(UIImage(named: "paris2")!)
        record.addPhoto(UIImage(named: "paris3")!)
        record.addPhoto(UIImage(named: "paris4")!)
        album1.addRecord(record)
        record = Record("Rome", "2015-10-31", UIColor.blue)
        record.setText("Last stop in our trip. We visited many touristic places. It's really a city full of history.")
        record.setLatitude(41.903)
        record.setLongitude(12.496)
        record.addPhoto(UIImage(named: "rome1")!)
        record.addPhoto(UIImage(named: "rome2")!)
        record.addPhoto(UIImage(named: "rome3")!)
        record.addPhoto(UIImage(named: "rome4")!)
        album1.addRecord(record)
        
        let album2 = Album("Rio de Janeiro", UIImage(named: "rio1")!, UIColor.green)
        album2.setStartDate("2016-03-10")
        album2.setEndDate("2016-03-15")
        album2.setDescrption("Our second honeymoon")
        
        record = Record("Beautiful view", "2016-03-15", UIColor.green)
        record.setText("This city has some amazing views, but we could also see some things that aren't so great. We had a great time.")
        record.setLatitude(-22.952)
        record.setLongitude(-43.21)
        record.addPhoto(UIImage(named: "rio1")!)
        record.addPhoto(UIImage(named: "rio2")!)
        album2.addRecord(record)
        
        data.append(album1)
        data.append(album2)
    }
    
    func drawAnnotations() {
        mapObj.removeAnnotations(annotations)
        annotations = []
        for album in data {
            annotations.append(contentsOf: album.getAnnotations())
        }
        mapObj.showAnnotations(annotations, animated: true)
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

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigation = segue.destination as? UINavigationController {
            if let destination = navigation.topViewController as? AlbumsCollectionViewController {
                destination.data = data
            }
        }
     }
}

