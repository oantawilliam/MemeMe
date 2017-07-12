//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by William Oanta on 12/07/2017.
//  Copyright © 2017 William Oanta. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SentMemesCollectionViewController: UICollectionViewController {
    
    var memes: [Meme]!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        collectionView?.reloadData()
    }
    
    func getData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        arrangeCells()
    }
    
    func arrangeCells() {
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
        let meme = self.memes[(indexPath as NSIndexPath).row]
        cell.memeImageView?.image = meme.memedImage
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let memeDetailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(memeDetailController, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
