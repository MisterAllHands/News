//
//  CustomTabBarController.swift
//  News
//
//  Created by TTGMOTSF on 22/11/2022.
//

import UIKit
import RAMAnimatedTabBarController

class CustomTabBarController: RAMAnimatedTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func loadItems() {
                
                let v1 = NewsViewController()
                let v2 = SearchNewsController()
                let v3 = BookmarkViewController()
                
                (v1.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMFlipRightTransitionItemAnimations()
                (v2.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMFumeAnimation()
                (v3.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMFlipTopTransitionItemAnimations()
                
                setViewControllers([v1,v2,v3], animated: false)
            }
    }
}
