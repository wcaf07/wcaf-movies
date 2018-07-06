//
//  File.swift
//  wcafMovies
//
//  Created by Wanderley Filho on 7/6/18.
//  Copyright © 2018 Wanderley Filho. All rights reserved.
//

import Foundation

class Movie {
    
    var name:String
    var image:String
    var id:Int
    var releaseDate:String
    var genre:String
    var overview:String
    
    init(id:Int, name:String, image:String, releaseDate:String, genre:String, overview:String) {
        self.name = name
        self.id = id
        self.image = image
        self.releaseDate = releaseDate
        self.genre = genre
        self.overview = overview
    }
    
}
