//
//  RSSFeed.swift
//  iPodcast
//
//  Created by sanket kumar on 08/12/18.
//  Copyright © 2018 sanket kumar. All rights reserved.
//

import Foundation
import FeedKit


extension RSSFeed {
    
    func toEpisodes() -> [Episode] {
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        var episodes = [Episode]() // empty episode array
        items?.forEach({ (feedItem) in
            var episode = Episode(feedItem: feedItem)
            if episode.imageUrl == nil {
                episode.imageUrl = imageUrl
            }
            episodes.append(episode)
            
        })
        return episodes
    }
}
