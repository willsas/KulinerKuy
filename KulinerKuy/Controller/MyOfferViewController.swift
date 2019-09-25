//
//  MyOfferViewController.swift
//  KulinerKuy
//
//  Created by Willa on 19/09/19.
//  Copyright © 2019 WillaSaskara. All rights reserved.
//

import UIKit
import CloudKit

class MyOfferViewController: UIViewController {
    
    var record = [CKRecord]()
    
    let databaseInstance = OfferDataBaseModel.instance
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupRefresherControl()
        navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = #colorLiteral(red: 0.4039215686, green: 0.6509803922, blue: 0.3490196078, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchingData()
        //set to false when finish fetching
        tableView.isHidden = true
    }
    
    
    func setupRefresherControl(){
        let refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(fetchingData), for: .valueChanged)
        self.tableView.refreshControl = refresher
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc func fetchingData(){
        databaseInstance.fetchData(isPrivate: true) { (arrayOfRecord) in
            self.record = arrayOfRecord
            DispatchQueue.main.async {
                self.tableView.isHidden = false
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
}


extension MyOfferViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return record.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let nib = UINib(nibName: "OfferTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "offerTableViewCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "offerTableViewCell", for: indexPath) as! OfferTableViewCell
        
        cell.tittleOutlet.text = record[indexPath.row].value(forKey: "title") as? String
        cell.priceOutlet.text = record[indexPath.row].value(forKey: "price") as? String
        cell.peopleLeftOutlet.text = String(record[indexPath.row].value(forKey: "people") as! Int) + " people"
        cell.kuyButtonOutlet.isHidden = true
        cell.userNameOutlet.text = record[indexPath.row].value(forKey: "name") as? String

        return cell
    }
}
