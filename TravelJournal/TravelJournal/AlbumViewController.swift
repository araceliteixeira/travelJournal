//
//  AlbumViewController.swift
//  TravelJournal
//
//  Created by Araceli Teixeira on 07/11/17.
//  Copyright © 2017 Araceli Teixeira. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, HSBColorPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var pickerStartDate: UIDatePicker!
    @IBOutlet weak var pickerEndDate: UIDatePicker!
    @IBOutlet weak var pickerColor: HSBColorPicker!
    @IBOutlet weak var btnColor: UIButton!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBOutlet weak var btnViewMap: UIBarButtonItem!
    @IBOutlet weak var btnViewRecords: UIBarButtonItem!
    
    var album: Album?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        txtTitle.delegate = self
        txtDescription.delegate = self
        pickerColor.delegate = self
        pickerColor.isHidden = true
        btnColor.layer.cornerRadius = btnColor.bounds.size.width/2
        btnColor.backgroundColor = .black
        pickerStartDate.addTarget(self, action: #selector(handleDatePicker(sender:)), for: UIControlEvents.valueChanged)
        pickerEndDate.addTarget(self, action: #selector(handleDatePicker(sender:)), for: UIControlEvents.valueChanged)
        
        txtDescription.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        txtDescription.layer.borderWidth = 0.5
        txtDescription.layer.cornerRadius = 5
        
        if let existAlbum = album {
            navigationItem.title = existAlbum.title
            txtTitle.text = existAlbum.title
            imgCover.image = existAlbum.cover
            txtDescription.text = existAlbum.description
            pickerStartDate.date = existAlbum.startDate ?? Date()
            pickerEndDate.date = existAlbum.endDate ?? Date()
            btnColor.backgroundColor = existAlbum.color
        } else {
            btnViewMap.isEnabled = false
            btnViewRecords.isEnabled = false
        }
        btnSave.isEnabled = false
    }
    
    private func updateSaveButtonState() {
        if let text = txtTitle.text {
            btnSave.isEnabled = !text.isEmpty
        }
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        if sender.date > Date() {
            sender.date = Date()
        }
        if sender === pickerStartDate {
            if pickerEndDate.date < pickerStartDate.date {
                pickerStartDate.date = pickerEndDate.date
            }
        } else {
            if pickerEndDate.date < pickerStartDate.date {
                pickerEndDate.date = pickerStartDate.date
            }
        }
        updateSaveButtonState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
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
    
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizerState) {
        btnColor.backgroundColor = color
        updateSaveButtonState()
    }
    
    @IBAction func selectCoverImage(_ sender: UITapGestureRecognizer) {
        txtTitle.resignFirstResponder()
        txtDescription.resignFirstResponder()

        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func btnColor(_ sender: UIButton) {
        pickerColor.isHidden = !pickerColor.isHidden
    }
    
    //MARK: Image View Delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgCover.image = selectedImage
            updateSaveButtonState()
            dismiss(animated: true, completion: nil)
        } else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigation = segue.destination as? UINavigationController {
            if let destination = navigation.topViewController as? RecordsTableViewController {
                destination.album = album
            } else if let destination = navigation.topViewController as? ViewMapViewController {
                destination.album = album
            }
        }
        if let button = sender as? UIBarButtonItem {
            if button === btnSave {
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
    }
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
