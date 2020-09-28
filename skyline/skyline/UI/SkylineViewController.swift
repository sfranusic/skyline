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
    var photoRecords: [UIImage] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up table view delegate and data source.
        tableView.delegate = self
        tableView.dataSource = self

        UnsplashAPI.shared.retrieveRandomPorschePhotoRecord { record in
            if let record = record {
                UnsplashAPI.shared.downloadImage(record: record) { image in
                    if let image = image {
                        self.photoRecords.append(image)
                    }
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SkylineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.photoRecords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skylineCell", for: indexPath) as! SkylineTableViewCell
        cell.skylineImageView.image = photoRecords[indexPath.row]
        return cell
    }


}
extension SkylineViewController: UITableViewDelegate {
    
}
