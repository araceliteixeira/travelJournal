//
//  RecordViewController.swift
//  TravelJournal
//
//  Created by Araceli Teixeira on 07/11/17.
//  Copyright © 2017 Araceli Teixeira. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var pickerDate: UIDatePicker!
    @IBOutlet weak var txtText: UITextView!
    @IBOutlet weak var scrollPhotos: UIScrollView!
    
    var record: Record?
    var color: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        txtTitle.delegate = self
        
        if let existRecord = record {
            navigationItem.title = existRecord.title
            txtTitle.text = existRecord.title
            pickerDate.date = existRecord.date
            txtText.text = existRecord.text
            
            loadPhotos(existRecord.photos)
        }
    }
    
    func loadPhotos(_ images: [UIImage]) {
        var xPosition: CGFloat = 0
        var scrollViewContentSize: CGFloat = 0
        if images.count > 0 {
            for index in 0...images.count-1 {
                let viewPhoto: UIImageView = UIImageView()
                viewPhoto.tag = index
                viewPhoto.image = images[index]
                viewPhoto.contentMode = UIViewContentMode.scaleAspectFit
                viewPhoto.frame.size.width = 200
                viewPhoto.frame.size.height = 120
                viewPhoto.frame.origin.x = xPosition
                scrollPhotos.addSubview(viewPhoto)
                let spacer:CGFloat = 20
                xPosition += 200 + spacer
                scrollViewContentSize += 200 + spacer
                
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                gestureRecognizer.delegate = self
                viewPhoto.isUserInteractionEnabled = true
                viewPhoto.addGestureRecognizer(gestureRecognizer)
            }
        }
        scrollPhotos.contentSize = CGSize(width: scrollViewContentSize, height: 120)
        scrollPhotos.showsVerticalScrollIndicator = false
        scrollPhotos.showsHorizontalScrollIndicator = true
        scrollPhotos.alwaysBounceVertical = false
    }
    
    @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
        let alert = UIAlertController(title: "Alert", message: "Do you want to delete this photo?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { action in
            for img in self.scrollPhotos.subviews {
                img.removeFromSuperview()
                if img.tag == gestureRecognizer.view?.tag {
                    var photos = self.record!.photos
                    if let index = photos.index(of: (img as! UIImageView).image!) {
                        photos.remove(at: index)
                        self.record?.setPhotos(photos)
                    }
                }
            }
            self.loadPhotos(self.record!.photos)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldDidEndEditing(textField)
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigation = segue.destination as? UINavigationController {
            if let destination = navigation.topViewController as? ViewMapViewController {
                destination.viewTitle = record!.title
                destination.annotations = [record!.getAnnotation()]
            }
        }
    }
    
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
        txtTitle.resignFirstResponder()
        txtText.resignFirstResponder()
        
        let title = navigationItem.title
        let date = pickerDate.date
        let text = txtText.text!
        
        if !(title?.isEmpty)! {
            if record == nil {
                record = Record(title!, date, text, [], 0.0, 0.0, color!)
            } else {
                record?.setTitle(title!)
                record?.setDate(date)
                record?.setText(text)
                //record?.setPhotos(photos)
            }
        }
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
