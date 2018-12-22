//
//  DownloadsController.swift
//  iPodcast
//
//  Created by sanket kumar on 14/12/18.
//  Copyright © 2018 sanket kumar. All rights reserved.
//

import UIKit
import CoreData

class DownloadsController : UITableViewController {
    
    let cellId = "cellId"
    var episodes = [Episode]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PodcastDatabase.shared.retrieveDownloadedPodcast { (episodes) in
            self.episodes = episodes
            self.episodes.reverse()
            self.tableView.reloadData()
        }
    }
    
    //MARK:- Setup TableView
    fileprivate func setupTableViews() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    
    // TableView delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        cell.episode = self.episodes[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
        let episode = episodes[indexPath.row]
        if episode.fileUrl != nil {
            mainTabBarController.maximizePlayerDetail(episode: episode, playlistEpisodes: self.episodes)
        }
        else {
            let alertController = UIAlertController(title: "Can't found downloaded file", message: "File not found , Please play online.", preferredStyle: .actionSheet)
            let playAction = UIAlertAction(title: "Yes", style: .default) { (action) in
                mainTabBarController.maximizePlayerDetail(episode: episode, playlistEpisodes: self.episodes)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(playAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true)
        }
    }
    
    
}
