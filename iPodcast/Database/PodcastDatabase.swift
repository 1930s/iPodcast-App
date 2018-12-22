//
//  PodcastDatabase.swift
//  iPodcast
//
//  Created by sanket kumar on 16/12/18.
//  Copyright © 2018 sanket kumar. All rights reserved.
//

import UIKit
import CoreData

class PodcastDatabase {
    
    // singleton
    static let shared = PodcastDatabase()
    
    
    func saveFavoritePodcast(podcast : Podcast) {
        // delegate
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        // ManagedContext
        let managedContext = delegate.persistentContainer.viewContext
        
        // Entity
        guard let entity = NSEntityDescription.entity(forEntityName: "FavoritePodcast", in: managedContext) else { return }
        
        let savedPodcast = NSManagedObject(entity: entity, insertInto: managedContext)
        savedPodcast.setValue(podcast.trackName ?? "", forKey: "trackName")
        savedPodcast.setValue(podcast.artistName ?? "", forKey: "artistName")
        savedPodcast.setValue(podcast.artworkUrl600 ?? "", forKey: "artworkUrl600")
        savedPodcast.setValue(podcast.trackCount ?? 0, forKey: "trackCount")
        savedPodcast.setValue(podcast.feedUrl ?? "", forKey: "feedUrl")
        do {
            print("Podcast Saved...")
            try managedContext.save()
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    
    func saveDownloadedPodcast(episode : Episode ,fileUrl : String) {
        // 1 - delegate
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        // Managed Context
        let mangedContext = delegate.persistentContainer.viewContext
        
        // let entity
        guard let entity = NSEntityDescription.entity(forEntityName: "DownloadedEpisode", in: mangedContext) else { return }
        
        let downloadPodcast = NSManagedObject(entity: entity, insertInto: mangedContext)
        downloadPodcast.setValue(episode.title, forKey: "title")
        downloadPodcast.setValue(episode.streamUrl, forKey: "streamUrl")
        downloadPodcast.setValue(episode.pudDate, forKey: "pubDate")
        downloadPodcast.setValue(episode.imageUrl, forKey: "imageUrl")
        downloadPodcast.setValue(fileUrl, forKey: "fileUrl")
        downloadPodcast.setValue(episode.description, forKey: "episodeDescription")
        downloadPodcast.setValue(episode.author, forKey: "author")
        
        do {
            try mangedContext.save()
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    
    func retrieveFavoritedPodcast(completionHandler : @escaping ([Podcast])->()) {
        var podcasts : [Podcast] = [Podcast]()
        
        // 1 - delegate
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        // Managed Context
        let managedContext = delegate.persistentContainer.viewContext
        // Fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritePodcast")
        
        do {
            let favPodcasts = try managedContext.fetch(fetchRequest)
            for podcast in favPodcasts as! [NSManagedObject]{
                let trackName = podcast.value(forKey: "trackName") as? String
                let artistName = podcast.value(forKey: "artistName") as? String
                let artworkUrl600 = podcast.value(forKey: "artworkUrl600") as? String
                let trackCount = podcast.value(forKey: "trackCount") as? Int
                let feedUrl = podcast.value(forKey: "feedUrl") as? String
                
                let pod = Podcast(trackName: trackName, artistName: artistName, artworkUrl600: artworkUrl600, trackCount: trackCount, feedUrl: feedUrl)
                podcasts.append(pod)
            }
            completionHandler(podcasts)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func retrieveDownloadedPodcast(completionHandler : @escaping ([Episode])->()) {
        var episodes = [Episode]()
        // 1 - delegate
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        // Managed Context
        let mangedContext = delegate.persistentContainer.viewContext
        
        // fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DownloadedEpisode")
        
        do {
            let downloadedEpisodes = try mangedContext.fetch(fetchRequest)
            for episode in downloadedEpisodes as! [NSManagedObject] {
                let title = episode.value(forKey: "title") as! String
                let pudDate = episode.value(forKey: "pubDate") as! Date
                let description = episode.value(forKey: "episodeDescription") as! String
                let author = episode.value(forKey: "author") as! String
                let streamUrl = episode.value(forKey: "streamUrl") as! String
                
                let imageUrl = episode.value(forKey: "imageUrl") as! String
                let fileUrl = episode.value(forKey: "fileUrl") as! String
                let episode = Episode(title: title, pubDate: pudDate, description: description, author: author, streamUrl: streamUrl, imageUrl: imageUrl, fileUrl: fileUrl)
                episodes.append(episode)
            }
            completionHandler(episodes)
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }

    
    func checkIfFavorite(podcast : Podcast?) -> Bool {
        var isTrue = false
        retrieveFavoritedPodcast { (podcasts) in
            isTrue = podcasts.contains(where: { (pod) -> Bool in
                return podcast?.artistName == pod.artistName && podcast?.trackName == pod.trackName
            })
        }
        return isTrue
    }
    
    
    func deleteFavoritedPodcast(podcast : Podcast) {
        
        // 1 - delegate
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        // Managed Context
        let managedContext = delegate.persistentContainer.viewContext
        // Fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritePodcast")
        
        do {
            let favPodcasts = try managedContext.fetch(fetchRequest)
            for pod in favPodcasts as! [NSManagedObject]{
                if pod.value(forKey: "trackName") as? String == podcast.trackName && pod.value(forKey: "artistName") as? String == podcast.artistName {
                    managedContext.delete(pod)
                    break
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
