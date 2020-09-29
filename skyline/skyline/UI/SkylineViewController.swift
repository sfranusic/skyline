//
//  SkylineViewController.swift
//  skyline
//
//  Created by Sammy Franusic on 9/28/20.
//  Copyright © 2020 sf. All rights reserved.
//

import UIKit

class SkylineViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var photoRecords: [UnsplashPhotoRecord] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var totalPhotoCount: Int = 0
    var currentPage: Int = 1
    var prefetchInProgress: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up table view delegate and data source.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self

        // Load initial page.
        loadPhotos()
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    func loadPhotos() {
        print("Loading photos from page: \(self.currentPage)")
        self.prefetchInProgress = true

        // Fetch photos from server.
        UnsplashAPI.shared.getPage(page: currentPage, completionHandler: { records in
            if let records = records {
                DispatchQueue.main.async {
                    self.totalPhotoCount = records.total
                    self.photoRecords.append(contentsOf: records.results)
                    self.prefetchInProgress = false

                    // Update UI with response from API call.
                    let startIndex = self.photoRecords.count - records.results.count
                    let endIndex = startIndex + records.results.count - 1
                    let newIndexPaths = (startIndex...endIndex).map { IndexPath(row: $0, section: 0) }

                    if self.currentPage > 1 {
                        let visibleIndexPaths = Set(self.tableView.indexPathsForVisibleRows ?? [])
                        let indexPathsNeedingReload = Set(newIndexPaths).intersection(visibleIndexPaths)
                        self.tableView.reloadRows(at: Array(indexPathsNeedingReload), with: .fade)
//                        self.tableView.reloadRows(at: newIndexPaths, with: .fade)
                    }


                }
            } else {
                DispatchQueue.main.async {
                    self.prefetchInProgress = false
                }
            }
        })
    }

    func fetchNextPage() {
        guard prefetchInProgress == false else {
            return
        }
        self.currentPage += 1
        self.loadPhotos()
    }

}
// MARK: - Table view data source
extension SkylineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.totalPhotoCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "skylineCell", for: indexPath) as! SkylineTableViewCell
        guard !isLoadingIndexPath(indexPath) else {
            return cell
        }

        UnsplashAPI.shared.downloadImage(record: self.photoRecords[indexPath.row],
                                         completionHandler: { image in
                                            if let image = image {
                                                DispatchQueue.main.async {
                                                    cell.skylineImageView.image = image
                                                }
                                            }
        })
        return cell

    }


}
// MARK: - Table view delegate
extension SkylineViewController: UITableViewDelegate {
    private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.row >= self.photoRecords.count
    }
    
}
// MARK: - Table view prefetch protocol
extension SkylineViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        print("Prefetch for index path \(indexPaths)")
        let shouldPrefetch = indexPaths.contains { $0.row >= self.photoRecords.count }
        if shouldPrefetch {
            self.fetchNextPage()
        }
    }


}
