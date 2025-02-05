//
//  FeedController.swift
//  FirebaseLogin
//
//  Created by Diggo Silva on 03/02/25.
//

import UIKit

class FeedController: UIViewController {
    
    let feedView = FeedView()
    
    override func loadView() {
        super.loadView()
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
    }
    
    private func setNavBar() {
        title = "VOCÊ ESTÁ NO APP"
        navigationItem.hidesBackButton = true
    }
}
