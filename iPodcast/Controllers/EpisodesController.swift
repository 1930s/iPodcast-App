//
//  EpisodesController.swift
//  iPodcast
//
//  Created by sanket kumar on 06/12/18.
//  Copyright © 2018 sanket kumar. All rights reserved.
//

import UIKit
import FeedKit
import CoreData


class EpisodesController: UITableViewController {
    
    fileprivate let cellId = "cellId"
    fileprivate var episodes = [Episode]()
    var isFav = false
    
    var podcast : Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            fetchEpisodes()
        }
    }
    
    fileprivate func fetchEpisodes() {
        print("Looking for episodes at feed url \(podcast?.feedUrl ?? "")")
        guard let feedUrl = podcast?.feedUrl else { return }
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episodes = episodes
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkIfPodcastIsFavorite()
    }
    
    
    fileprivate func checkIfPodcastIsFavorite() {
        isFav = PodcastDatabase.shared.checkIfFavorite(podcast: self.podcast)
        print("is Fav : \(isFav)")
        if isFav {
            self.setupNavigationBarButton(title: "Unfavorite")
        }
        else {
            self.setupNavigationBarButton(title: "Favorite")
        }
        
    }
    
    //MARK:- setup views
    
    fileprivate func setupNavigationBarButton(title : String) {
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(handleFavoriteUnfavorite))
        ]
    }
    
    @objc fileprivate func handleFavoriteUnfavorite() {
        print("Saving podcast...")
        // guard let podcast = self.podcast else { return }
        // 34 and 35
        
        guard let podcast = self.podcast else { return }
        if !isFav {
            PodcastDatabase.shared.saveFavoritePodcast(podcast: podcast)
        }
        else {
            PodcastDatabase.shared.deleteFavoritedPodcast(podcast: podcast)
        }
    }
    
    fileprivate func setupTableView() {
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    //MARK:- TableView 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let episode = self.episodes[indexPath.row]
        cell.episode = episode
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
        mainTabBarController.maximizePlayerDetail(episode: episode, playlistEpisodes: self.episodes)

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let downloadAction = UITableViewRowAction(style: .normal, title: "Download") { (_, _) in
            print("downloading episode into user defaults")
            let episode = self.episodes[indexPath.row]
            print("Episode date \(episode.pudDate)")
            // UserDefaults.standard.downloadEpisode(episode: episode)
            // Download podcasd using Alamofire
            APIService.shared.downloadEpisode(episode: episode)
            
        }
        return [downloadAction]
    }
    
}
