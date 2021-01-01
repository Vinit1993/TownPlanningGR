//
//  ObjectiveViewController.swift
//  TP Planning
//
//  Created by Vinit Ingale on 12/31/20.
//

import UIKit

class ObjectiveViewController: UIViewController {
    
    @IBOutlet weak var objectiveTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension ObjectiveViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = objectiveTableView.dequeueReusableCell(withIdentifier: "objCell", for: indexPath)
        let string = """
We welcome you to the amazing and creative world of Town Planning. The prime objective of this application is to make town planning related office work effortless, accurate as well as to bring about change and uniformity in practices while working across the various regions in Maharashtra in the field of Town Planning. This application is conceptualized and developed by officers for officers (especially newly recruited), to perform official duties with ease and to attain higher efficiency of work.

We believe that ACTS,RULES, GR's, DIRECTIVES and such other data is quintessential for working in the Government office. This application is one roof treasure for accessing ACTS, GRs, DIRECTIVES, COURT ORDERS and many other things related to Town Planning world. It is an endeavour to make available the data at single source, at your fingertip. This will save official time and expedite the speedy disposal of files. This is a non-profit and an altruistic initiative to help town planning officers' community in Maharashtra and to give an impetus to ease of doing work. We strive to achieve Atmanirbhar (Self Reliant) Town Planning Officer with this application.

Happy Searching.....!
"""
        cell.textLabel?.text = string
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.sizeToFit()
        return cell
    }
}
