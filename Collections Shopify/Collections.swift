//
//  collections.swift
//  Collections Shopify
//
//  Created by Charles Zhang on 2019-01-20.
//  Copyright © 2019 Charles Zhang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// getAlamofire returns the SwiftyJSON data from the "url" API request in a completion handler.
func getAlamofire(url: String, completion: @escaping (JSON) -> Void) {
    Alamofire.request(url)
        .responseJSON { response in
            // Error checking
            guard response.result.error == nil else {
                // got an error in getting the data, need to handle it
                print("error calling GET on /todos/1")
                print(response.result.error!)
                return
            }
            
            //  get JSON
            let jsonResult = JSON(response.result.value!) as JSON
            
            completion(jsonResult)
    }
}

class CollectModel {
    // info about the collection
    public var body_html: String
    public var handle: String
    public var id: String
    public var image_url: String
    public var title: String
    
    // info about products
    private var productIDs : [String]
    public var products : [ProductModel]
    
    // initialize based on JSON (NOT JSON ARRAY, JSON FOR ONE COLLECTION)
    init(dictionary: JSON) {
        self.body_html = dictionary["body_html"].string ?? ""
        self.handle = dictionary["delivery_method"].string ?? ""
        self.id = String(dictionary["id"].int ?? 0)
        self.image_url = dictionary["image"]["src"].string ?? ""
        self.title = dictionary["title"].string ?? ""
        self.productIDs = [String]()
        self.products = [ProductModel]()
    }
    // blank init
    init() {
        self.body_html = ""
        self.handle = ""
        self.id = ""
        self.image_url = ""
        self.title = ""
        self.productIDs = [""]
        self.products = [ProductModel]()
    }
    
    // gets list of product models from the JSON data for the product list (products)
    //  This only gets IDs and Titles.
    public func deserializeProductModels(products: JSON){
        let productArray = products.array!
        self.products = [ProductModel]()
        for product in productArray{
            let productObj = ProductModel(dictionary: product)
            self.products.append(productObj)
        }
    }
    
    // populates the productIDs list from products and returns it
    public func populateProductIDs(products: JSON) -> [String]{
        let productArray = products.array!
        self.productIDs = [String]()
        for product in productArray{
            self.productIDs.append(String(product["product_id"].int ?? 0))
        }
        return self.productIDs
    }
}


class ProductModel {
    public var id : String
    public var title: String
    public var totalInventory: Int
    public var individualInventory : [Int]
    public var image_url : String
    
    // Initialize data from SwiftyJSON - Singular JSON, not list of product JSONs
    init(dictionary: JSON) {
        self.id = String(dictionary["id"].int ?? 0)
        self.title = dictionary["title"].string ?? ""
        self.image_url = dictionary["image"]["src"].string ?? ""
        self.totalInventory = -1
        self.individualInventory = [Int]()
        for variant in dictionary["variants"].array!{
            self.individualInventory.append(variant["inventory_quantity"].int ?? 0)
        }
        self.calcTotalInventory()
    }
    
    // calcTotalInventory sums the list of individual inventories puts it into self.totalInventory()
    public func calcTotalInventory() {
        self.totalInventory = individualInventory.reduce(0, +)
    }
    
}

