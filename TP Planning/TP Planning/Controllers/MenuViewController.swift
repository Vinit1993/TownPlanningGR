//
//  MenuViewController.swift
//  TownPlanning
//
//  Created by Vinit Ingale on 12/25/20.
//

import UIKit

enum MenuOptions: String {
    case constitution = "Constitution of India"
    case objective = "Objective"
    case aboutUs = "About Us"
    case impLinks = "Important Links"
    case link1 = "Maharashtra Government"
    case link2 = "Urban Development Department, (MH)"
    case link3 = "Town Planning & Valuation Department, (MH)"
    case link4 = "Department of Municipal Administration, (MH)"
    case link5 = "Inspector General of Registrar, (MH)"
    case link6 = "Ministry of Housing & Urban Affairs, Govt. of India "
    case link7 = "Housing Department, (MH)"
    case feedback = "Feedback"
    case share = "Share App"
}

class MenuViewController: UIViewController {

    @IBOutlet weak var tpLogoImageView: UIImageView!
    @IBOutlet weak var menuTableView: UITableView!
    
    var dataArray: [MenuOptions] = [.constitution, .objective, .aboutUs, .impLinks, .link1, .link2, .link3, .link4, .link5, .link6, .link7, .feedback, .share ]
    
    var linkShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }

}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let data = dataArray[indexPath.row]
        
        if (data == .link1 || data == .link2 || data == .link3 ||  data == .link4 || data == .link5 || data == .link6 || data == .link7) {
            if linkShown {
                return UITableView.automaticDimension
            } else {
                return 0.01
            }
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = menuTableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as? MenuTableViewCell else {
            fatalError("MenuTableViewCell not found.")
        }
        
        cell.setUpCell(image: nil, name: dataArray[indexPath.row].rawValue)
        
        let data = dataArray[indexPath.row]
        
        if data == .impLinks {
            if linkShown {
                cell.iconImageView?.image = UIImage(named: "upArrow")
            } else {
                cell.iconImageView?.image = UIImage(named: "downArrow")
            }
        } else {
            cell.iconImageView?.image = nil
        }
        
        if (data == .link1 || data == .link2 || data == .link3 ||  data == .link4 || data == .link5 || data == .link6 || data == .link7) {
            cell.menuNameLabel.textColor = .systemBlue
            cell.menuNameLabel.font = .systemFont(ofSize: 14)
        } else {
            cell.menuNameLabel.textColor = .darkGray
            cell.menuNameLabel.font = .systemFont(ofSize: 16)
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = dataArray[indexPath.row]
        
        switch data {
        case .constitution:
            
            if let docVC = storyboard?.instantiateViewController(withIdentifier: "DocListViewController") as? DocListViewController {
                docVC.isConstitution = true
                docVC.modalPresentationStyle = .fullScreen
                present(docVC, animated: true, completion: nil)
            }
            
        case .objective:
            if let docVC = storyboard?.instantiateViewController(withIdentifier: "ObjectiveViewController") as? ObjectiveViewController {
                docVC.modalPresentationStyle = .fullScreen
                present(docVC, animated: true, completion: nil)
            }
            
        case .aboutUs:            
            if let docVC = storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as? AboutUsViewController {
                docVC.modalPresentationStyle = .fullScreen
                present(docVC, animated: true, completion: nil)
            }
            
        case .impLinks:
            linkShown = !linkShown
            menuTableView.reloadData()
            
        case .link1:
            guard let url = URL(string: "https://www.maharashtra.gov.in") else { return }
            UIApplication.shared.open(url)
            
        case .link2:
            guard let url = URL(string: "https://urban.maharashtra.gov.in") else { return }
            UIApplication.shared.open(url)
            
        case .link3:
            guard let url = URL(string: "https://dtp.maharashtra.gov.in") else { return }
            UIApplication.shared.open(url)
            
        case .link4:
            guard let url = URL(string: "https://mahadma.maharashtra.gov.in") else { return }
            UIApplication.shared.open(url)
            
        case .link5:
            guard let url = URL(string: "http://igrmaharashtra.gov.in") else { return }
            UIApplication.shared.open(url)
            
        case .link6:
            guard let url = URL(string: "http://mohua.gov.in") else { return }
            UIApplication.shared.open(url)
            
        case .link7:
            guard let url = URL(string: "https://housing.maharashtra.gov.in") else { return }
            UIApplication.shared.open(url)
            
        case .feedback:
            
            if let docVC = storyboard?.instantiateViewController(withIdentifier: "FeedbackViewController") as? FeedbackViewController {
                docVC.modalPresentationStyle = .fullScreen
                present(docVC, animated: true, completion: nil)
            }
            
        case .share:
            
            UIGraphicsBeginImageContext(view.frame.size)
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            let textToShare = "I'm using TP Helpline app, why don't you give it a try: "
                    
            if let myWebsite = URL(string: "http://itunes.apple.com/app/id=com.tphelpline") {//Enter link to your app here
                let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                self.present(activityVC, animated: true, completion: nil)
            }
            
        }
    }
}

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView?
    @IBOutlet weak var menuNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setUpCell(image: UIImage?, name: String) {
        iconImageView?.image = image
        menuNameLabel.text = name
    }
}
