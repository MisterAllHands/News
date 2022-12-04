//
//  SearchHistory.swift
//  News
//
//  Created by TTGMOTSF on 30/11/2022.
//

import Foundation
import RealmSwift

class SearchHistory: Object {
    @objc dynamic var history: String = ""
}
