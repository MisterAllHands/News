//
//  Model.swift
//  World-News
//
//  Created by TTGMOTSF on 14/11/2022.
//

import Foundation

struct APIResponse: Codable {
    
    var articles: [Article]
}

struct Article: Codable {
    
    let source: Source
    let author: String?
    let title: String
    
    let description: String?
    let url:String
    let urlToImage: String?
    
    var publishedAt: String
    var content: String
}

struct Source: Codable {
    let id: String?
    let name: String
}
