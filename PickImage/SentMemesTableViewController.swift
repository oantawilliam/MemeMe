//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by William Oanta on 12/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var memes: [Meme]!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.reloadData()
        
//        if memes.isEmpty {
//            self.goToMemeEditor()
//        } else {
//            tableView.reloadData()
//        }
    }
    
    func goToMemeEditor() {
        let memeEditorController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        self.present(memeEditorController, animated: true, completion: nil)
    }
    
    // MARK: Table Protocols
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell") as! MemeCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.topText?.text = meme.top
        cell.bottomText?.text = meme.bottom
        cell.memeImage?.image = meme.memedImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memeDetailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(memeDetailController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
