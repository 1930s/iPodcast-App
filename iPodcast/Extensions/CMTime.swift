//
//  CMTime.swift
//  iPodcast
//
//  Created by sanket kumar on 09/12/18.
//  Copyright © 2018 sanket kumar. All rights reserved.
//

import UIKit
import AVKit

extension CMTime {
    
    func toCorrectTimeFormat() -> String {
        
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        
        let totalSecond = Int(CMTimeGetSeconds(self))
        let seconds = totalSecond % 60
        let minutes = totalSecond / 60
        let timeFormatString = String(format: "%02d:%02d", minutes,seconds)
        return timeFormatString
    }
    
}
