//
//  DetailsViewController.swift
//  wcafMovies
//
//  Created by Filho, Wanderley de C. on 07/07/18.
//  Copyright © 2018 Wanderley Filho. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie:Movie = Movie()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.movieImage.image = self.movie.image
        self.titleLabel.text = self.movie.name
        self.releaseLabel.text = "Release date: \(self.movie.releaseDate)"
        self.overviewLabel.text = self.movie.overview
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
