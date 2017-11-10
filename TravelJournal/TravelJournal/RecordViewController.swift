//
//  RecordViewController.swift
//  TravelJournal
//
//  Created by Araceli Teixeira on 07/11/17.
//  Copyright © 2017 Araceli Teixeira. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var pickerDate: UIDatePicker!
    @IBOutlet weak var txtText: UITextView!
    @IBOutlet weak var scrollPhotos: UIScrollView!
    
    var record: Record?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        if let existRecord = record {
            navigationItem.title = existRecord.title
            txtTitle.isHidden = true
            pickerDate.date = existRecord.date
            txtText.text = existRecord.text
            let myImages = existRecord.photos
            let imageWidth:CGFloat = 200
            let imageHeight:CGFloat = 120
            var xPosition:CGFloat = 0
            var scrollViewContentSize:CGFloat=0;
            for index in 0...myImages.count-1 {
                let myImage:UIImage = myImages[index]
                let myImageView:UIImageView = UIImageView()
                myImageView.image = myImage
                myImageView.contentMode = UIViewContentMode.scaleAspectFit
                myImageView.frame.size.width = imageWidth
                myImageView.frame.size.height = imageHeight
                //myImageView.center = self.view.center
                myImageView.frame.origin.x = xPosition
                scrollPhotos.addSubview(myImageView)
                let spacer:CGFloat = 20
                xPosition+=imageWidth + spacer
                scrollViewContentSize+=imageWidth + spacer
                scrollPhotos.contentSize = CGSize(width: scrollViewContentSize, height: imageHeight)
            }
            scrollPhotos.showsVerticalScrollIndicator = false
            scrollPhotos.showsHorizontalScrollIndicator = true
            scrollPhotos.alwaysBounceVertical = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
