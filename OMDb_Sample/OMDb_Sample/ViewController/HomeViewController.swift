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
    
    private var searchResponse: SearchResponse?
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetUp()
        title = "OMDb"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if searchResponse == nil {
            searchController.searchBar.becomeFirstResponder()
        }
    }
}

// MARK:- tableview datasource methods

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResultItem = searchResponse?.results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMusicTableViewCell", for: indexPath) as! MovieTableViewCell
        cell.movieTitle.text = searchResultItem?.title
        cell.movieReleaseYear.text = searchResultItem?.year
        cell.type.text = searchResultItem?.type
        
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

