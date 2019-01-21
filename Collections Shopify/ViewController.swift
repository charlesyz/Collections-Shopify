//
//  ViewController.swift
//  Collections Shopify
//
//  Created by Charles Zhang on 2019-01-20.
//  Copyright © 2019 Charles Zhang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UITableView!
    
    // Global URLS
    let collectionsUrl: String = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    let collectionUrlBegin = "https://shopicruit.myshopify.com/admin/collects.json?collection_id="
    let collectionUrlEnd = "&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    let productUrlBegin = "https://shopicruit.myshopify.com/admin/products.json?ids="
    let productUrlEnd = "&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"

    var selectedPath : Int = 0;
    var categoryList = [String]()
    
    
    var collections = [CollectModel]()
    
    // Initialize Colelction view table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCellReuseIdentifier", for: indexPath) as! CollectionTableViewCell
        let text = self.categoryList[indexPath.row]
        cell.collectionLabel.text = text
        // Get collection image from the web
        do {
            // get images from the web
            let collectionImgData = try Data(contentsOf: URL(string: collections[indexPath.row].image_url)!)
            cell.collectionImage.image = UIImage(data: collectionImgData)
            cell.collectionImage.contentMode = .scaleAspectFill
        }catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
        self.tableView.delegate = self
        self.tableView.isUserInteractionEnabled = true
        self.tableView.allowsSelection = true

        // Use a completion handler to ensure that the data is fetched before continuing.
        // Get Collections and collect, product data. Note:
        // get rest data for the list of collections then display it.
        getAlamofire(url: collectionsUrl) { response in
            // put collections into a list of CollectModels
            self.collections = self.deserializeCollects(collects: response["custom_collections"])
            self.categoryList = self.getCollectionList()
            self.tableView.reloadData()
        }
    }
    
    // deserializeCollects takes in the JSON array of collects, then returns the data in the
    //    form of a list of CollectModels
    func deserializeCollects(collects: SwiftyJSON.JSON) -> [CollectModel]{
        let collectArray = collects.array!
        var collectObjects = [CollectModel]()
        for collect in collectArray{
            let collectObj = CollectModel(dictionary: collect)
            collectObjects.append(collectObj)
        }
        return collectObjects
    }
    
    // getCollectionList looks at the list of collections and produces a list of strings containing the titles.
    func getCollectionList() -> [String]{
        categoryList = [String]()
        for collection in collections{
            categoryList.append(collection.title)
        }
        return categoryList
    }
    
    // pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ProductViewController
        {
            let vc = segue.destination as? ProductViewController
            vc?.collection = self.collections[self.selectedPath]
        }
    }
    
    // when a table view cell is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // store the selected collection then transfer
        self.selectedPath = indexPath.row
        performSegue(withIdentifier: "productSegue", sender: self)
    }
    

}

