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
    
    var isFetchInProgress = false
    var searchText = ""
    var searchResults:[SearchResult] = []
    let pageLimit:Int = 10
    public var searchResponse: SearchResponse? {
        didSet {
            if let value = self.searchResponse {
                self.searchResults += value.results
            } else {
                self.searchResults = []
            }
        }
    }
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
        return searchResponse?.totalCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchMusicTableViewCell", for: indexPath) as! MovieTableViewCell
        if isLoadingCell(for: indexPath) {
            cell.configureCell(with: .none)
        } else {
            let resultItem = self.searchResults[indexPath.row]
            cell.configureCell(with: resultItem)
            self.downloadImage(resultItem.poster, indexPath: indexPath)
        }
        
        return cell
    }
}

// MARK:- tableview delegate methods

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !isLoadingCell(for: indexPath) else {
            return
        }
        let resultItem = self.searchResults[indexPath.row]
        performSegue(withIdentifier: "DetailViewController", sender: resultItem)
    }
}

extension HomeViewController: UISearchBarDelegate  {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let count = searchBar.text?.trimmingCharacters(in: .whitespaces).count, count >= 3 else {
            return
        }
        searchResponse = nil
        searchText = searchBar.text!
        getSearchResult(text: searchBar.text!, page: 1)
        searchController.isActive = false
    }
}

extension HomeViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell(for:)), let nextPage = self.getNextPage() {
            getSearchResult(text: searchText, page: nextPage)
        }
    }
}

extension HomeViewController {
    
    func initialSetUp() {
        configureActivityIndicator()
        let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SearchMusicTableViewCell")
        tableView.prefetchDataSource = self
    }
}

extension HomeViewController {
    
    func getSearchResult(text: String, page: Int) {
        guard !isFetchInProgress else {
            return
        }
        isFetchInProgress = true
        self.spinner.startAnimating()
        MovieSearchService.sharedService.sendSearchRequest(with: text, page: page) { (searchResponse, error) in
            self.spinner.stopAnimating()
            if let error = error {
                self.showAlert("Movie not found!")
                print(error.localizedDescription)
            } else {
                self.isFetchInProgress = false
                self.searchResponse = searchResponse
                if self.searchResults.count <= self.pageLimit {
                    self.tableView.reloadData()
                } else {
                    let indexPathsToReload = self.calculateIndexPathsToReload(from: searchResponse!.results)
                    let visibleIndexPaths = self.visibleIndexPathsToReload(intersecting: indexPathsToReload)
                    self.tableView.beginUpdates()
                    self.tableView.reloadRows(at: visibleIndexPaths, with: .automatic)
                    self.tableView.endUpdates()
                }
            }
        }
    }
}

extension HomeViewController {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= self.searchResults.count
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    private func calculateIndexPathsToReload(from newSearchResult: [SearchResult]) -> [IndexPath] {
        let startIndex = self.searchResults.count - newSearchResult.count
        let endIndex = startIndex + newSearchResult.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    public func getNextPage() -> Int? {
        if let searchResponse = self.searchResponse, self.searchResults.count > 0 {
            if self.searchResults.count == searchResponse.totalCount {
                return nil
            } else {
                let currentPage = self.searchResults.count / pageLimit
                return currentPage + 1
            }
        } else {
            return 1
        }
        
    }
    
}

