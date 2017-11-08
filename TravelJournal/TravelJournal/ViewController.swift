//
//  ViewController.swift
//  TravelJournal
//
//  Created by Araceli Teixeira on 06/11/17.
//  Copyright © 2017 Araceli Teixeira. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapObj: MKMapView!
    
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var btnWrite: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        btnView!.titleEdgeInsets = UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 0)
        btnWrite.titleEdgeInsets = UIEdgeInsets(top: 0,left: 10,bottom: 0,right: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier!)
     }
}

