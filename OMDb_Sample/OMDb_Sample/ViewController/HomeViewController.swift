//
//  HomeViewController.swift
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
    var spinner = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetUp()
        title = "OMDb"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Enter 3 characters to search"
        self.navigationItem.searchController = searchController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if searchResponse == nil {
            searchController.searchBar.becomeFirstResponder()
        }
    }
}

//MARK:- instance methods

extension HomeViewController {
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailViewController" {
            let vc = segue.destination as! DetailViewController
            vc.recieveData =  sender as? SearchResult
        }
    }
    
    func configureActivityIndicator() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        view.bringSubviewToFront(spinner)
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func downloadImage(_ url: URL, indexPath: IndexPath) {
        let imageDownloadManager = ImageDownloadManager()
        imageDownloadManager.downloadImage(url: url) {
            (image, error) in
            DispatchQueue.main.async {
                guard let cell = self.tableView.cellForRow(at: indexPath) as? MovieTableViewCell else {
                    return
                }
                if let image = image {
                    cell.moviePoster.image = image
                } else {
                    cell.moviePoster.image = UIImage(named: "movie_placeholder")
                }
            }
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
        if let url = searchResultItem?.poster {
           self.downloadImage(url, indexPath: indexPath)
        } else {
            cell.moviePoster.image = UIImage(named: "movie_placeholder")
        }
       
        return cell
    }
}

// MARK:- tableview delegate methods

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailViewController", sender: searchResponse!.results[indexPath.row])
    }
}

extension HomeViewController: UISearchBarDelegate  {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let count = searchBar.text?.trimmingCharacters(in: .whitespaces).count, count >= 3 else {
            return
        }
        searchResponse = nil
        getSearchResult(text: searchBar.text!)
        searchController.isActive = false
    }
    
}

extension HomeViewController {
    
    func initialSetUp() {
        configureActivityIndicator()
        let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SearchMusicTableViewCell")
    }
}

extension HomeViewController {
    
    func getSearchResult(text: String) {
        self.spinner.startAnimating()
        MovieSearchService.sharedService.sendSearchRequest(with: text, page: 1) { (searchResponse, error) in
            self.spinner.stopAnimating()
            if let error = error {
                self.showAlert("Movie not found!")
                print(error.localizedDescription)
            } else {
                self.searchResponse = searchResponse
                self.tableView.reloadData()
            }
        }
    }
}
