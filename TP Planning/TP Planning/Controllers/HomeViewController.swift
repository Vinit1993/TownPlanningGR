//
//  ViewController.swift
//  TownPlanning
//
//  Created by Vinit Ingale on 12/24/20.
//

import UIKit
import SideMenuSwift

class HomeViewController: UIViewController {

    @IBOutlet weak var homeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        FileManagerAPI.shared.fetchAllDocs()
        
        SideMenuController.preferences.basic.menuWidth = view.frame.size.width * 0.75
        SideMenuController.preferences.basic.direction = .left
        SideMenuController.preferences.basic.enablePanGesture = true
        SideMenuController.preferences.basic.shouldRespectLanguageDirection = true
        SideMenuController.preferences.basic.supportedOrientations = .allButUpsideDown
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc private func deviceOrientationChanged() {
        let orientation = UIDevice.current.orientation
        if orientation == .portraitUpsideDown || orientation == .faceDown || orientation == .faceUp {
            return
        }
        SideMenuController.preferences.basic.menuWidth = view.frame.size.width * 0.75
    }
    
    @IBAction func menuButtonClicked(_ sender: UIButton) {
        sideMenuController?.revealMenu(animated: true, completion: nil)
    }
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        if let docVC = storyboard?.instantiateViewController(withIdentifier: "DocListViewController") as? DocListViewController {
            docVC.modalPresentationStyle = .fullScreen
            present(docVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func filterButtonClicked(_ sender: UIButton) {
        if let modalViewController = storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController {
            modalViewController.modalPresentationStyle = .fullScreen
            present(modalViewController, animated: true, completion: nil)
        }
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

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

