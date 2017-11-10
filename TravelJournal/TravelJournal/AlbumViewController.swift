//
//  AlbumViewController.swift
//  TravelJournal
//
//  Created by Araceli Teixeira on 07/11/17.
//  Copyright © 2017 Araceli Teixeira. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, HSBColorPickerDelegate {

    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var pickerStartDate: UIDatePicker!
    @IBOutlet weak var pickerEndDate: UIDatePicker!
    @IBOutlet weak var pickerColor: HSBColorPicker!
    @IBOutlet weak var viewColor: UIView!
    
    var album: Album?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        viewColor.layer.cornerRadius = viewColor.bounds.size.width/2
        
        if let existAlbum = album {
            navigationItem.title = existAlbum.title
            imgCover.image = existAlbum.cover
            txtDescription.text = existAlbum.description
            pickerStartDate.date = existAlbum.startDate ?? Date()
            pickerEndDate.date = existAlbum.endDate ?? Date()
        }
    }
    
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizerState) {
        viewColor.tintColor = color
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigation = segue.destination as? UINavigationController {
            if let destination = navigation.topViewController as? RecordsTableViewController {
                destination.album = album
            }
        }
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
