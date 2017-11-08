//
//  AlbumsViewController.swift
//  TravelJournal
//
//  Created by Araceli Teixeira on 07/11/17.
//  Copyright © 2017 Araceli Teixeira. All rights reserved.
//

import UIKit

class AlbumsCollectionViewController: UICollectionViewController {

    var data: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "AlbumCollectionViewCell")
        
        // Do any additional setup after loading the view.
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        //self.view.insertSubview(backgroundImage, at: 0)
        
        loadData()
        self.collectionView?.reloadData()
    }
    
    func loadData() {
        let album1 = Album("Europe Trip", UIImage(named: "london1")!)
        album1.setStartDate("2015-10-24")
        album1.setEndDate("2015-11-01")
        album1.setDescrption("First time overseas! Just my husband and I, a lovely trip!")
        
        var record = Record("London day 1", "2015-10-26")
        record.setText("Today we visited the city. We loved the view, the Big Ben is really cool. We also saw those famous telephone cabins.")
        record.setLatitude(51.506)
        record.setLongitude(-0.115)
        record.addPhoto(UIImage(named: "london1")!)
        record.addPhoto(UIImage(named: "london2")!)
        album1.addRecord(record)
        record = Record("London day 2", "2015-10-27")
        record.setText("Today we went sightseeing in those typical red London buses. Later, we went to the London Eye, where we had a great view of the city.")
        record.setLatitude(51.506)
        record.setLongitude(-0.115)
        record.addPhoto(UIImage(named: "london3")!)
        record.addPhoto(UIImage(named: "london4")!)
        record.addPhoto(UIImage(named: "london5")!)
        album1.addRecord(record)
        record = Record("London day 3", "2015-10-28")
        record.setText("Last day in the city. I took a photo of an Underground sign to keep as a souvenir.")
        record.setLatitude(51.506)
        record.setLongitude(-0.115)
        record.addPhoto(UIImage(named: "london6")!)
        album1.addRecord(record)
        record = Record("Paris", "2015-10-29")
        record.setText("We went sightseeing in the morning. In the afternoon, we went to the Eiffel Tower. It was amazing!")
        record.setLatitude(48.859)
        record.setLongitude(2.295)
        record.addPhoto(UIImage(named: "paris1")!)
        record.addPhoto(UIImage(named: "paris2")!)
        record.addPhoto(UIImage(named: "paris3")!)
        record.addPhoto(UIImage(named: "paris4")!)
        album1.addRecord(record)
        record = Record("Rome", "2015-10-31")
        record.setText("Last stop in our trip. We visited many touristic places. It's really a city full of history.")
        record.setLatitude(41.903)
        record.setLongitude(12.496)
        record.addPhoto(UIImage(named: "rome1")!)
        record.addPhoto(UIImage(named: "rome2")!)
        record.addPhoto(UIImage(named: "rome3")!)
        record.addPhoto(UIImage(named: "rome4")!)
        album1.addRecord(record)
        
        let album2 = Album("Rio de Janeiro", UIImage(named: "rio1")!)
        album2.setStartDate("2016-03-10")
        album2.setEndDate("2016-03-15")
        album2.setDescrption("Our second honeymoon")
        
        record = Record("Beautiful city", "2016-03-15")
        record.setText("This city has some amazing views, but we could also see some things that aren't so great. We had a great time.")
        record.setLatitude(-22.952)
        record.setLongitude(-43.21)
        record.addPhoto(UIImage(named: "rio1")!)
        record.addPhoto(UIImage(named: "rio2")!)
        album2.addRecord(record)
        
        data.append(album1)
        data.append(album2)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigation = segue.destination as? UINavigationController {
            if let destination = navigation.topViewController as? AlbumViewController {
                let selectedItems = self.collectionView?.indexPathsForSelectedItems
                if selectedItems!.count > 0 {
                    destination.album = data[selectedItems![0].row]
                }
            }
        }
     }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as? AlbumCollectionViewCell {
            let album = data[indexPath.row]
            cell.imgCover?.image = album.cover
            cell.lblTitle?.text = album.title
            return cell
        } else {
            fatalError("Unexpected cell type")
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */

}
