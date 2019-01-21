//
//  ProductView.swift
//  Collections Shopify
//
//  Created by Charles Zhang on 2019-01-20.
//  Copyright © 2019 Charles Zhang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class ProductViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var collection = CollectModel()
    let collectionUrlBegin = "https://shopicruit.myshopify.com/admin/collects.json?collection_id="
    let collectionUrlEnd = "&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    let productUrlBegin = "https://shopicruit.myshopify.com/admin/products.json?ids="
    let productUrlEnd = "&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    
    @IBOutlet weak var titleBar: UINavigationBar!
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var tableView: UITableView!
    
    // Set rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collection.products.count
    }
    // Set text and images inside each table row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCellReuseID", for: indexPath) as! ProductTableViewCell
        cell.nameLabel.text = collection.products[indexPath.row].title
        cell.collectionName.text = collection.title
        cell.stockNumber.text = "In Stock: " + String(collection.products[indexPath.row].totalInventory)
        do {
            // get images from the web
            let productImgData = try Data(contentsOf: URL(string: collection.products[indexPath.row].image_url)!)
            let collectionImgData = try Data(contentsOf: URL(string: collection.image_url)!)
            cell.productImage.image = UIImage(data: productImgData)
            cell.collectionImage.image = UIImage(data: collectionImgData)
            cell.productImage.contentMode = .scaleAspectFit
            cell.collectionImage.contentMode = .scaleAspectFill
            
        }catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set title and table settings, then get specific data 
        self.titleBar.topItem?.title = collection.title
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        // get product data from API calls (currently does nothing on completion handler)
        getProductData() {
        }
    }
    
    // getProductData gets collect data then gets all the required data about the products
    func getProductData(completion: @escaping () -> Void){
        // get product list in the colelction
        let collectionURL = self.collectionUrlBegin + self.collection.id + self.collectionUrlEnd
        
        getAlamofire(url: collectionURL) { response in
            // now get the product IDs into collection.product
            let ids = self.collection.populateProductIDs(products: response["collects"])
            
            // fetch the product data -> list of comma separated products
            var productIDList : String = ""
            for id in ids{
                productIDList += id + ","
            }
            getAlamofire(url: self.productUrlBegin + productIDList + self.productUrlEnd) { response in
                self.collection.deserializeProductModels(products: response["products"])
                self.tableView.reloadData()
            }
        }
    }

}
