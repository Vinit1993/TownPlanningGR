//
//  FeedbackViewController.swift
//  TP Planning
//
//  Created by Vinit Ingale on 12/31/20.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var feebackTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension FeedbackViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = feebackTableView.dequeueReusableCell(withIdentifier: "FeedbackViewCell", for: indexPath) as? FeedbackViewCell else {
            fatalError("FeedbackViewCell not found.")
        }
        if indexPath.row == 0 {
            cell.setUpCell(image: UIImage(named: "whatsapp"), name: "WhatsApp:", data: "9922979783")
        } else if indexPath.row == 1 {
            cell.setUpCell(image: UIImage(named: "mail"), name: "E-mail:", data: "sbn.parola@gmail.com")
        } else if indexPath.row == 2 {
            cell.setUpCell(image: UIImage(named: "facebook"), name: "Facebook:", data: "saurabhnavarkarSN33")
        } else if indexPath.row == 3 {
            cell.setUpCell(image: UIImage(named: "instagram"), name: "Instagram:", data: "saurabh_navarkar_sn33")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        
        case 0:
            guard let url = URL(string: "whatsapp://send?phone=919922979783") else { return }
            UIApplication.shared.open(url)
            
        case 1:
            guard let url = URL(string: "mailto:sbn.parola@gmail.com") else { return }
            UIApplication.shared.open(url)
            
        case 2:
            guard let url = URL(string: "fb://facewebmodal/f?href=https://www.facebook.com/saurabhnavarkarSN33/") else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                guard let url = URL(string: "https://www.facebook.com/saurabhnavarkarSN33") else { return }
                UIApplication.shared.open(url)
            }
        case 3:
            guard let url = URL(string: "instagram://user?username=saurabh_navarkar_sn33") else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                guard let url = URL(string: "https://www.instagram.com/saurabh_navarkar_sn33") else { return }
                UIApplication.shared.open(url)
            }
                        
        default:
            print("")
        }
    }
    
}

class FeedbackViewCell: UITableViewCell {
    
    @IBOutlet weak var dataImageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setUpCell(image: UIImage?, name: String, data: String) {
        dataImageView?.image = image
        nameLabel.text = name
        dataLabel.text = data
    }
}

