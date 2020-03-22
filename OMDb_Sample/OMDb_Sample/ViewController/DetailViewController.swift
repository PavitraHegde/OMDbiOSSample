//
//  DetailViewController.swift
//  OMDb_Sample
//
//  Created by Pavitra Hegde on 22/03/20.
//  Copyright © 2020 Pavitra Hegde. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var metaScore: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var imdbRating: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePlot: UILabel!
    @IBOutlet weak var actors: UILabel!
    
    var recieveData: SearchResult!
    var result: MovieDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MovieSearchService.sharedService.getDetails(with: recieveData.imdbID) { (response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.updateData(response!)
            }
        }
    }
    
    func updateData(_ result: MovieDetails) {
        movieTitle.text =  result.title
        moviePlot.text = "Description: " + result.plot
        actors.text = "Actors: " + result.actors
        metaScore.text = result.metascore
        year.text = result.year
        imdbRating.text = result.imdbRating
        // posterImage.image = result?.poster
        
    }
    
    
}
