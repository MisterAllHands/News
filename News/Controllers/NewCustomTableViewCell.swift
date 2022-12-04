//
//  NewCustomTableViewCell.swift
//  News
//
//  Created by TTGMOTSF on 18/11/2022.
//

import UIKit

struct NewTableViewCellModel {
    
    let title: String
    let description: String?
    let source: String?
    let image: String
    let urlToImage: URL?
    let imageData: Data? = nil
    
}

class NewCustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    
    var shouldBeBookmarked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //MARK - Fetching outlets with article items
    
    func configure(with model: NewTableViewCellModel){
        
        newsTitleLabel.text = model.title
        newsDescriptionLabel.text = model.description
        sourceLabel.text = model.source
        
        //Fetching image
        if let data = model.imageData {
            
            newsImage.image = UIImage(data: data)
            
        }else if let url = model.urlToImage{
            //fetch
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                
                DispatchQueue.main.async {
                    self?.newsImage.image = UIImage(data: data)
                }
            }.resume()
        }
    }

    
    @IBAction func boomMarkButton(_ sender: UIButton) {
        
        bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
    }
 
    @IBAction func shareButton(_ sender: UIButton) {
        
        
       
    }
    
}
