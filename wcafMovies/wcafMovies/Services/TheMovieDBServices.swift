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
        
        Alamofire.request("https://api.themoviedb.org/3/movie/upcoming?api_key=1f54bd990f1cdfb230adb312546d765d&language=en-US&page=\(page)").responseJSON { response in
            if let json = response.result.value as? [String: Any]{
                if let results = json["results"] {
                    if let arrayMovies = results as? [Any] {
                        for object in arrayMovies {
                            if let mov = Movie(json: object as! [String : Any]) {
                                movies.append(mov)
                            }
                        }
                        completion(movies)
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
}
