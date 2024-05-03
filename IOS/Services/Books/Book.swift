//
//  Book.swift
//  MP
//
//  Created by aleksej on 3/23/24.
//

import Foundation

class Book : Codable {
    
    var ID: String
    var title: String
    var authors: [String]
    var rating: Double
    var ratingsNumber: Int
    var description: String
    var price: Double?
    var imagesLinks: [String]
    var images : [Data]?
    
    init(title: String, authors: [String], rating: Double, ratingsNumber: Int, description: String, price: Double?, imagesLinks: [String]) {
        self.ID = "-1"
        self.title = title
        self.authors = authors
        self.rating = rating
        self.ratingsNumber = ratingsNumber
        self.description = description
        self.price = price
        self.imagesLinks = imagesLinks
    }
}
