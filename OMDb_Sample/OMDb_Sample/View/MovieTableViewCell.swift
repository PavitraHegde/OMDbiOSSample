//
//  SearchMusicTableViewCell.swift
//  OMDb_Sample
//
//  Created by Pavitra Hegde on 20/03/20.
//  Copyright © 2020 Pavitra Hegde. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieReleaseYear: UILabel!
    @IBOutlet weak var type: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        moviePoster.image = UIImage(named: "movie_placeholder")
    }
   
    
    func configureCell(with searchResult: SearchResult?) {
        if let resultItem = searchResult {
            movieTitle.text = resultItem.title
            type.text = resultItem.type
            movieReleaseYear.text = resultItem.year
            movieTitle.alpha = 1
            type.alpha = 1
            movieReleaseYear.alpha = 1
        } else {
            movieTitle.alpha = 0
            type.alpha = 0
            movieReleaseYear.alpha = 0
        }
    }
}
