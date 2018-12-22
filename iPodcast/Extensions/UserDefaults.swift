//
//  UserDefaults.swift
//  iPodcast
//
//  Created by sanket kumar on 15/12/18.
//  Copyright © 2018 sanket kumar. All rights reserved.
//

import UIKit


extension UserDefaults {
    
    static let downloadedEpisodeKey = "downloadedEpisodeKey"
    
//    func downloadEpisode(episode : Episode) {
//        do {
//            var downloadedEpisode = downloadedEpisodes()
//            downloadedEpisode.append(episode)
//            let data =  try JSONEncoder().encode(downloadedEpisode)
//            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
//        }
//        catch let err {
//            print("Failed to encode episode \(err)")
//        }
//    }
//    
//    
//    
//    func downloadedEpisodes() -> [Episode] {
//        guard let episodeData = UserDefaults.standard.data(forKey: UserDefaults.downloadedEpisodeKey) else { return [] }
//        do {
//            let episodes = try JSONDecoder().decode([Episode].self, from: episodeData)
//            return episodes
//            
//        }catch let err {
//            print("Failed to decode episode \(err)")
//        }
//        return []
//    }
    
    
}
