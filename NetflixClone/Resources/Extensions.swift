//
//  Extensions.swift
//  NetflixClone
//
//  Created by Furkan on 19.06.2023.
//

import Foundation


extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
}
