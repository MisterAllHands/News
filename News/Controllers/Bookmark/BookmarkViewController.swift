//
//  BookmarkViewController.swift
//  News
//
//  Created by TTGMOTSF on 19/11/2022.
//

import UIKit

class BookmarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var bmTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bmTableView.dequeueReusableCell(withIdentifier: "bookMarks", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

}
