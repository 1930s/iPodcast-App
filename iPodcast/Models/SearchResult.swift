//
//  SearchResults.swift
//  iPodcast
//
//  Created by sanket kumar on 04/12/18.
//  Copyright © 2018 sanket kumar. All rights reserved.
//

import Foundation

struct SearchResult : Decodable {
    let resultCount : Int
    let results : [Podcast]
}
