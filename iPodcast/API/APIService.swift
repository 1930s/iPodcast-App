//
//  APIService.swift
//  iPodcast
//
//  Created by sanket kumar on 04/12/18.
//  Copyright © 2018 sanket kumar. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit
import CoreData

class APIService {
    
    let baseiTuneSearchURL = "https://itunes.apple.com/search"
    
    // singleton
    static let shared =  APIService()
    
    func fetchPodcasts(searchText : String,completionHandler : @escaping ([Podcast])->()) {
        
        let parameters = ["term" : searchText,"media" : "podcast"]
        Alamofire.request(baseiTuneSearchURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData(completionHandler: { (dataResponse) in
            if let err = dataResponse.error {
                print("Failed to connect yahoo ",err)
                return
            }
            guard let data = dataResponse.data else { return }
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completionHandler(searchResult.results)
            } catch let decodeErr {
                print("Failed to decode ",decodeErr)
            }
        })
    }
    
    
    func fetchEpisodes(feedUrl : String , completionHandler : @escaping ([Episode])->()) {
        let secureFeedUrl = feedUrl.toSecureHTTPs()
        guard let url = URL(string: secureFeedUrl) else { return }
        
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser?.parseAsync(result: { (result) in
                if let err = result.error {
                    print("Failed to parse XML Feed ",err)
                    return
                }
                guard let feed = result.rssFeed else { return }
                let episodes = feed.toEpisodes()
                completionHandler(episodes)
            })
        }
        
    }
    
    func downloadEpisode(episode : Episode) {
        print("Downloading episode using Alamofire at stream ur; : \(episode.streamUrl)")
        
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        Alamofire.download(episode.streamUrl, to: downloadRequest).downloadProgress { (progress) in
            print(progress.fractionCompleted)
            }.response { (response) in
                print(response.destinationURL?.absoluteString ?? "")
                let fileUrl = response.destinationURL?.absoluteString ?? ""
                PodcastDatabase.shared.saveDownloadedPodcast(episode: episode, fileUrl: fileUrl)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    func downloadEpisode(episode : Episode) {
//        print("Downloading episode using Alamofire at stream ur; : \(episode.streamUrl)")
//
//        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
//        Alamofire.download(episode.streamUrl, to: downloadRequest).downloadProgress { (progress) in
//            print(progress.fractionCompleted)
//            }.response { (response) in
//                print(response.destinationURL?.absoluteString ?? "")
//
//                var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
//
//                guard let index = downloadedEpisodes.lastIndex(where: { (ep) -> Bool in
//                    return episode.title == ep.title && episode.author == ep.author
//                }) else { return }
//
//                downloadedEpisodes[index].fileUrl = response.destinationURL?.absoluteString ?? ""
//
//                do {
//                    let data = try JSONEncoder().encode(downloadedEpisodes)
//                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
//                } catch let err {
//                    print("Failed to encode downloaded episode \(err)")
//                }
//        }
//
//    }

}
