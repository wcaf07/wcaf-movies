//
//  Genre.swift
//  wcafMovies
//
//  Created by Filho, Wanderley de C. on 07/07/18.
//  Copyright © 2018 Wanderley Filho. All rights reserved.
//

import Foundation

struct Genre {
    var id: Int
    var name: String
}

extension Genre {
    init?(json: [String:Any]) {
        guard let name = json["name"] as? String,
            let id = json["id"] as? Int
            else {
                return nil
        }
        self.id = id
        self.name = name
    }
}
