//
//  UnsplashAPI.swift
//  skyline
//
//  Created by Sammy Franusic on 9/26/20.
//  Copyright © 2020 sf. All rights reserved.
//

import Foundation
import UIKit

class UnsplashAPI {

    static var shared: UnsplashAPI = {
        return UnsplashAPI()
    }()

    func retrieveRandomPorschePhotoRecord(completionHandler: @escaping (UnsplashPhotoRecord?) -> ()) {

        if let url = URL(string: "https://api.unsplash.com/photos/random") {

            // Construct URL request with authorization header.
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Client-ID \(unsplashAccessKey)", forHTTPHeaderField: "Authorization")

            // Initiate session
            URLSession.shared.dataTask(with: request) { (data, response, error) in

                if let error = error {
                    print(error.localizedDescription)
                }

                if let data = data {
                    let retrievedRecord = try? JSONDecoder().decode(UnsplashPhotoRecord.self, from: data)
                    completionHandler(retrievedRecord)

                }
            }.resume()

        }
    }

    func getPage(query: String = "porsche",
                 page: Int = 1,
                 completionHandler: @escaping (UnsplashSearchPage?) -> ()) {

        if let url = URL(string: "https://api.unsplash.com/search/photos?query=\(query)&page=\(page)") {
            // Construct URL request with authorization header.
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("Client-ID \(unsplashAccessKey)", forHTTPHeaderField: "Authorization")

            // Initiate URL session.
            URLSession.shared.dataTask(with: request) { (data, response, error) in

                if let error = error {
                    print(error.localizedDescription)
                    completionHandler(nil)
                }

                if let data = data {
                    let records = try? JSONDecoder().decode(UnsplashSearchPage.self, from: data)
                    completionHandler(records)

                }
            }.resume()

        }
    }

    func downloadImage(record: UnsplashPhotoRecord, completionHandler: @escaping (UIImage?) -> ()) {

        if let downloadURL = URL(string: record.urls.small) {
            // Construct URL request with authorization header.
            var request = URLRequest(url: downloadURL)
            request.httpMethod = "GET"
            request.addValue("Client-ID \(unsplashAccessKey)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in

                if let data = data {
                    completionHandler(UIImage(data: data))
                    self.trackDownload(id: record.id)
                }

            }.resume()
        }


    }
    // Conform to API guideline by tracking downloads of images.
    func trackDownload(id: String) {
        
        if let trackDownloadURL = URL(string: "https://api.unsplash.com/photos/\(id)/download") {

            // Construct URL request with authorization header.
            var request = URLRequest(url: trackDownloadURL)
            request.httpMethod = "GET"
            request.addValue("Client-ID \(unsplashAccessKey)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { _, response, error in

                if let error = error {
                    print(error.localizedDescription)
                }
            }.resume()
        }
    }
}
