//
//  UnsplashPhotoRecord.swift
//  skyline
//
//  Created by Sammy Franusic on 9/25/20.
//  Copyright © 2020 sf. All rights reserved.
//

import Foundation
import UIKit

struct UnsplashSearchPage: Codable {
    var total: Int
    var total_pages: Int
    var results: [UnsplashPhotoRecord]
}
struct UnsplashPhotoRecord: Codable, Equatable {
    static func == (lhs: UnsplashPhotoRecord, rhs: UnsplashPhotoRecord) -> Bool {
        lhs.id == rhs.id
    }

    var id: String
    var user: UnsplashUser
    var urls: UnsplashURLS
}
struct UnsplashUser: Codable {
    var username: String
    var name: String
}
struct UnsplashURLS: Codable {
    var raw: String
    var small: String
}
struct UnsplashImageAndAttributes {
    var name: String
    var username: String
    var image: UIImage

    var userLink: URL {
        URL(string: "https://unsplash.com/@\(username)?utm_source=skyline&utm_medium=referral")!
    }
    var unsplashLink: URL {
        URL(string: "https://unsplash.com/?utm_source=skyline&utm_medium=referral")!
    }
}
