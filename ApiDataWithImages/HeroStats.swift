//
//  HeroStats.swift
//  ApiDataWithImages
//
//  Created by Dana Palmer on 12/28/20.
//  Copyright © 2020 Dana Palmer. All rights reserved.
//

import Foundation
import UIKit





struct HeroStats: Decodable {
    let localized_name: String
    let primary_attr: String
    let attack_type: String
    let legs: Int
    let img: String
    let icon: String
    
}

