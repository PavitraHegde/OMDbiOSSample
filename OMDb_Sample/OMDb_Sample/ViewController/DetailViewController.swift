//
//  DetailViewController.swift
//  OMDb_Sample
//
//  Created by Pavitra Hegde on 22/03/20.
//  Copyright © 2020 Pavitra Hegde. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var metaScore: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var imdbRating: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePlot: UILabel!
    @IBOutlet weak var actors: UILabel!
    
    var recieveData: SearchResult!
    var result: MovieDetails?
    var imageDownloader = ImageDownloadManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        dataView.layer.borderWidth = 0.5
        dataView.layer.borderColor = UIColor.gray.cgColor
        dataView.layer.masksToBounds = true
        
        MovieSearchService.sharedService.getDetails(with: recieveData.imdbID) { (response, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.updateData(response!)
            }
        }
    }
    
    func updateData(_ result: MovieDetails) {
        movieTitle.text =  result.title
        moviePlot.text = "Description: " + result.plot!
        actors.text = "Actors: " + result.actors!
        metaScore.text = result.metascore
        year.text = result.year
        imdbRating.text = result.imdbRating
        imageDownloader.downloadImage(url: result.poster) { (image, error) in
            if let image = image {
                self.posterImage.image = image
            } else {
                self.posterImage.image = UIImage(named: "movie_placeholder")
            }
        }
        
    }
    
    
    
}
