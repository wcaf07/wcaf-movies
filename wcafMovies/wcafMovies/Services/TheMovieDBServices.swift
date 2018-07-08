//
//  TheMovieDBServices.swift
//  wcafMovies
//
//  Created by Filho, Wanderley de C. on 07/07/18.
//  Copyright © 2018 Wanderley Filho. All rights reserved.
//

import Foundation
import Alamofire

class TheMovieDBServices {
    
    func loadUpcomingMovies(page: Int, completion: @escaping ([Movie]?) -> Void) {
        var movies:[Movie] = []
        var genres:[Genre] = []
        let group = DispatchGroup()
        
        group.enter()
        self.loadAllGenres() { gres in
            genres = gres
            group.leave()
        }
        group.notify(queue: .main) {
            Alamofire.request("https://api.themoviedb.org/3/movie/upcoming?api_key=1f54bd990f1cdfb230adb312546d765d&language=en-US&page=\(page)").responseJSON { response in
                if let json = response.result.value as? [String: Any]{
                    if let results = json["results"] {
                        if let arrayMovies = results as? [Any] {
                            for object in arrayMovies {
                                if let mov = Movie(json: object as! [String : Any]) {
                                    movies.append(mov)
                                }
                            }
                            movies = self.loadGenreNames(genres: genres, movies: movies)
                            completion(movies)
                        }
                    }
                }
            }
        }
    }
    
    func loadImage(posterPath: String, completion: @escaping (UIImage?) -> Void) {
        Alamofire.request("https://image.tmdb.org/t/p/w185\(posterPath)").responseData { response in
            if let data = response.result.value {
                let image = UIImage(data: data)
                completion(image)
            }
        }
    }
    
    func loadImagesIntoMovies(movies:[Movie], completion: @escaping ([Movie]) -> Void) {
        var moviesReturn = movies
        let group = DispatchGroup()
        
        for i in 0..<movies.count {
            group.enter()
            self.loadImage(posterPath: moviesReturn[i].posterPath) { image in
                moviesReturn[i].image = image!
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion(moviesReturn)
        }
    }
    
    func loadAllGenres(completion: @escaping ([Genre]) -> Void) {
        var genres:[Genre] = []
        let group = DispatchGroup()
        
        group.enter()
        self.loadMovieGenres() { genMovies in
            genres.append(contentsOf: genMovies)
            group.leave()
        }
        
        group.enter()
        self.loadTVGenres() { genTv in
            genres.append(contentsOf: genTv)
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion(genres)
        }
    }
    
    func loadTVGenres(completion: @escaping ([Genre]) -> Void) {
        var genres:[Genre] = []
        
        Alamofire.request("https://api.themoviedb.org/3/genre/tv/list?api_key=1f54bd990f1cdfb230adb312546d765d&language=en-US").responseJSON { response in
            
            if let json = response.result.value as? [String: Any]{
                if let genresArray = json["genres"] as? [Any] {
                    for obj in genresArray {
                        if let genre = Genre(json: obj as! [String : Any]) {
                            genres.append(genre)
                        }
                    }
                    completion(genres)
                }
            }
        }
    }
    
    func loadMovieGenres(completion: @escaping ([Genre]) -> Void) {
        var genres:[Genre] = []
        
        Alamofire.request("https://api.themoviedb.org/3/genre/movie/list?api_key=1f54bd990f1cdfb230adb312546d765d&language=en-US").responseJSON { response in
            
            if let json = response.result.value as? [String: Any]{
                if let genresArray = json["genres"] as? [Any] {
                    for obj in genresArray {
                        if let genre = Genre(json: obj as! [String : Any]) {
                            genres.append(genre)
                        }
                    }
                    completion(genres)
                }
            }
        }
    }
    
    func loadGenreNames(genres:[Genre], movies:[Movie]) -> [Movie] {
        var moviesReturn = movies
        
        for i in 0..<movies.count {
            var genreNames:[String] = []
            for genId in movies[i].genreIds {
                if let genOffset = genres.index(where: {$0.id == genId}) {
                    genreNames.append(genres[genOffset].name)
                }
            }
            moviesReturn[i].genreNames = genreNames
        }
        return moviesReturn
    }
}
