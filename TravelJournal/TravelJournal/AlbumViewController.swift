//
//  AlbumViewController.swift
//  TravelJournal
//
//  Created by Araceli Teixeira on 07/11/17.
//  Copyright © 2017 Araceli Teixeira. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UITextFieldDelegate, HSBColorPickerDelegate {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var pickerStartDate: UIDatePicker!
    @IBOutlet weak var pickerEndDate: UIDatePicker!
    @IBOutlet weak var pickerColor: HSBColorPicker!
    @IBOutlet weak var btnColor: UIButton!
    
    var album: Album?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        txtTitle.delegate = self
        pickerColor.delegate = self
        pickerColor.isHidden = true
        btnColor.layer.cornerRadius = btnColor.bounds.size.width/2
        
        if let existAlbum = album {
            navigationItem.title = existAlbum.title
            txtTitle.text = existAlbum.title
            imgCover.image = existAlbum.cover
            txtDescription.text = existAlbum.description
            pickerStartDate.date = existAlbum.startDate ?? Date()
            pickerEndDate.date = existAlbum.endDate ?? Date()
            btnColor.backgroundColor = existAlbum.color
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldDidEndEditing(textField)
        return true
    }
    
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizerState) {
        btnColor.backgroundColor = color
    }
    
    @IBAction func btnColor(_ sender: UIButton) {
        pickerColor.isHidden = !pickerColor.isHidden
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigation = segue.destination as? UINavigationController {
            if let destination = navigation.topViewController as? RecordsTableViewController {
                destination.album = album
            } else if let destination = navigation.topViewController as? ViewMapViewController {
                destination.viewTitle = album!.title
                destination.annotations = album!.getAnnotations()
            }
        }
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
        txtTitle.resignFirstResponder()
        txtDescription.resignFirstResponder()
        
        let title = navigationItem.title
        let cover = imgCover.image!
        let description = txtDescription.text!
        let startDate = pickerStartDate.date
        let endDate = pickerEndDate.date
        let color = btnColor.backgroundColor!
        
        if !(title?.isEmpty)! {
            if album == nil {
                album = Album(title!, cover, description, startDate, endDate, color)
            } else {
                album?.setTitle(title!)
                album?.setCover(cover)
                album?.setDescrption(description)
                album?.setStartDate(startDate)
                album?.setEndDate(endDate)
                album?.setColor(color)
            }
        }
        pickerColor.isHidden = true
    }
    
}
