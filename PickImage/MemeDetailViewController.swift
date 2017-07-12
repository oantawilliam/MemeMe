//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by William Oanta on 12/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    
    var meme: Meme!
    @IBOutlet weak var memeImage: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.memeImage!.image = meme.memedImage
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
