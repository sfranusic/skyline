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

        if let url = URL(string: "https://api.unsplash.com/photos/random?query=porsche") {

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

    func getFiveRecords(completionHandler: @escaping ([UnsplashPhotoRecord]?) -> ()) {

        if let url = URL(string: "https://api.unsplash.com/photos/random?query=porsche?count=5") {

            var photoRecords: [UnsplashPhotoRecord] = []

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
                    let records = try? JSONDecoder().decode([UnsplashPhotoRecord].self, from: data)

                    if let records = records {
                        photoRecords = records
                    }
//                    for datum in data {
//                        if let record = try? JSONDecoder().decode(UnsplashPhotoRecord.self, from: datum) {
//                            photoRecords.append(record)
//                        }
//                    }

                    completionHandler(photoRecords)
                } else {
                    completionHandler(nil)
                }
            }.resume()

        }
    }

//    func downloadRandomPorschePhoto(completionHandler: @escaping (UIImage?) -> ()) {
//
//        if let url = URL(string: "https://api.unsplash.com/photos/random?query=porsche?orientation=portrait") {
//
//            // Construct URL request with authorization header.
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//            request.addValue("Client-ID \(unsplashAccessKey)", forHTTPHeaderField: "Authorization")
//
//            // Initiate session
//            URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//                if let error = error {
//                    print(error.localizedDescription)
//                }
//
//                if let response = response {
//                    print(response.description)
//                }
//
//                if let data = data {
//                    if let photoRecord = try? JSONDecoder().decode(UnsplashPhotoRecord.self, from: data) {
//                        if let downloadURL = URL(string: "https://api.unsplash.com/photos/\(photoRecord.id)") {
//                            URLSession.shared.dataTask(with: downloadURL) { data, response, error in
//                                if let data = data {
//                                    let downloadedImage = UIImage(data: data)
//                                    completionHandler(downloadedImage)
//                                }
//                            }
//                        }
//                    }
//
//
//                }
//            }.resume()
//
//        }
//    }

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

    func trackDownload(id: String) {
        // Track photo download to abide by API guidelines.
        if let trackDownloadURL = URL(string: "https://api.unsplash.com/photos/\(id)/download") {

            // Construct URL request with authorization header.
            var request = URLRequest(url: trackDownloadURL)
            request.httpMethod = "GET"
            request.addValue("Client-ID \(unsplashAccessKey)", forHTTPHeaderField: "Authorization")

            print("Tracking download of image with ID: \(id)")
            URLSession.shared.dataTask(with: request) { _, response, error in

                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Photo download tracked successfully. Photo ID: \(id)")
                }
            }.resume()
        }
    }
}
