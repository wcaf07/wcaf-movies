//
//  MoviesListTableViewController.swift
//  wcafMovies
//
//  Created by Wanderley Filho on 7/6/18.
//  Copyright © 2018 Wanderley Filho. All rights reserved.
//

import UIKit

class MoviesListTableViewController: UITableViewController, UISearchBarDelegate {
    
    var page: Int = 1
    var pageSearch: Int = 1
    var isSearch:Bool = false
    
    var movies:[Movie] = []
    var searchMovies:[Movie] = []
    
    let services = TheMovieDBServices()
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.sizeToFit()
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.tableView.backgroundView = activityIndicatorView
        activityIndicatorView.startAnimating()
        
        self.loadMovies()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (self.isSearch) {
            return self.searchMovies.count
        } else {
            return self.movies.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieOverview", for: indexPath) as! MovieTableViewCell
        
        var currentMovie:Movie = Movie()
        if (self.isSearch) {
            currentMovie = self.searchMovies[indexPath.row]
        } else {
            currentMovie = self.movies[indexPath.row]
        }
        cell.movieLabel.text = currentMovie.name
        cell.genreLabel.text = currentMovie.genreNames.joined(separator: ",")
        cell.releaseDate.text = "Release date: \(currentMovie.releaseDate)"
        cell.movieImage.image = currentMovie.image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (self.isSearch) {
            if indexPath.row == (self.searchMovies.count-1) {
                self.pageSearch += 1
                self.loadMoviesFromSearch()
            }
        } else {
            if indexPath.row == (self.movies.count-1) {
                self.page += 1
                self.loadMovies()
            }
        }
    }
    
    func loadMovies() {
        self.services.loadUpcomingMovies(page: self.page) { movies in
            self.services.loadImagesIntoMovies(movies: movies!) { movies in
                self.movies.append(contentsOf: movies)
                self.tableView.reloadData()
            }
        }
    }
    
    func loadMoviesFromSearch() {
        self.services.searchMovies(searchQuery: self.searchBar.text!, page: self.pageSearch) { searchMovies in
            self.services.loadImagesIntoMovies(movies: searchMovies!) { movies in
                self.searchMovies.append(contentsOf: movies)
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetails" {
            let detailsViewController = segue.destination as? DetailsViewController
            if let details = detailsViewController {
                if (self.isSearch) {
                    details.movie = self.searchMovies[(self.tableView.indexPathForSelectedRow?.row)!]
                } else {
                    details.movie = self.movies[(self.tableView.indexPathForSelectedRow?.row)!]
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count > 0) {
            self.tableView.setContentOffset(.zero, animated: true)
        } else {
            self.searchMovies = []
            self.pageSearch = 1
            self.isSearch = false
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.isSearch = true
        self.loadMoviesFromSearch()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}
