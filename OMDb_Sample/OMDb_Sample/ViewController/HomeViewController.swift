//
//  SearchMovieViewController.swift
//  OMDb_Sample
//
//  Created by Pavitra Hegde on 20/03/20.
//  Copyright © 2020 Pavitra Hegde. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var movieDetails = [SearchMovieList]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
    }
}

// MARK:- tableview datasource methods

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMusicTableViewCell", for: indexPath) as! MovieTableViewCell
        //cell.movieTitle.text = searchMovie[indexPath.row]
        return cell
    }
}

// MARK:- tableview delegate methods

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: UISearchResultsUpdating  {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension HomeViewController {
    
    func initialSetUp() {
        let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SearchMusicTableViewCell")
        
    }
}

