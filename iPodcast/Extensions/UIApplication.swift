//
//  UIApplication.swift
//  iPodcast
//
//  Created by sanket kumar on 10/12/18.
//  Copyright © 2018 sanket kumar. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static func mainTabBarController() -> MainTabBarController? {
        return self.shared.keyWindow?.rootViewController as? MainTabBarController
    }
    
}
