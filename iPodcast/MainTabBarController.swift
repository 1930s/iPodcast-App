//
//  MainTabBarController.swift
//  iPodcast
//
//  Created by sanket kumar on 03/12/18.
//  Copyright © 2018 sanket kumar. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let playerDetailsView = PlayerDetailsView.initFromNib()
    var maximizedTopAnchorConstraint : NSLayoutConstraint!
    var minimizedTopAnchorConstraint : NSLayoutConstraint!
    var bottomAnchorConstraints : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .purple
        
        setupViewControllers()
        setupPlayerDetailsView()
        
    }
    
    func minimizePlayerDetail() {
        self.maximizedTopAnchorConstraint.isActive = false
        self.bottomAnchorConstraints.constant = view.frame.height
        self.minimizedTopAnchorConstraint.isActive = true
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.tabBar.transform = .identity
            self.playerDetailsView.maximizedStackView.alpha = 0
            self.playerDetailsView.miniPlayerView.alpha = 1
        })
    }
    
    func maximizePlayerDetail(episode : Episode?,playlistEpisodes : [Episode] = []) {
        self.minimizedTopAnchorConstraint.isActive = false
        self.maximizedTopAnchorConstraint.isActive = true
        self.maximizedTopAnchorConstraint.constant = 0
        
        
        self.bottomAnchorConstraints.constant = 0
        
        if episode != nil {
            playerDetailsView.episode = episode
        }
        
        playerDetailsView.playlistEpisodes = playlistEpisodes
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            self.playerDetailsView.maximizedStackView.alpha = 1
            self.playerDetailsView.miniPlayerView.alpha = 0
        })
    }
    
    fileprivate func setupPlayerDetailsView() {
        
        view.insertSubview(playerDetailsView, belowSubview: tabBar)
        
        playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedTopAnchorConstraint.isActive = true
        
        
        minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        playerDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        bottomAnchorConstraints = playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant : view.frame.height)
        
        bottomAnchorConstraints.isActive = true
        playerDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    //MARK:- Setup Functions
    fileprivate func setupViewControllers() {
        
        let favController = FavoritesController(collectionViewLayout : UICollectionViewFlowLayout())
        
        viewControllers = [
            generateNavigationController(for: favController, title: "Favorites", image: UIImage(named: "favorites")),
            generateNavigationController(for: PodcastsSearchController(), title: "Search", image: UIImage(named: "search")),
            generateNavigationController(for: DownloadsController(), title: "Downloads", image: UIImage(named: "downloads"))
        ]
    }
    
    // MARK:- Helper Functions
    fileprivate func generateNavigationController(for rootViewController : UIViewController , title : String , image : UIImage?) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navController.navigationBar.prefersLargeTitles = true
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        return navController
    }
    
    
    
    
}
