//
//  AboutUsViewController.swift
//  TP Planning
//
//  Created by Vinit Ingale on 12/31/20.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var aboutUsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension AboutUsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 360.0
        }
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier = "conceptCell"
        if indexPath.row == 1 {
            identifier = "appCell"
        } else if indexPath.row == 2 {
            identifier = "contriCell"
        } else if indexPath.row == 3 {
            identifier = "voteCell"
        }
        let cell = aboutUsTableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        return cell
    }
}
