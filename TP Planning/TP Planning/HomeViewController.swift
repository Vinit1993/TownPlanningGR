//
//  ViewController.swift
//  TownPlanning
//
//  Created by Vinit Ingale on 12/24/20.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        FileManagerAPI.shared.fetchAllDocs()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (homeCollectionView.frame.size.width - 30) / 2
        return CGSize(width: size, height: 100)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeMainDataHelper.shared.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        cell.nameLabel.text = HomeMainDataHelper.shared.categories[indexPath.row].name
        cell.backgroundColor = HomeMainDataHelper.shared.categories[indexPath.row].color
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = HomeMainDataHelper.shared.categories[indexPath.row]
        if let docVC = storyboard?.instantiateViewController(withIdentifier: "DocListViewController") as? DocListViewController {
            docVC.category = item
            docVC.modalPresentationStyle = .fullScreen
            present(docVC, animated: true, completion: nil)
        }
    }    
}

