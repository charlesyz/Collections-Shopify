//
//  extensions.swift
//  Collections Shopify
//
//  Created by Charles Zhang on 2019-01-21.
//  Copyright © 2019 Charles Zhang. All rights reserved.
//

import Foundation

extension String {
    // indexOf gets the first index of substring input in the String
    func indexOf(_ input: String,
                 options: String.CompareOptions = .literal) -> String.Index? {
        return self.range(of: input, options: options)?.lowerBound
    }
    // indexOf gets the last index of substring input in the String
    func lastIndexOf(_ input: String) -> String.Index? {
        return indexOf(input, options: .backwards)
    }
}
