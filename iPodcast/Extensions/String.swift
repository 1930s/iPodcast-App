//
//  String.swift
//  iPodcast
//
//  Created by sanket kumar on 08/12/18.
//  Copyright © 2018 sanket kumar. All rights reserved.
//

import Foundation

extension String {
    
    func toSecureHTTPs() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
