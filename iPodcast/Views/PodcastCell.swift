//
//  PodcastCell.swift
//  iPodcast
//
//  Created by sanket kumar on 04/12/18.
//  Copyright © 2018 sanket kumar. All rights reserved.
//

import UIKit
import SDWebImage


class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastImageView: UIImageView! {
        didSet {
            podcastImageView.layer.cornerRadius = 6
            podcastImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var episodeCountLabel: UILabel!
    
    var podcast : Podcast! {
        didSet {
            trackNameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            episodeCountLabel.text = "\(podcast.trackCount ?? 0) Episodes"
            
            guard let _ = podcast.artworkUrl600?.replacingOccurrences(of: "http://", with: "https://") else { return }
            
            let imageUrl = podcast.artworkUrl600 ?? ""
            guard let url = URL(string: imageUrl.toSecureHTTPs()) else { return }
            podcastImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
}
