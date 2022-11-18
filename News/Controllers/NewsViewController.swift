//
//  ViewController.swift
//  News
//
//  Created by TTGMOTSF on 14/11/2022.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = APIResponse(articles: [])
    var apiCaller = APICaller()

    let baseUrl = "https://newsapi.org/v2/everything?q=apple&from=2022-11-13&to=2022-11-13&sortBy=popularity&apiKey="
    let apiKey = "a934aa628f954a48aeec1328b6f79f73"
   

    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        apiCaller.delegate = self
        apiCaller.getNews(from: baseUrl, with: apiKey)
       
        tableView.register(UINib.init(nibName: "TableViewCell", bundle: nibBundle), forCellReuseIdentifier: "goToCell")
        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "goToNews")

        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    //"\(baseUrl)q=\(search)&from=\(date)&\(sortBy)&apiKey=\(apiKey)"
    
  
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goToNews", for: indexPath) as! CustomTableViewCell
       
         let article = viewModel.articles
         cell.newsTitle.text = "Something"
         cell.newsDescription.text = article[indexPath.row].description ?? "No description"
         
         return cell
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
  
}

extension NewsViewController: NewsManagerDelegate{
    
    func didUpdateNews(article: [Article]) {
        self.viewModel.articles = article
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
