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
        self.collectionView?.backgroundView = backgroundImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView?.reloadData()
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
    
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
    
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
     }
    
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
