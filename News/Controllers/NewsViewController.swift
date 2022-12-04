//
//  ViewController.swift
//  News
//
//  Created by TTGMOTSF on 14/11/2022.
//

import UIKit
import SafariServices
import ChameleonFramework

class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBar: UIBarButtonItem!
    
    var articless = [Article]()
    var viewModels = [NewTableViewCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = true
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib.init(nibName: "NewCustomTableViewCell", bundle: nil), forCellReuseIdentifier: "NewCustomTableViewCell")
        self.tableView.register(NewCustomTableViewCell.self, forCellReuseIdentifier: "goToNewTableCell")
        fetchNews(selectedCategory: "general")
        
        pullDownMenu()
    }
    
    //MARK: - Fetching News Based on Categories
    
    private func pullDownMenu(actionTitle: String? = nil) -> UIMenu {
        
        let menu = UIMenu(title: "", children: [
            
            UIAction(title: "Top Headlines") { [self] action in
                self.menuBar.menu = pullDownMenu(actionTitle: action.title)
                fetchNews(selectedCategory: "general")
            },
            UIAction(title: "Science") { [self] action in
                self.menuBar.menu = pullDownMenu(actionTitle: action.title)
            },
            UIAction(title: "Health") { [self] action in
                self.menuBar.menu = pullDownMenu(actionTitle: action.title)
            },
            UIAction(title: "Business") { action in
                self.menuBar.menu = self.pullDownMenu(actionTitle: action.title)
            },
            UIAction(title: "Sports") { [ self] action in
                self.menuBar.menu = pullDownMenu(actionTitle: action.title)
            },
            UIAction(title: "Entertainment") { [ self] action in
                self.menuBar.menu = pullDownMenu(actionTitle: action.title)
            }
        ])
        
        if let actionTitle = actionTitle {
            menu.children.forEach { action in
                guard let action = action as? UIAction else {
                    return
                }
                if action.title == actionTitle {
                    action.state = .on
                    fetchNews(selectedCategory: action.title.lowercased()) // fetching news based on selected category
                    navigationItem.title = action.title // changing navifation title to selected category title
                    DispatchQueue.main.async {
                        self.tableView.setContentOffset(.zero, animated: true) // scrolling to the top when another category gets selected
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            let action = menu.children.first as? UIAction
            action?.state = .on
        }
        menuBar.menu = menu
        return menu
    }
    
    func fetchNews(selectedCategory: String) {
        
        APICaller.shared.getNews( category: selectedCategory ,completion: {[weak self] result in
            
            switch result {
            case .success(let articles):
                self?.articless = articles
                self?.viewModels = articles.compactMap({NewTableViewCellModel(
                    title: $0.title,
                    description: $0.description,
                    source: $0.source.name,
                    image: $0.description ?? "No description",
                    urlToImage: URL(string: $0.urlToImage ?? "" ))
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    
    //MARK: - TableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewCustomTableViewCell", for: indexPath) as! NewCustomTableViewCell
        
        cell.configure(with: viewModels[indexPath.row])
        
        cell.shareButton.tag = indexPath.row
        cell.bookmarkButton.tag = indexPath.row
        cell.shareButton.addTarget(self, action: #selector(shareButtonFunc), for: .touchUpInside)
        cell.shareButton.configuration?.cornerStyle = .capsule
        cell.bookmarkButton.configuration?.cornerStyle = .capsule
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Redirecting user to Safari Web Page accoring to their selected article
        let article = articless[indexPath.row]
        
        if let url = URL(string: article.url) {
            
            let vc = SFSafariViewController(url: url)
            vc.modalPresentationStyle = .formSheet
            vc.preferredBarTintColor = .flatSkyBlue()
            vc.preferredControlTintColor = .flatWhite()
            present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 490
    }
    
    @objc public func shareButtonFunc(_ sender: UIButton) {
        
        guard let sharedArticle = articless.first?.url else{return}
        let shareVC = UIActivityViewController(activityItems: [sharedArticle], applicationActivities: nil)
        present(shareVC, animated: true)
        
    }
}
