//
//  SearchNewsController.swift
//  News
//
//  Created by TTGMOTSF on 19/11/2022.
//

import UIKit
import SafariServices
import RealmSwift
import CoreData

class SearchNewsController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate{
    
    let realm = try! Realm()
    var searchHistory: Results<SearchHistory>?
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var suggestionsTableView: UITableView!
    
    var isShown = false
    var historyVisible = false
   
    
    var suggestions = ["Swift", "Tesla", "Money", "Networking", "Bitcoin", "Amazon"]
    
    var articles = [Article]()
    var viewModels = [NewTableViewCellModel]()
    var searchViewModels = [NewCustomTableViewCell]()
    var newSearchViewModels = [NewCustomTableViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        searchBar.delegate = self
        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        
        suggestionsTableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        suggestionsTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "searchForNews")
        
        suggestionsTableView.register(UINib.init(nibName: "NewCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "NewCustomTableViewCell")
        suggestionsTableView.register(NewCustomTableViewCell.self, forCellReuseIdentifier: "goToNewTableCell")
        
        suggestionsTableView.register(UINib.init(nibName: "SearchHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchHistoryTableViewCell")
        suggestionsTableView.register( SearchHistoryTableViewCell.self , forCellReuseIdentifier: "searchForNews")
        
        suggestionsTableView.register(SearchHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        
        historyVisible = true
        loadHistory()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if historyVisible {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryTableViewCell", for: indexPath) as! SearchHistoryTableViewCell
        
            cell.historySearchButton?.text = searchHistory?[indexPath.row].history ?? "Not Searcged Anyting"
            return cell
            
        }else{
            
            if indexPath.row > suggestions.count {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewCustomTableViewCell", for: indexPath) as! NewCustomTableViewCell
                cell.configure(with: viewModels[indexPath.row])
                cell.shareButton.tag = indexPath.row
                cell.bookmarkButton.tag = indexPath.row
                cell.shareButton.configuration?.cornerStyle = .capsule
                cell.bookmarkButton.configuration?.cornerStyle = .capsule
                cell.shareButton.addTarget(self, action: #selector(shareButtonFunc), for: .touchUpInside)
                return cell
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
                
                if isShown{
                    cell.suggestionLabel.text = suggestions[indexPath.row]
                }else{
                    cell.isHidden = true
                }
                return cell
            }
        }
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if historyVisible{
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            tapRecognizer.delegate = self
            tapRecognizer.numberOfTapsRequired = 1
                tapRecognizer.numberOfTouchesRequired = 1
   
            let seachHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
            seachHeader?.addGestureRecognizer(tapRecognizer)
            return seachHeader

            
        }else{
            return nil
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if historyVisible{
            return 35
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isShown{
            return suggestions.count
        }else{
            if historyVisible{
                
                return searchHistory?.count ?? 2
            }
        }
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        
        if indexPath.row > suggestions.count{
                    
            let article = articles[indexPath.row]
            if let url = URL(string: article.url) {
                
                tableView.deselectRow(at: indexPath, animated: true)
                let vc = SFSafariViewController(url: url)
                vc.modalPresentationStyle = .formSheet
                vc.preferredBarTintColor = .flatSkyBlue()
                vc.preferredControlTintColor = .flatWhite()
                present(vc, animated: true)
                
            }
            
        }else{
            if isShown{
                tableView.deselectRow(at: indexPath, animated: true)
                
                searchBar.text = suggestions[indexPath.row]
                let selectedSearchHistory = SearchHistory()
                selectedSearchHistory.history = searchBar.text!
                saveSearch(searchHistory: selectedSearchHistory)
                isShown = false
                fetchSearch(searchBar.text!)
            }
            if historyVisible{
    
                tableView.deselectRow(at: indexPath, animated: true)
//                let selectedHistory = SearchHistory()
//                print(selectedHistory.history[indexPath.row])
////                searchBar.text = selectedHistory.history[0]
//                historyVisible = false
//                isShown = true
//
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if historyVisible{
            return .delete
        }
        return .none
    }
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if historyVisible{
            tableView.beginUpdates()
            clearHistory(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if historyVisible{
            return 60
        }else{
            if indexPath.row > suggestions.count {
                return 490
            }else{
                if isShown{
                    return 65
                }
            }
        return 0
        }
    }
    
  //MARK - Sharing News
    
    
    @objc public func shareButtonFunc(_ sender: UIButton) {
        
        guard let sharedArticle = articles.first?.url else{return}
        
        let shareVC = UIActivityViewController(activityItems: [sharedArticle], applicationActivities: nil)
        
        present(shareVC, animated: true)
    }
    
    @objc  func handleTap(gestureRecognizer: UIGestureRecognizer){
      
        let alert = UIAlertController(title: "Are you sure you want to delete all search history ?", message: "", preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteHistory )
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
      }
    
    func deleteHistory (action: UIAlertAction){
        
        do{
            try realm.write({
                realm.delete(realm.objects(SearchHistory.self))
                loadHistory()
            })
        }catch{
            fatalError()
        }
    }
}

//MARK: - Implemeting SearchBar

extension SearchNewsController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        isShown = false
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        let newSeachHistory = SearchHistory()
        newSeachHistory.history = text

        saveSearch(searchHistory: newSeachHistory)
        fetchSearch(text)
        searchBar.resignFirstResponder()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text!.count > 0 {
            DispatchQueue.main.async {
                self.historyVisible = false
                self.isShown = true
                self.suggestionsTableView.reloadData()
            }
        }else{
            DispatchQueue.main.async {
                self.isShown = true
                self.searchBar.resignFirstResponder()
                self.suggestionsTableView.reloadData()
                self.isShown = false
                self.historyVisible = true
                self.suggestionsTableView.reloadData()
            }
        }
    }
    
    //MARK - Fetching query based on search text
    
    func fetchSearch(_ inText: String){
        
        APICaller.shared.getNews(with: inText, completion: {[weak self] result in
            
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({NewTableViewCellModel(
                    title: $0.title,
                    description: $0.description,
                    source: $0.source.name,
                    image: $0.description ?? "No description",
                    urlToImage: URL(string: $0.urlToImage ?? "" ))
                })
                
                DispatchQueue.main.async {
                    self?.suggestionsTableView.reloadData()
                    
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}
    //MARK: - Saving search history


extension SearchNewsController {
    
    //Saving Items

    func saveSearch(searchHistory: SearchHistory){
        
        do{
            try realm.write {
                realm.add(searchHistory)
            }
        }catch{
            fatalError("Error while save history search: \(error)")
        }

        suggestionsTableView.reloadData()
    }
    
    //Updating items

    func loadHistory(){
        searchHistory = realm.objects(SearchHistory.self)
        suggestionsTableView.reloadData()
    }
    //Deleting Items
    
    func clearHistory(at indexpath: IndexPath){
        if let deletedHistorySearch = self.searchHistory?[indexpath.row]{
            do{
                try realm.write({
                    realm.delete(deletedHistorySearch)
                })
            }catch{
                fatalError("Error while deleting the item in the search history: \(error)")
            }
        }
    }
}

