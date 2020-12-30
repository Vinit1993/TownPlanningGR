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
    
    var category: Category?
    
    var loadingIndicatorHolder: UIView!
    
    var docListArray: [CategoryDocument] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchDocument()
    }
    
    func showLoadingIndicator(title: String? = "Loading...") {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loadingIndicatorHolder = UIView(frame: .zero)
            strongSelf.loadingIndicatorHolder.translatesAutoresizingMaskIntoConstraints = false
            strongSelf.view.addSubview(strongSelf.loadingIndicatorHolder)
            NSLayoutConstraint.activate([
                strongSelf.loadingIndicatorHolder.leadingAnchor.constraint(equalTo: strongSelf.view.leadingAnchor),
                strongSelf.loadingIndicatorHolder.topAnchor.constraint(equalTo: strongSelf.view.topAnchor),
                strongSelf.loadingIndicatorHolder.trailingAnchor.constraint(equalTo: strongSelf.view.trailingAnchor),
                strongSelf.loadingIndicatorHolder.bottomAnchor.constraint(equalTo: strongSelf.view.bottomAnchor)
            ])
            strongSelf.loadingIndicatorHolder?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            let loadingIndicator = UIActivityIndicatorView()
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
            strongSelf.loadingIndicatorHolder?.addSubview(loadingIndicator)
            loadingIndicator.centerXAnchor.constraint(equalTo: strongSelf.loadingIndicatorHolder.centerXAnchor).isActive = true
            loadingIndicator.centerYAnchor.constraint(equalTo: strongSelf.loadingIndicatorHolder.centerYAnchor).isActive = true
            loadingIndicator.startAnimating()
            let infoLabel = UILabel(frame: CGRect(x: 20, y: 20, width: strongSelf.view.frame.size.width - 40, height: 20))
            infoLabel.text = title
            infoLabel.textColor = UIColor.white
            infoLabel.translatesAutoresizingMaskIntoConstraints = false
            strongSelf.loadingIndicatorHolder.addSubview(infoLabel)
            
            infoLabel.centerXAnchor.constraint(equalTo: loadingIndicator.centerXAnchor, constant: 0).isActive = true
            infoLabel.centerYAnchor.constraint(equalTo: loadingIndicator.centerYAnchor, constant: 30).isActive = true
            infoLabel.textAlignment = .center
            infoLabel.font = .systemFont(ofSize: 14)
            strongSelf.view.addSubview(strongSelf.loadingIndicatorHolder)
        }
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicatorHolder?.removeFromSuperview()
        }
    }
    
    func fetchDocument() {
        docListArray = FileManagerAPI.shared.allDocsArray.filter({$0.categoryValue == category?.value })
    }

    @IBAction func backButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension DocListViewController: UITableViewDataSource, UITableViewDelegate, UIDocumentInteractionControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return docListArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = docsTableView.dequeueReusableCell(withIdentifier: "DocTableViewCell", for: indexPath) as? DocTableViewCell else {
            fatalError("DocTableViewCell not found.")
        }
        cell.docNameLabel.text = docListArray[indexPath.row].documentName
        cell.yearLabel.text = "Year/Date: \(docListArray[indexPath.row].documentYear ?? "N/A")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoadingIndicator()
        let selectedDoc = docListArray[indexPath.row]
        let urlString = FileManagerAPI.shared.baseURL + "doc?path=\(selectedDoc.fullPath)"
        savePdf(urlString: urlString, fileName: selectedDoc.documentName)
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
        hideLoadingIndicator()
        do {
            let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
            for url in contents {
                
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


