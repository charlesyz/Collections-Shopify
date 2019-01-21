//
//  extensions.swift
//  Collections Shopify
//
//  Created by Charles Zhang on 2019-01-21.
//  Copyright © 2019 Charles Zhang. All rights reserved.
//

import Foundation

extension String {
    func indexOf(_ input: String,
                 options: String.CompareOptions = .literal) -> String.Index? {
        return self.range(of: input, options: options)?.lowerBound
    }
    
    func lastIndexOf(_ input: String) -> String.Index? {
        return indexOf(input, options: .backwards)
    }
}
