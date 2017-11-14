//
//  RecordViewController.swift
//  TravelJournal
//
//  Created by Araceli Teixeira on 07/11/17.
//  Copyright © 2017 Araceli Teixeira. All rights reserved.
//

import UIKit
import MapKit

class RecordViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtText: UITextView!
    @IBOutlet weak var scrollPhotos: UIScrollView!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    var record: Record?
    var color: UIColor?
    var previousCoordinate: CLLocationCoordinate2D?
    var pickerDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        txtTitle.delegate = self
        txtText.delegate = self
        txtDate.delegate = self
        
        txtText.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        txtText.layer.borderWidth = 0.5
        txtText.layer.cornerRadius = 5
        
        if let existRecord = record {
            navigationItem.title = existRecord.title
            txtTitle.text = existRecord.title
            txtDate.text = Util.convertDateToString(existRecord.date)
            txtText.text = existRecord.text
            color = existRecord.color
            loadPhotos(existRecord.photos)
        } else {
            txtDate.text = Util.convertDateToString(Date())
        }
        btnSave.isEnabled = false
    }
    
    private func updateSaveButtonState() {
        if let text = txtTitle.text {
            btnSave.isEnabled = !text.isEmpty
        }
    }
    
    private func loadPhotos(_ images: [UIImage]) {
        var scrollViewContentSize: CGFloat = 0
        if images.count > 0 {
            for index in 0...images.count-1 {
                let imageView: UIImageView = UIImageView(image: images[index])
                imageView.tag = index
                imageView.contentMode = UIViewContentMode.scaleAspectFit
                imageView.frame.size.width = 200
                imageView.frame.size.height = 120
                imageView.frame.origin.x = scrollViewContentSize
                scrollPhotos.addSubview(imageView)
                let spacer:CGFloat = 20
                scrollViewContentSize += 200 + spacer
                
                let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.fullscreenImage(_:)))
                imageView.isUserInteractionEnabled = true
                longPressGestureRecognizer.delegate = self
                tapGestureRecognizer.delegate = self
                imageView.addGestureRecognizer(longPressGestureRecognizer)
                imageView.addGestureRecognizer(tapGestureRecognizer)
            }
        }
        scrollPhotos.contentSize = CGSize(width: scrollViewContentSize, height: 120)
        scrollPhotos.showsVerticalScrollIndicator = false
        scrollPhotos.showsHorizontalScrollIndicator = true
        scrollPhotos.alwaysBounceVertical = false
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        if sender.date > Date() {
            sender.date = Date()
        }
    }
    
    func pickUpDate(_ textField : UITextField){
        pickerDate = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        pickerDate.backgroundColor = UIColor.white
        pickerDate.datePickerMode = UIDatePickerMode.date
        pickerDate.date = Util.convertStringToDate(textField.text!)!
        pickerDate.addTarget(self, action: #selector(handleDatePicker(sender:)), for: UIControlEvents.valueChanged)
        textField.inputView = self.pickerDate
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    @objc func doneClick() {
        txtDate.text = Util.convertDateToString(pickerDate.date)
        txtDate.resignFirstResponder()
        updateSaveButtonState()
    }
    @objc func cancelClick() {
        txtDate.resignFirstResponder()
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.began {
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
    }
    
    @objc func fullscreenImage(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame.size = UIScreen.main.bounds.size
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        
        print("fullsize aspect ratio:")
        let w = newImageView.image!.size.width
        let h = newImageView.image!.size.height
        print("\(w)/\(h) = \(w/h)")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.isToolbarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === txtDate {
            self.pickUpDate(textField)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === txtTitle {
            navigationItem.title = textField.text
        }
        updateSaveButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldDidEndEditing(textField)
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateSaveButtonState()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func addPhotos(_ sender: UIBarButtonItem) {
        txtTitle.resignFirstResponder()
        txtText.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    //MARK: Image View Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if record == nil {
                let title = txtTitle.text!
                let date = Util.convertStringToDate(txtDate.text!)!
                let text = txtText.text!
                record = Record(title, date, text, [], color!)
            }
            record!.addPhoto(selectedImage)
            print("original aspect ratio:")
            print("\(selectedImage.size.width)/\(selectedImage.size.height) = \(selectedImage.size.width/selectedImage.size.height)")
            loadPhotos(record!.photos)
            dismiss(animated: true, completion: nil)
        } else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigation = segue.destination as? UINavigationController {
            if let destination = navigation.topViewController as? ViewMapViewController {
               if record == nil {
                    let title = txtTitle.text!
                    let date = Util.convertStringToDate(txtDate.text!)!
                    let text = txtText.text!
                    record = Record(title, date, text, [], color!)
                }
                destination.previousCoordinate = previousCoordinate
                destination.record = record
            }
        }
        if let button = sender as? UIBarButtonItem {
            if button === btnSave {
                txtTitle.resignFirstResponder()
                txtText.resignFirstResponder()
                
                let title = txtTitle.text!
                let date = Util.convertStringToDate(txtDate.text!)!
                let text = txtText.text!
                
                if !title.isEmpty {
                    if record == nil {
                        record = Record(title, date, text, [], color!)
                    } else {
                        record!.setTitle(title)
                        record!.setDate(date)
                        record!.setText(text)
                    }
                }
            }
        }
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToRecordView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ViewMapViewController {
            let annotations = sourceViewController.annotations
            if annotations.count > 0 {
                record?.setLatitude(annotations[0].coordinate.latitude)
                record?.setLongitude(annotations[0].coordinate.longitude)
            }
        }
    }
}
