//
//  Header.swift
//  News
//
//  Created by TTGMOTSF on 02/12/2022.
//

import Foundation
import UIKit

class SearchHeader: UITableViewHeaderFooterView{
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Recently searched"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private let clearButton: UIButton = {
       let clearButton = UIButton()
        clearButton.setTitle("Clean All", for: .normal)

        return clearButton
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(clearButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        label.frame = CGRect(x: 0, y: contentView.frame.size.height-10-label.frame.size.height,
                             width: contentView.frame.size.width,
                             height: label.frame.size.height)
        clearButton.frame = CGRectMake(0 , contentView.frame.size.height-20, contentView.frame.size.width + 300, clearButton.frame.size.height)
    }
}
