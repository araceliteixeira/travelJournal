//
//  RecordsTableViewController.swift
//  TravelJournal
//
//  Created by Araceli Teixeira on 07/11/17.
//  Copyright © 2017 Araceli Teixeira. All rights reserved.
//

import UIKit

class RecordsTableViewController: UITableViewController, UIGestureRecognizerDelegate {
    
    var data: [Record] = []
    var album: Album?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        tableView.backgroundView = backgroundImage
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
        
        if let existAlbum = album {
            data = existAlbum.records
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UIGestureRecognizer) {
        let pressPoint = gestureRecognizer.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: pressPoint)
        
        if indexPath != nil && gestureRecognizer.state == UIGestureRecognizerState.began {
            print("Long press on row, at \(indexPath!.row)")
            let alert = UIAlertController(title: "Alert", message: "Do you want to delete this record?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { action in
                self.data.remove(at: indexPath!.row)
                self.album?.setRecords(self.data)
                self.tableView.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell", for: indexPath) as? RecordTableViewCell {
            let record = data[indexPath.row]
            cell.lblTitle.text = record.title
            cell.lblDate.text = record.getDate()
            return cell
        } else {
            fatalError("Unexpected cell type")
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigation = segue.destination as? UINavigationController {
            if let destination = navigation.topViewController as? RecordViewController {
                if let index = tableView.indexPathForSelectedRow?.row {
                    destination.record = data[index]
                    destination.color = data[index].color
                } else {
                    destination.color = album!.color
                    if data.count > 0 {
                        destination.previousCoordinate = data[data.count-1].getAnnotation().coordinate
                    }
                }
            }
        }
    }

    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToRecordTable(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? RecordViewController {
            if let record = sourceViewController.record {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    data[selectedIndexPath.row] = record
                    tableView.reloadRows(at: [selectedIndexPath], with: .none)
                } else {
                    let newIndexPath = IndexPath(row: data.count, section: 0)
                    data.append(record)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
                album?.setRecords(data)
            }
        }
    }
}
