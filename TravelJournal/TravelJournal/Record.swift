//
//  Entry.swift
//  TravelJournal
//
//  Created by Araceli Teixeira on 07/11/17.
//  Copyright © 2017 Araceli Teixeira. All rights reserved.
//

import UIKit

class Record {
    public private(set) var title: String
    public private(set) var date: Date
    public private(set) var text: String
    public private(set) var photos: [UIImage]
    public private(set) var latitude: Double
    public private(set) var longitude: Double
    
    init(_ title: String, _ date: Date, _ text: String, _ photos: [UIImage], _ latitude: Double, _ longitude: Double) {
        self.title = title
        self.date = date
        self.text = text
        self.photos = photos
        self.latitude = latitude
        self.longitude = longitude
    }
    init(_ title: String, _ date: String) {
        self.title = title
        self.date = Util.convertStringToDate(date)!
        text = ""
        photos = []
        latitude = 0.0
        longitude = 0.0
    }
    
    public func setTitle(_ title: String) {
        self.title = title
    }
    public func setDate(_ date: Date) {
        self.date = date
    }
    public func setDate(_ date: String) {
        self.date = Util.convertStringToDate(date)!
    }
    public func setText(_ text: String) {
        self.text = text
    }
    public func setPhotos(_ photos: [UIImage]) {
        self.photos = photos
    }
    public func setLatitude(_ latitude: Double) {
        self.latitude = latitude
    }
    public func setLongitude(_ longitude: Double) {
        self.longitude = longitude
    }
    public func addPhoto(_ photo: UIImage) {
        photos.append(photo)
    }
    public func getDate() -> String {
        return Util.convertDateToString(date)
    }
}

class Util {
    static let dateFormatter = DateFormatter()
    static let dateFormat = "yyyy-MM-dd"
    
    static func convertStringToDate(_ stringDate: String) -> Date? {
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from:stringDate)
    }
    
    static func convertDateToString(_ date: Date?) -> String {
        if date == nil {
            return ""
        }
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from:date! as Date)
    }
}
