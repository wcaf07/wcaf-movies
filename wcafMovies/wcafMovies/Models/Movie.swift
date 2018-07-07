//
//  File.swift
//  wcafMovies
//
//  Created by Wanderley Filho on 7/6/18.
//  Copyright © 2018 Wanderley Filho. All rights reserved.
//

import Foundation
import UIKit

struct Movie {
    
    var name:String
    var posterPath:String
    var id:Int
    var releaseDate:String
    var genre:[Int]
    var overview:String
    var image:UIImage
    
    init() {
        self.name=""
        self.id = 0
        self.posterPath = ""
        self.releaseDate = ""
        self.genre = []
        self.overview = ""
        self.image = UIImage()
    }
}

extension Movie {
    init?(json: [String: Any]) {
        guard let name = json["title"] as? String,
            let id = json["id"] as? Int,
            let posterPath = json["poster_path"] as? String,
            let releaseDate = json["release_date"] as? String,
            let genre = json["genre_ids"] as? [Int],
            let overview = json["overview"] as? String
            else {
                return nil
        }
        
        self.name = name
        self.id = id
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.genre = genre
        self.overview = overview
        self.image = UIImage()
    }
}
