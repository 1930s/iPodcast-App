//
//  FavoritePodacstCell.swift
//  iPodcast
//
//  Created by sanket kumar on 13/12/18.
//  Copyright © 2018 sanket kumar. All rights reserved.
//

import UIKit

class FavoritePodcastCell: UICollectionViewCell {
  
    let imageView : UIImageView = {
        let iv = UIImageView(image: UIImage(named: "appicon"))
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.heightAnchor.constraint(equalTo: iv.widthAnchor).isActive = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.text = "Podcast name"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    let artistNameLabel : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.text = "Sanket Kumar"
        lb.textColor = .lightGray
        return lb
    }()
    
    var podcast : Podcast? {
        didSet {
            nameLabel.text = podcast?.trackName ?? ""
            artistNameLabel.text = podcast?.artistName ?? ""
            
            guard let imageUrl = podcast?.artworkUrl600 else { return }
            
            guard let url = URL(string: imageUrl.toSecureHTTPs()) else { return }
            // imageView.sd_setImage(with: url, completed: nil)
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "appicon"))
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- SetupViews
    fileprivate func setupViews() {
        let stackView = UIStackView(arrangedSubviews: [
            imageView,
            nameLabel,
            artistNameLabel
            ]
        )
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
    
    
    
}
