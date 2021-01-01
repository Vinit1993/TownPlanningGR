//
//  ViewController.swift
//  TP Planning
//
//  Created by Vinit Ingale on 12/25/20.
//

import UIKit

class DocListViewController: UIViewController {
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var docsTableView: UITableView!
    @IBOutlet weak var totalDocLabel: UILabel!
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    var category: Category?
    
    var selectedCategory: Category?
    var selectedSubCategory: SubCategory?
    var selectedLeaftCategory: LeafCategory?
        
    var docListArray: [CategoryDocument] = []
    var searchDocumentsArray: [CategoryDocument] = []
    
    var isConstitution = false
    let constitutionURL = "https://www.india.gov.in/sites/upload_files/npi/files/coi_part_full.pdf"

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDocument()
        
        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        activityIndicator.color = UIColor.systemBlue
        view.addSubview(activityIndicator)
    }
    
    func fetchDocument() {
        if isConstitution {
            searchBar.isHidden = true
            totalDocLabel.isHidden = true
            return
        } else if let cat = category {
            docListArray = FileManagerAPI.shared.allDocsArray.filter({$0.categoryValue == cat.value })
            searchDocumentsArray = docListArray
        } else if let selCat = selectedCategory {
            docListArray = FileManagerAPI.shared.allDocsArray.filter({$0.categoryValue == selCat.value })
            if let subCat = selectedSubCategory {
                docListArray = docListArray.filter({$0.subCategoryValue == subCat.value })
            }
            if let leafCat = selectedLeaftCategory {
                docListArray = docListArray.filter({$0.leafCategoryValue == leafCat.value })
            }
            searchDocumentsArray = docListArray
        } else {
            docListArray = FileManagerAPI.shared.allDocsArray
            searchBar.becomeFirstResponder()
        }
        totalDoc()
    }
    
    func totalDoc() {
        totalDocLabel.text = "Total Document: \(searchDocumentsArray.count)"
    }

    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension DocListViewController: UITableViewDataSource, UITableViewDelegate, UIDocumentInteractionControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isConstitution {
            return 1
        }
        if searchDocumentsArray.count == 0 {
            docsTableView.setEmptyMessage("No documents found!!!")
        } else {
            docsTableView.restore()
        }
        return searchDocumentsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = docsTableView.dequeueReusableCell(withIdentifier: "DocTableViewCell", for: indexPath) as? DocTableViewCell else {
            fatalError("DocTableViewCell not found.")
        }
        if isConstitution {
            cell.docNameLabel.text = "Constitution of India"
            cell.yearLabel.text = nil
        } else {
            cell.docNameLabel.text = searchDocumentsArray[indexPath.row].documentName
            cell.yearLabel.text = "Year/Date: \(searchDocumentsArray[indexPath.row].documentYear ?? "N/A")"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        activityIndicator.startAnimating()
        if isConstitution {
            savePdf(urlString: constitutionURL, fileName: "Constitution of India")
        } else {
            let selectedDoc = searchDocumentsArray[indexPath.row]
            let urlString = FileManagerAPI.shared.baseURL + "doc?path=\(selectedDoc.fullPath)"
            savePdf(urlString: urlString, fileName: selectedDoc.documentName)
        }
    }
    
    
    func savePdf(urlString:String, fileName:String) {
        if pdfFileAlreadySaved(url: urlString, fileName: fileName) {
            showSavedPdf(url: urlString, fileName: fileName)
        } else {
            DispatchQueue.main.async { [weak self] in
                if let urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed), let url = URL(string: urlString)  {
                    let pdfData = try? Data.init(contentsOf: url)
                    let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                    let pdfNameFromUrl = "\(fileName).pdf"
                    let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                    do {
                        try pdfData?.write(to: actualPath, options: .atomic)
                        self?.showSavedPdf(url: urlString, fileName: fileName)
                    } catch {
                        print("Pdf could not be saved")
                    }
                }
            }
        }
    }
    
    func showSavedPdf(url:String, fileName:String) {
        do {
            let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
            for url in contents {
                activityIndicator.stopAnimating()
                if let fileName = fileName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                    if url.description.contains("\(fileName)") {
                        // its your file! do what you want with it!
                        let dc = UIDocumentInteractionController(url: url)
                        dc.delegate = self
                        dc.presentPreview(animated: true)
                        
                    }
                }
            }
        } catch {
            activityIndicator.stopAnimating()
            print("could not locate pdf file !!!!!!!")
        }
        
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    // check to avoid saving a file multiple times
    func pdfFileAlreadySaved(url:String, fileName:String)-> Bool {
        var status = false
        do {
            let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
            for url in contents {
                if let fileName = fileName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                    if url.description.contains("\(fileName)") {
                        status = true
                    }
                }
            }
        } catch {
            print("could not locate pdf file !!!!!!!")
        }
        return status
    }
}

extension DocListViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchDocs(text: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDocs(text: searchBar.text ?? "")
    }
    
    func searchDocs(text: String) {
        if text != "" {
            searchDocumentsArray = docListArray.filter { $0.documentName.lowercased().contains(text.lowercased())}
        } else {
            if category != nil || selectedCategory != nil  {
                searchDocumentsArray = docListArray
            } else {
                searchDocumentsArray = []
            }
        }
        totalDoc()
        docsTableView.reloadData()
    }
}

extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 18)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

class DocTableViewCell: UITableViewCell {

    @IBOutlet weak var docNameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}


