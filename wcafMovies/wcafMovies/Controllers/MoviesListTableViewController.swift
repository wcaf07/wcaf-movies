//
//  MoviesListTableViewController.swift
//  wcafMovies
//
//  Created by Wanderley Filho on 7/6/18.
//  Copyright © 2018 Wanderley Filho. All rights reserved.
//

import UIKit

class MoviesListTableViewController: UITableViewController {
    
    var page: Int = 1
    var movies:[Movie] = []
    let services = TheMovieDBServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return self.movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieOverview", for: indexPath) as! MovieTableViewCell

        cell.movieLabel.text = self.movies[indexPath.row].name
        cell.genreLabel.text = "Genre will be loaded"
        cell.releaseDate.text = "Release date: \(self.movies[indexPath.row].releaseDate)"
        cell.movieImage.image = self.movies[indexPath.row].image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.movies.count-1) {
            self.page += 1
            print("loading one more page \(self.page)")
            loadMovies()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieDetails" {
            let detailsViewController = segue.destination as? DetailsViewController
            if let details = detailsViewController {
                details.movie = self.movies[(self.tableView.indexPathForSelectedRow?.row)!]
            }
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
