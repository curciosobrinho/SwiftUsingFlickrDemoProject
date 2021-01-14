//
//  SearchViewController.swift
//  Fav Pics
//
//  Created by Curcio Jamunda Sobrinho on 12/01/21.
//

import UIKit
import SDWebImage

class SearchViewController: UIViewController, UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    let tableCellReuse = "tablecellreuse"
    var resultSearchController: UISearchController?
    var searchResults: [(String, Photos)] = [(String, Photos)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSearchController()
    }
    
    func loadSearchController() {
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchBar.sizeToFit()
            controller.searchBar.delegate = self
            tableView.tableHeaderView = controller.searchBar
            return controller
        })()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        
        let searchService = FlickrSearchService()
        
        if let searchText = searchBar.text  {
            
            searchService.request(searchText, pageNo: 1) { (result) in
                
                switch result {
                case .Success(let results):
                    if let photos = results{
                        self.searchResults.insert((searchText, photos), at: 0)
                        self.reloadData()
                        self.dismissSearchBar()
                    }
                case .Failure(let message):
                    // here we would treat the failure with an alert or something
                    print(message)
                    self.dismissSearchBar()

                case .Error(let error):
                    // here we would treat the failure with an alert or something
                    print(error)
                    self.dismissSearchBar() 
                }
                
            }
        }
       
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func dismissSearchBar() {
        DispatchQueue.main.async {
            self.resultSearchController?.isActive = false
        }
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellReuse, for: indexPath)

        let result = self.searchResults[indexPath.row]
        let resultText = result.0
        let resultValue = result.1
        
        cell.textLabel?.text = resultText
        cell.detailTextLabel?.text = String(resultValue.pages * resultValue.perpage)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let result = self.searchResults[indexPath.row]
        let resultValue = result.1
        let title = result.0
        
        callSearchResultVC(photos: resultValue, title: title)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func callSearchResultVC(photos: Photos, title: String) {
        let vc = SearchResultsViewController(photosObj: photos, photos: photos.photo, searchTerm: title)
        vc.title = title
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
