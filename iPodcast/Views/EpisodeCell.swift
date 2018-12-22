//
//  EpisodeCell.swift
//  iPodcast
//
//  Created by sanket kumar on 07/12/18.
//  Copyright © 2018 sanket kumar. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {

    
    @IBOutlet weak var episodePubDateLabel: UILabel!
    @IBOutlet weak var episodeImageVlew: UIImageView! {
        didSet {
            episodeImageVlew.layer.cornerRadius = 6
            episodeImageVlew.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var episodeDescriptionLabel: UILabel!
    
    var episode : Episode? {
        didSet {
            episodeTitleLabel.text = episode?.title ?? ""
            episodeDescriptionLabel.text = episode?.description ?? ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            episodePubDateLabel.text = dateFormatter.string(from: episode?.pudDate ?? Date())
            
            let imageUrl = episode?.imageUrl ?? ""
            
            guard let url = URL(string: imageUrl.toSecureHTTPs()) else { return }
            episodeImageVlew.sd_setImage(with: url, completed: nil)
            
        }
    }
    
}
