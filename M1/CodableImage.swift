//
//  CodableImage.swift
//  M1
//
//  Created by Lim Liu on 11/29/21.
//

import Foundation
import UIKit

public struct CodableImage: Codable {

    public let img: Data
    
    public init(img: UIImage) {
        self.img = img.pngData()!
    }
}
