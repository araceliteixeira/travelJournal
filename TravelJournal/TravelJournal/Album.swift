//
//  Album.swift
//  TravelJournal
//
//  Created by Araceli Teixeira on 07/11/17.
//  Copyright © 2017 Araceli Teixeira. All rights reserved.
//

import UIKit

class Album: Equatable {
    static func ==(lhs: Album, rhs: Album) -> Bool {
        return lhs.title == rhs.title && lhs.cover == rhs.cover && lhs.color == rhs.color && lhs.description == rhs.description && lhs.startDate == rhs.startDate && lhs.endDate == rhs.endDate && lhs.records == rhs.records
    }
    
    public private(set) var title: String
    public private(set) var cover: UIImage?
    public private(set) var color: UIColor
    public private(set) var description: String?
    public private(set) var startDate: Date?
    public private(set) var endDate: Date?
    public private(set) var records: [Record]
    
    init(_ title: String, _ cover: UIImage, _ description: String, _ startDate: String, _ endDate: String, _ color: UIColor) {
        self.title = title
        self.cover = cover
        self.description = description
        self.startDate = Util.convertStringToDate(startDate)
        self.endDate = Util.convertStringToDate(endDate)
        self.color = color
        self.records = []
    }
    init(_ title: String, _ cover: UIImage, _ color: UIColor) {
        self.title = title
        self.cover = cover
        self.records = []
        self.color = color
    }
    
    public func setTitle(_ title: String) {
        self.title = title
    }
    public func setCover(_ cover: UIImage) {
        self.cover = cover
    }
    public func setColor(_ color: UIColor) {
        self.color = color
        for r in records {
            r.setColor(color)
        }
    }
    public func setDescrption(_ description: String) {
        self.description = description
    }
    public func setStartDate(_ startDate: Date) {
        self.startDate = startDate
    }
    public func setStartDate(_ startDate: String) {
        self.startDate = Util.convertStringToDate(startDate)
    }
    public func setStartDate(_ startDate: String, _ format: String) {
        self.startDate = Util.convertStringToDate(startDate, format)
    }
    public func setEndDate(_ endDate: Date) {
        self.endDate = endDate
    }
    public func setEndDate(_ endDate: String) {
        self.endDate = Util.convertStringToDate(endDate)
    }
    public func setEndDate(_ endDate: String, _ format: String) {
        self.endDate = Util.convertStringToDate(endDate, format)
    }
    public func setRecords(_ records: [Record]) {
        self.records = records
    }
    public func addRecord(_ record: Record) {
        records.append(record)
    }
    public func getAnnotations() -> [CustomPointAnnotation] {
        var annotations: [CustomPointAnnotation] = []
        for r in records {
            annotations.append(r.getAnnotation())
        }
        return annotations
    }
    public func getStartDate() -> String {
        return Util.convertDateToString(startDate)
    }
    public func getEndDate() -> String {
        return Util.convertDateToString(endDate)
    }
}
