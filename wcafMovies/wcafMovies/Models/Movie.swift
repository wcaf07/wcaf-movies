//
//  File.swift
//  wcafMovies
//
//  Created by Wanderley Filho on 7/6/18.
//  Copyright © 2018 Wanderley Filho. All rights reserved.
//

import Foundation

struct Movie {
    
    var name:String
    var image:String
    var id:Int
    var releaseDate:String
    var genre:[Int]
    var overview:String
    
}

extension Movie {
    init?(json: [String: Any]) {
        guard let name = json["title"] as? String,
            let id = json["id"] as? Int,
            let image = json["poster_path"] as? String,
            let releaseDate = json["release_date"] as? String,
            let genre = json["genre_ids"] as? [Int],
            let overview = json["overview"] as? String
            else {
                return nil
        }
        
        self.name = name
        self.id = id
        self.image = image
        self.releaseDate = releaseDate
        self.genre = genre
        self.overview = overview
    }
}
