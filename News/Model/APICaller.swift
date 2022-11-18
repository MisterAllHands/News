//
//  NewsManager.swift
//  World-News
//
//  Created by TTGMOTSF on 14/11/2022.
//

import Foundation
import UIKit


protocol NewsManagerDelegate {
    func didUpdateNews(article: [Article])
    func didFailWithError(error: Error)
    
}

struct APICaller {
    
    var delegate: NewsManagerDelegate?
    
    
    func getNews(from  url: String, with apiKey: String){
        
        if let url = URL(string: "\(url)\(apiKey)"){
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    
                }else if let safeData = data {
                    
                        let decodedData = self.parseJSON(safeData)
                    delegate?.didUpdateNews(article: decodedData!)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> [Article]? {
        
        let decoder = JSONDecoder()
        
        do {
 
            let decodedData = try decoder.decode(APIResponse.self, from: data)
            let articles = decodedData.articles
            print(articles.count)
            return articles
            
        }catch {
            delegate?.didFailWithError(error: error)
            print(error)
            return nil
        }
    }
}
