//
//  Entry.swift
//  TravelJournal
//
//  Created by Araceli Teixeira on 07/11/17.
//  Copyright © 2017 Araceli Teixeira. All rights reserved.
//

import UIKit
import MapKit

class Record: Equatable {
    static func ==(lhs: Record, rhs: Record) -> Bool {
        return lhs.title == rhs.title && lhs.date == rhs.date && lhs.color == rhs.color && lhs.text == rhs.text && lhs.photos == rhs.photos && lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    public private(set) var title: String
    public private(set) var date: Date
    public private(set) var color: UIColor
    public private(set) var text: String
    public private(set) var photos: [UIImage]
    public private(set) var latitude: Double?
    public private(set) var longitude: Double?
    
    init(_ title: String, _ date: Date, _ text: String, _ photos: [UIImage], _ latitude: Double?, _ longitude: Double?, _ color: UIColor) {
        self.title = title
        self.date = date
        self.text = text
        self.photos = photos
        self.latitude = latitude
        self.longitude = longitude
        self.color = color
    }
    init(_ title: String, _ date: Date, _ text: String, _ photos: [UIImage], _ color: UIColor) {
        self.title = title
        self.date = date
        self.text = text
        self.photos = photos
        self.color = color
    }
    init(_ title: String, _ date: String, _ color: UIColor) {
        self.title = title
        self.date = Util.convertStringToDate(date)!
        text = ""
        photos = []
        self.color = color
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
    public func setColor(_ color: UIColor) {
        self.color = color
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
    public func getAnnotation() -> CustomPointAnnotation {
        let annotation = CustomPointAnnotation(color)
        annotation.title = title
        annotation.subtitle = getDate()
        if latitude != nil && longitude != nil {
            annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        }
        return annotation
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
