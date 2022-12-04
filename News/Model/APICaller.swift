//
//  NewsManager.swift
//  World-News
//
//  Created by TTGMOTSF on 14/11/2022.
//

import Foundation
import UIKit


struct APICaller {
    
    static let shared = APICaller()
        
    let baseUrl = "https://newsapi.org/v2/top-headlines?country=us"
    let searchUrl = "https://newsapi.org/v2/everything?"
    let apiKey = "apiKey=a934aa628f954a48aeec1328b6f79f73"
  


    //MARK - Requesting data
    
    func getNews(category: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        
        if let url = URL(string: "\(baseUrl)&category=\(category)&\(apiKey)") {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                //MARK - Parsing JSON
                
                if error != nil {
                    completion(.failure(error!))
                }else if let safeData = data {
                    
                    do{
                        let decodedData = try JSONDecoder().decode(APIResponse.self, from: safeData)
                        print(decodedData.articles)
                        completion(.success(decodedData.articles))
                        
                    }catch{
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
    
    func getNews(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        if let url = URL(string: "\(searchUrl)q=\(query)&\(apiKey)") {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                //MARK - Parsing JSON
                
                if error != nil {
                    completion(.failure(error!))
                }else if let safeData = data {
                    
                    do{
                        let decodedData = try JSONDecoder().decode(APIResponse.self, from: safeData)
                        print(decodedData.articles)
                        completion(.success(decodedData.articles))
                        
                    }catch{
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        }
    }
    
}
