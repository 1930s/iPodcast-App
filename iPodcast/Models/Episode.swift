//
//  Episode.swift
//  iPodcast
//
//  Created by sanket kumar on 06/12/18.
//  Copyright © 2018 sanket kumar. All rights reserved.
//

import Foundation
import FeedKit

struct Episode  {
    
    let title : String
    let pudDate : Date
    let description : String
    let author : String
    let streamUrl : String
    
    var imageUrl : String?
    var fileUrl : String?
    
    init(feedItem : RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pudDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
    }
    
    init(title : String,pubDate : Date,description : String,author : String,streamUrl : String,imageUrl : String,fileUrl : String) {
        self.title = title
        self.pudDate = pubDate
        self.description = description
        self.author = author
        self.streamUrl = streamUrl
        self.imageUrl = imageUrl
        self.fileUrl = fileUrl
    }
    
}

